#
module matcher

#
interface Matcher
    #
    fun match(line: String): Bool is abstract
end

#
class ReMatcher
    super Matcher
end

#
class LitMatcher
    super Matcher
end

#
class GlobMatcher
    super Matcher
end

#
class AnyMatcher
    super Matcher
end

#
class AllMatcher
    super Matcher
end
