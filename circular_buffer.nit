# This module implements a circular buffer.
module circular_buffer

# Class CircularBuffer implements buffer that holds at most the last
# `capacity` elements written to it.
class CircularBuffer
    super SimpleCollection[String]

    # capacity is the size of the circular buffer.
    private var capacity: Int
    # next_index is the index at which the next element will go.
    private var next_index: Int = 0
    # buffer is the internal store of the circular buffer.
    private var buffer = new Array[String]

    init do
        assert capacity > 0
        buffer.enlarge(capacity)
    end
    
    redef fun length do return buffer.length

    redef fun iterator do return new CircularBufferIterator(self)

    # add writes the provided element in the circular buffer.
    redef fun add(s) do
        if buffer.length == next_index then
            buffer.add(s)
        else
            buffer[next_index] = s
        end
        next_index = (next_index + 1) % capacity
    end

    # TODO : implement remove?
    redef fun remove(item) do abort

    # TODO : will need an enlarge method, as the buffer required to hold
    # a hit may be > than the contextual lines + 1, because more hits can
    # occur within the contextual lines.

    redef fun clear do
        buffer.clear
        next_index = 0
    end
end

private class CircularBufferIterator
    super Iterator[String]

    var ix: Int = 0
    var iters: Int = 0
    var buf: CircularBuffer

    init do
        # start index goes like this: if the buffer is not filled to
        # capacity, then first element is index 0, otherwise first
        # element == next_index
        if buf.length == buf.capacity then ix = buf.next_index
    end

    redef fun item do
        assert is_ok
        return buf.buffer[ix]
    end

    redef fun next do
        ix = (ix + 1) % buf.capacity
        iters += 1
    end

    redef fun is_ok do
        return iters < buf.length
    end
end
