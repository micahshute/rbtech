class Rbtech::CircularLinkedList < Rbtech::SinglyLinkedList

    def initialize(len=0, val=nil, &block)
        super(len, val, &block)
        @tail.next = @head
    end


    def loop 
        node = @head.next
        return nil if node.tail?
        i = 0
        while true
            yield(node.value, i)
            node = node.next
            while node.head? || node.tail? 
                node = node.next
            end
            i += 1
        end
    end


end