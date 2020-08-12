class Rbtech::SinglyLinkedList < Rbtech::AbstractLinkedList

    def initialize(len=0, val=nil, &block)
        if block_given?
            super(Rbtech::LinkedListNode, len, val, &block)
        else
            super(Rbtech::LinkedListNode, len, val)
        end
    end

    def [](i, endi=nil)
        if i.is_a?(Integer) && endi.nil?
            index = i < 0 ? length + i : i 
            return nil if index < 0
            node = @head.next
            return nil if node.tail?
            index.times do 
                node = node.next
                return nil if node.tail?
            end
            node
        elsif i.is_a?(Range)
            raise TypeError.new('no implicit conversion of Range into Integer') if !endi.nil?
            start_i = i.begin
            end_i = i.exclude_end? ? i.end - 1 : i.end
            start_i = length + start_i if start_i < 0
            end_i = length + end_i if end_i < 0 
            size = end_i - start_i + 1
            return nil if end_i < start_i
            node = self.[](start_i)
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

    


end