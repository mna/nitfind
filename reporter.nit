# Module reporter implements hits reporting strategies.
module reporter

import circular_buffer
import standard::console

# Hit is a matching hit in a file.
class Hit
    # start_line is the line number of the first line in the buffer.
    var start_line: Int
    # TODO : will need a collection of hit_lines, since other hits may
    # occur in the contextual before/after lines.
    var hit_line: Int
    # lines is the circular buffer holding the hit and potentially some
    # contextual lines before and after the hit.
    var lines: CircularBuffer
end

# Reporter is the interface the defines the report method.
interface Reporter
    # report is the method that reports search hits for a single file.
    fun report(path: String, hits: Array[Hit]) is abstract
end

# AckReporter is an ack-style reporter that displays colorized hits
# to stdout.
class AckReporter
    super Reporter

    private var reported_once = false
    private var has_ctx = false

    # create a reporter with the specified contextual lines.
    init with_ctx_lines(before, after: Int) do
        has_ctx = (before + after) > 0
    end

    redef fun report(path, hits) do
        if reported_once then print("")
        reported_once = true
        if path.has_prefix("./") then path = path.substring_from(2)
        print(path.green.bold)

        # no need to sort hits by start_line, assume they are stored
        # in the right order.

        var line_no = 0
        for hit in hits do
            if has_ctx and line_no > 0 and hit.start_line != line_no then print("--".yellow)
            line_no = hit.start_line
            for line in hit.lines do
                if line_no == hit.hit_line then
                    print("{line_no}:".yellow.bold + line)
                else
                    print("{line_no}-".yellow.bold + line)
                end
            end
            line_no += 1
        end
    end
end
