# Test suite for the matcher module.
module test_matcher is test_suite

import test_suite
import matcher

private abstract class MatchCase
    var expect: Bool
    var val: String

    fun matcher: Matcher is abstract
end

private class ReCase
    super MatchCase

    var regex: String
    var ignore_case: Bool

    redef fun matcher
    do
        var compiled = regex.to_re
        if ignore_case then compiled.ignore_case = true
        return new ReMatcher(compiled)
    end
end

class TestReMatcher
	super TestSuite

	fun test_match do
        var cases = [
            new ReCase(true, "", "", false),
            new ReCase(true, "a", "", false),
            new ReCase(true, "a", "a", false),
            new ReCase(true, "a", ".", false),
            new ReCase(false, "", ".", false),
            new ReCase(false, "a", "A", false),
            new ReCase(true, "a", "A", true),
            new ReCase(true, "Nit is pretty Awesome", "nit \\w+ .*some", true)
        ]

        for tc in cases do
            var got = tc.matcher.match(tc.val)
            assert got == tc.expect else 
                print("regex {tc.regex} with value {tc.val} failed (ignore case? {tc.ignore_case})")
            end
        end
	end
end

private class LitCase
    super MatchCase

    var lit: String
    var ignore_case: Bool

    redef fun matcher
    do
        return new LitMatcher(lit, ignore_case)
    end
end

class TestLitMatcher
    super TestSuite

    fun test_match do
        var cases = [
            new LitCase(true, "", "", false),
            new LitCase(true, "a", "a", false),
            new LitCase(false, "a", "A", false),
            new LitCase(true, "a", "A", true),
            new LitCase(true, "abc", "BC", true),
            new LitCase(true, "Nit is pretty Awesome!", "SOME!", true),
            new LitCase(false, "Nit is pretty Awesome!", "SOME!", false)
        ]

        for tc in cases do
            var got = tc.matcher.match(tc.val)
            assert got == tc.expect else 
                print("literal {tc.lit} with value {tc.val} failed (ignore case? {tc.ignore_case})")
            end
        end
    end
end
