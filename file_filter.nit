# This module defines the file filter that returns the list of files
# that must be searched.
module file_filter

import matcher
import standard::file

#
abstract class AbstractFileFilter
    #
    fun files: Array[String] is abstract
end

#
class DirFileFilter
    super AbstractFileFilter

    #
    var root: String

    # matcher determines if a file should be included or not in the
    # files to return.
    var matcher: Matcher

    #
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
                if matcher.match(f) then
                    list.add(dir/f)
                end
            else if stat.is_dir and level < max_depth then
                find_in_dir(dir/f, level + 1, list)
            end
        end
    end
end
