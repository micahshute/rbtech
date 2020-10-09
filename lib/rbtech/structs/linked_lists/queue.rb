class Rbtech::Queue


    def initialize()
        @list = Rbtech::DoublyLinkedList.new
    end

    def push(val)
        @list << val
    end

    def shift
        return @list.shift
    end

    def length
        @list.length
    end

    def size
        length
    end


end