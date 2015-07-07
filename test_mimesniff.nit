# Test suite for the mimesniff module.
module test_mimesniff is test_suite

import test_suite
import mimesniff

class TestBytes
	super TestSuite

	fun test_mime_type_spaces do
        var data = new Bytes("".to_cstring, 0, 0)
        var mt = data.mime_type
        assert mt == "text/plain; charset=utf-8" else
            print("got {mt}")
        end

        var spaces = "          "
        data.append_ns(spaces.to_cstring, spaces.length)
        mt = data.mime_type
        assert mt == "text/plain; charset=utf-8" else
            print("got {mt}")
        end

        spaces *= 2
        data.append_ns(spaces.to_cstring, spaces.length)
        mt = data.mime_type
        assert mt == "text/plain; charset=utf-8" else
            print("got {mt}")
        end
	end

    fun test_mime_type_html do
        var cases = [
            "<!DOCTYPE HTML>",
            "<HTML>",
            "    <html >",
            "<!doctype html>",
            " <H1> ",
            "\n<!-- "
        ]
        for tc in cases do
            var data = new Bytes(tc.to_cstring, tc.length, tc.length)
            var mt = data.mime_type
            assert mt == "text/html; charset=utf-8" else
                print("case {tc}, got {mt}")
            end
        end
    end

    fun test_mime_type_pdf do
        var pdf = "%PDF-"
        var data = new Bytes(pdf.to_cstring, pdf.length, pdf.length)
        var mt = data.mime_type
        assert mt == "application/pdf" else
            print("got {mt}")
        end
    end

    fun test_mime_type_plain do
        var cases = [
            "<!DOCTYPE htm>",
            "<HTML",
            "%PDF"
        ]
        for tc in cases do
            var data = new Bytes(tc.to_cstring, tc.length, tc.length)
            var mt = data.mime_type
            assert mt == "text/plain; charset=utf-8" else
                print("case {tc}, got {mt}")
            end
        end
    end
end
