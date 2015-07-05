# Test suite for the file_filter module.
module test_file_filter is test_suite

import test_suite
import file_filter

class TestDirFileFilter
	super TestSuite

    fun test_files do
        var m = new LitMatcher("e", false)
        var ff = new DirFileFilter(".", m)

        var got = ff.files
        assert got.length > 0
    end
end
