# Entry point of the nitfind command.
module cmd

import opts

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
opt_ctx.add_option(usage, ctx_after, ctx_before, ctx_lines, patterns)
opt_ctx.parse(args)

var rest = opt_ctx.rest
if rest.length == 0 and patterns.value.length == 0 then
    print("A pattern to match must be specified\n")
    opt_ctx.usage
    exit(-1)
end

print("hello! {ctx_lines.value}, {ctx_before.value}, {ctx_after.value}, {patterns.value}, {opt_ctx.rest}")
