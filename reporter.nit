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

    redef fun report(path, hits) do
        print(path.green)

        # TODO : sort hits by start_line

        var line_no = 0
        for hit in hits do
            if line_no > 0 and hit.start_line != line_no then print("--".yellow)
            line_no = hit.start_line
            for line in hit.lines do
                if line_no == hit.hit_line then
                    print("{line_no}:".yellow + line)
                else
                    print("{line_no}-".yellow + line)
                end
            end
            line_no += 1
        end
    end
end
