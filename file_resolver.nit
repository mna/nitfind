# This module defines the file resolver that returns the list of files
# that must be searched.
module file_resolver

import matcher
import standard::file

# Interface that defines the files method.
interface FileResolver
    # Returns the list of files to search.
    fun files: Array[String] is abstract
end

# DirFileResolver is a FileResolver that looks for files to process in
# a given directory, possibly traversing it recursively.
class DirFileResolver
    super FileResolver

    # root directory to process.
    var root: String

    # file_matcher determines if a file should be included or not in the
    # files to return.
    var file_matcher: Matcher

    # dir_matcher determines if a directory should be processed or not.
    var dir_matcher = new PassthroughMatcher

    # maximum depth to recursively process under the root directory. No
    # recursive processing means max_depth = 0 (will only process files
    # directly in root).
    var max_depth: Int = 6

    redef fun files
    do
        var files = new Array[String]
        find_in_dir(root, 0, files)
        return files
    end

    private fun find_in_dir(dir: String, level: Int, list: Array[String])
    do
        var files = dir.files
        for f in files do
            var stat = (dir/f).to_path.stat
            if stat == null then continue
            if stat.is_file then
                if file_matcher.match(f) then
                    list.add(dir/f)
                end
            else if stat.is_dir and level < max_depth and dir_matcher.match(f) then
                find_in_dir(dir/f, level + 1, list)
            end
        end
    end
end
