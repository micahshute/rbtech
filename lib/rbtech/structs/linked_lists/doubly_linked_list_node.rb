class Rbtech::DoublyLinkedListNode < Rbtech::LinkedListNode
    
    attr_accessor :data
    attr_reader :prev

    def initalize(data, type: :NODE, list: nil)
        super(data, type, list)
        @prev = nil
    end

    def next=(n)
        # if !n.tail?
        raise ArgumentError.new("Prev must be a DoublyLinkedListNode") if !(n.respond_to?(:next) && n.respond_to?(:prev))
        @next = n
        # else
        #     raise ArgumentError.new("Cannot set next on a tail sentinel")
        # end 
    end

    def prev=(p)
        # if !head?
        raise ArgumentError.new("Prev must be a DoublyLinkedListNode") if !(p.respond_to?(:next) && p.respond_to?(:prev))
        @prev = p
        # else
        #     raise ArgumentError.new("You cannot set prev to a head sentinel")
        # end
    end

    def attach_tail(tail)
        super(tail)
        tail.prev = self
    end

    def insert(dat)
        super(dat)
        self.next.prev = self
        if !self.next.tail?
            self.next.next.prev = self.next
        end
    end

    def delete_next
        super
        self.next.prev = self
    end

    def delete
        raise ArgumentError.new("Cannot delete sentinels") if head? || tail?
        self.prev.next = self.next
        self.next.prev = self.prev
        decrement_list_length
    end

    

end