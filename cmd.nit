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
var file_patterns = patterns.value
if file_patterns.is_empty then file_patterns = [rest.shift]

# If no directory/files are specified, search in the current directory.
var dir = "."
if rest.length > 0 then dir = rest[0] # TODO : support multiple directories/files

var resolver = new DirFileResolver(dir, new PassthroughMatcher)
var reporter = new AckReporter

# Buid the matchers
var matchers = new Array[Matcher]
for pat in file_patterns do
    matchers.add(new LitMatcher(pat, false)) # TODO : support flags for regex, case insensitive
end
var all_matcher = new AllMatcher
all_matcher.add_matchers(matchers...)

var finder = new Finder(all_matcher, resolver, reporter)
finder.find
