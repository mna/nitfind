# Entry point of the nitfind command.
module cmd

import opts
import matcher
import reporter
import finder

var opt_ctx = new OptionContext
opt_ctx.options_before_rest = true

var usage = new OptionText("""Usage: nitfind [OPTIONS] PATTERN [FILES OR DIRECTORIES]

Search for PATTERN in each source file in the tree rooted at the current 
directory. If any FILES or DIRECTORIES are specified, then only those are
searched. Multiple PATTERNs to search can be specified using the --match 
flag.
""")
var ctx_lines = new OptionInt("Print NUM lines of output context", 0, "-C", "--context")
var ctx_before = new OptionInt("Print NUM lines of leading context before matching lines", 0, "-B", "--before-context")
var ctx_after = new OptionInt("Print NUM lines of trailing context after matching lines", 0, "-A", "--after-context")
var patterns = new OptionArray("Pattern to match, may be set more than once", "--match")
var help = new OptionBool("Display usage text", "-h", "--help")

opt_ctx.add_option(usage, ctx_after, ctx_before, ctx_lines, help, patterns)
opt_ctx.parse(args)

var rest = opt_ctx.rest
if rest.length == 0 and patterns.value.length == 0 then
    print("A pattern to match must be specified")
    opt_ctx.usage
    exit(-1)
end

# If patterns is empty, then the pattern is the first rest parameter.
var search_patterns = patterns.value
if search_patterns.is_empty then search_patterns = [rest.shift]

# If no directory/files are specified, search in the current directory.
var dir = "."
if rest.length > 0 then dir = rest[0] # TODO : support multiple directories/files

# By default, ignore dotfiles and dot directories
# TODO : support flag to alter this behaviour
var dot_matcher = new ReMatcher("^\\.".to_re)
var nodot_matcher = new NotMatcher(dot_matcher)
var resolver = new DirFileResolver(dir, nodot_matcher)
resolver.dir_matcher = nodot_matcher

var reporter = new AckReporter.with_ctx_lines(ctx_before.value, ctx_after.value)

# Buid the matchers
var matchers = new Array[Matcher]
for pat in search_patterns do
    matchers.add(new LitMatcher(pat, false)) # TODO : support flags for regex, case insensitive
end
var all_matcher = new AllMatcher
all_matcher.add_matchers(matchers...)

var finder = new Finder(all_matcher, resolver, reporter)
if finder.find == 0 then exit(1)
