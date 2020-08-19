class Rbtech::DoublyLinkedList < Rbtech::AbstractLinkedList

    def initialize(len=0, val=nil, &block)
        if block_given?
            super(Rbtech::DoublyLinkedListNode, len, &block)
        else
            super(Rbtech::DoublyLinkedListNode, len, val)
        end
    end

    def node_at(i)
        index = i < 0 ? length + i : i
        return nil if index >= length || index < 0
        if index > length / 2
            from_back = length - index
            curr_node = @tail
            from_back.times do 
                curr_node = curr_node.prev
            end
        else
            curr_node = @head.next
            index.times do 
                curr_node = curr_node.next
            end
        end
        curr_node
    end

    def [](i, endi=nil)
        if i.is_a?(Integer) && endi.nil?
            n = node_at(i)
            n ? n.value : nil
        elsif i.is_a?(Range)
            raise TypeError.new('no implicit conversion of Range into Integer') if !endi.nil?
            start_i = i.begin
            end_i = i.exclude_end? ? i.end - 1 : i.end
            start_i = length + start_i if start_i < 0
            end_i = length + end_i if end_i < 0 
            size = end_i - start_i + 1
            return nil if end_i < start_i
            node = self.node_at(start_i)
            self.class.new(size) do 
                val = node.data
                node = node.next
                val
            end
        elsif !endi.nil?
            start_i = i
            end_i = endi
            node = self.[](start_i..end_i)
        else
            raise ArgumentError.new("You must provide an index or range of indices")
        end
    end

    def reverse
        curr_node = @tail
        self.class.new(length) do 
            curr_node = curr_node.prev
            curr_node.data
        end
    end
end