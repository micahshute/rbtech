class Rbtech::CircularDoublyLinkedList < Rbtech::DoublyLinkedList

    def initialize(len=0, val=nil, &block)
        super(len, val, &block)
        @head.prev = @tail
        @tail.next = @head
    end

    def loop 
        node = @head.next
        return nil if node.tail?
        i = 0
        while true
            yield(node, i)
            node = node.next
            while node.head? || node.tail? 
                node = node.next
            end
            i += 1
        end
    end

    def reverse_loop
        node = @tail.prev
        return nil if node.head?
        i = 0
        while true
            yield(node, i)
            node = node.prev
            while node.head? || node.tail?
                node = node.prev
            end
            i += 1
        end
    end

end