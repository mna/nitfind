# This module implements detection of the mime-type based on a
# small preview of the content's data.
#
# This is a port from Go's net/http/sniff.go algorithm.
module mimesniff

redef class Bytes
    private var sniff_signatures: Array[Signature] = [
        (new HtmlSignature("<!DOCTYPE HTML")).as(Signature),
        new HtmlSignature("<HTML"),
        new HtmlSignature("<HEAD"),
        new HtmlSignature("<SCRIPT"),
        new HtmlSignature("<IFRAME"),
        new HtmlSignature("<H1"),
        new HtmlSignature("<DIV"),
        new HtmlSignature("<FONT"),
        new HtmlSignature("<TABLE"),
        new HtmlSignature("<A"),
        new HtmlSignature("<STYLE"),
        new HtmlSignature("<TITLE"),
        new HtmlSignature("<B"),
        new HtmlSignature("<BODY"),
        new HtmlSignature("<BR"),
        new HtmlSignature("<P"),
        new HtmlSignature("<!--"),
        new MaskedSignature("text/xml; charset=utf-8", "\xff\xff\xff\xff\xff\xff", "<?xml", true),
        new ExactSignature("application/pdf", "%PDF-"),
        new ExactSignature("application/postscript", "%!PS-Adobe-"),
        new TextSignature
    ]


    # mime_type detects the MIME type of the contents of the Bytes buffer.
    fun mime_type: String do
        # find the index of the first non-space char
        var first_non_ws = 0
        for ix in [0..self.length[ do
            var ch = self[ix].ascii
            if not is_whitespace(ch) then
                break
            end
            first_non_ws += 1 # so that no ws means it points 1 after last
        end

        for sig in sniff_signatures do
            if sig.match(self, first_non_ws) then
                return sig.mime_type
            end
        end
        return "application/octet-stream"
    end
end

private abstract class Signature
    var mime_type: String is noinit

    fun match(data: Bytes, first_non_ws: Int): Bool is abstract
end

private class MaskedSignature
    super Signature

    redef var mime_type
    var mask: String
    var pat: String
    var skip_ws: Bool

    redef fun match(data, first_non_ws) do
        var start = 0
        if skip_ws then start = first_non_ws
        if (data.length - start) < mask.length then return false

        for ix in [0..mask.length[ do
            var data_ch = data[start + ix]
            var mask_ch = mask[ix].ascii
            var ch = data_ch & mask_ch
            if ch != pat[ix].ascii then return false
        end
        return true
    end
end

private class ExactSignature
    super Signature

    redef var mime_type
    var sig: String

    redef fun match(data, first_non_ws) do
        if data.length < sig.length then return false

        for ix in [0..sig.length[ do
            if data[ix].ascii != sig.chars[ix] then return false
        end
        return true
    end
end

private class TextSignature
    super Signature

    redef var mime_type = "text/plain; charset=utf-8"

    redef fun match(data, first_non_ws) do
        for ix in [first_non_ws..data.length[ do
            var data_byte = data[ix]
            if (0x00 <= data_byte and data_byte <= 0x08) or
               (data_byte == 0x0B) or
               (0x0E <= data_byte and data_byte <= 0x1A) or
               (0x1C <= data_byte and data_byte <= 0x1F) then
               return false
           end
        end
        return true
    end
end

private class HtmlSignature
    super Signature

    redef var mime_type = "text/html; charset=utf-8"
    var sig: String

    redef fun match(data, first_non_ws) do
        var length = data.length - first_non_ws
        if length < sig.length + 1 then return false

        for ix in [0..sig.length[ do
            var sig_ch = sig[ix]
            var data_ch = data[first_non_ws + ix].ascii

            if 'A' <= sig_ch and sig_ch <= 'Z' then
                data_ch = (data_ch.ascii & 0xDF).ascii
            end
            if data_ch != sig_ch then return false
        end
        # next byte must be space or >
        var next_ch = data[first_non_ws + sig.length].ascii
        return next_ch ==  ' ' or next_ch == '>'
    end
end

private fun is_whitespace(ch: Char): Bool do
    return ['\t', '\f', '\n', '\r', ' '].has(ch)
end
