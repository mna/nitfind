#
module file_filter

import matcher

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
end
