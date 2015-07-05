# Test suite for the file_resolver module.
module test_file_resolver is test_suite

import test_suite
import file_resolver

class TestDirFileResolver
	super TestSuite

    fun test_files do
        var m = new LitMatcher("e", false)
        var ff = new DirFileResolver(".", m)

        var got = ff.files
        assert got.length > 0
        assert got.has("./test_file_resolver.nit")
    end
end
