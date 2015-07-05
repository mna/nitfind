# Test suite for the circular_buffer module.
module test_circular_buffer is test_suite

import test_suite
import circular_buffer

class TestCircularBuffer
	super TestSuite

	fun test_length do
        var buf = new CircularBuffer(3)
        assert buf.length == 0

        buf.add("a")
        assert buf.length == 1

        buf.add("b")
        assert buf.length == 2

        buf.add("c")
        assert buf.length == 3

        buf.add("d")
        assert buf.length == 3

        buf.add("e")
        assert buf.length == 3
	end

	fun test_add do
        with_cap(1, ["a", "b", "c", "d", "e", "f", "i", "o"])
        with_cap(2, ["a", "ab", "bc", "cd", "de", "ef", "hi", "no"])
        with_cap(3, ["a", "ab", "abc", "bcd", "cde", "def", "ghi", "mno"])
        with_cap(4, ["a", "ab", "abc", "abcd", "bcde", "cdef", "fghi", "lmno"])
	end

    private fun with_cap(cap: Int, want: Array[String]) do
        var buf = new CircularBuffer(cap)
        var s = buf.plain_to_s
        assert s == "" else
            print("empty buf with cap {cap}")
        end

        var want_ix = 0
        for v in ['a'..'f'] do
            buf.add(v.to_s)
            s = buf.plain_to_s
            assert s == want[want_ix] else
                print("cap {cap}, after add {v}, want {want[want_ix]}, got {s}")
            end
            want_ix += 1
        end

        var v = ["g", "h", "i"]
        buf.add_all(v)
        s = buf.plain_to_s
        assert s == want[want_ix] else
            print("cap {cap}, after add {v}, want {want[want_ix]}, got {s}")
        end
        want_ix += 1

        v = ["j", "k", "l", "m", "n", "o"]
        buf.add_all(v)
        s = buf.plain_to_s
        assert s == want[want_ix] else
            print("cap {cap}, after add {v}, want {want[want_ix]}, got {s}")
        end
    end
end
