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
end
