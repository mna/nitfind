# Finder exports the types required to find patterns
# in some files.
module finder

import matcher
import file_resolver
import reporter

#
class Finder
    var matcher: Matcher
    var resolver: FileResolver
    var reporter: Reporter

    fun find: Int do
        var files = resolver.files
        for file in files do
            var reader = file.to_path.open_ro
            for line in reader.each_line do
                if matcher.match(line) then
                end
            end
            reader.close
        end
        return 0
    end
end
