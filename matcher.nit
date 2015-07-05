# Module matcher defines a common interface to match some text,
# and concrete implementations that offer various ways to do the
# matching.
module matcher

import standard::re
import standard::file

# Matcher is the interface that defines the match method.
interface Matcher
    # match returns true if the provided string is a match,
    # false otherwise.
    fun match(s: String): Bool is abstract
end

# ReMatcher is a matcher that compares the given text with a regular
# expression.
class ReMatcher
    super Matcher

    # regex is the compiled regular expression to use for the match.
    var regex: Regex

    redef fun match(s)
    do
        return s.has(regex)
    end
end

# LitMatcher is a matcher that compares the given text with a literal
# string.
class LitMatcher
    super Matcher

    # substr is the literal string to match.
    var substr: String
    # ignore_case indicates if the match is case sensitive or not.
    var ignore_case: Bool

    init
    do
        if ignore_case then substr = substr.to_lower
    end

    redef fun match(s)
    do
        if ignore_case then s = s.to_lower
        return s.has(substr)
    end
end

# GlobMatcher is a matcher that compares the given text with a glob-like
# pattern, where * means zero or more characters and ? means a single
# character. More advanced shell-recognized glob patterns are not supported.
class GlobMatcher
    super Matcher
end

# MultiMatcher is a matcher that process many matchers.
abstract class MultiMatcher
    super Matcher

    # matchers is the list of matchers
    protected var matchers = new Array[Matcher]

    # add_matchers appends the provided matchers to the list of matchers.
    fun add_matchers(list: Matcher...)
    do
        matchers.add_all(list) 
    end
end

# AnyMatcher is a matcher that attempts a match with all of its matchers,
# stopping at the first match.
class AnyMatcher
    super MultiMatcher

    redef fun match(s)
    do
        for m in matchers do
            if m.match(s) then return true
        end
        return false
    end
end

# AllMatcher is a matcher that must match with all of its matchers to
# return true, stopping at the first non-match.
class AllMatcher
    super MultiMatcher

    redef fun match(s)
    do
        for m in matchers do
            if not m.match(s) then return false
        end
        return true
    end
end
