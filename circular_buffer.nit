#
module circular_buffer

#
class CircularBuffer
    var capacity: Int
    var next_index: Int
    var buffer = new Array[String]

    # TODO: ensure capacity > 0
    init do buffer.enlarge(capacity)
    
    fun add(s: String)
    do
        if buffer.length == next_index then
            buffer.add(s)
        else
            buffer[next_index] = s
        end
        next_index = (next_index + 1) % capacity
    end
end
