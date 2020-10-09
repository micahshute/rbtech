class Rbtech::Stack
    def initialize()
        @list = Rbtech::DoublyLinkedList.new
    end

    def push(val)
        @list << val
    end

    def pop
        @list.pop
    end

    def length
        @list.length
    end

    def size
        length
    end
end