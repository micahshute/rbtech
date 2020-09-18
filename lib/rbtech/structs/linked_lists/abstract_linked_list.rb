class Rbtech::AbstractLinkedList

    include Enumerable
    include Cycleable

    def self.new_from_array(arr)
        new(arr.length) do |i|
            arr[i]
        end
    end

    attr_reader :head, :tail, :length

    alias_method :size, :length

    def initialize(node_type, len, val=nil, &block)
        raise ArgumentError.new("Len must be in integer, not #{len}") if !len.is_a?(Integer)
        @node_type = node_type
        set_head @node_type.new(nil, type: :HEAD_SENTINEL, list: self)
        set_tail @node_type.new(nil, type: :TAIL_SENTINEL, list: self)
        @head.attach_tail(@tail)
        @length = 0
        if len != 0
            if block_given?
                curr_node = @head
                len.times do |i|
                    dat = yield(i)
                    next_node = @node_type.new(dat, list: self)
                    curr_node.insert(next_node)
                    curr_node = next_node
                end
            else
                curr_node = @head
                len.times do |i|
                    next_node = node_type.new(val, list: self)
                    curr_node.insert(next_node)
                    curr_node = next_node
                end
            end
        end
    end

    def each_node(&block)
        if block_given?
            node = @head.next
            until node.tail? do 
                yield node
                node = node.next
            end
            self
        else
            to_enum(:each)
        end
    end


    def each(&block)
        if block_given?
            node = @head.next
            until node.tail? do 
                yield node.value
                node = node.next
            end
            self
        else
            to_enum(:each)
        end
    end

    def map(&block) 
        if block_given?
            node = @head.next
            self.class.new(self.length) do 
                val = yield(node.value)
                node = node.next
                val
            end
        else
            to_enum(:map)
        end
    end

    def filter(&block)
        if block_given?
            new_vals = []
            node = @head.next
            while !node.tail?
                should_add = yield(node.value)
                new_vals << node.value if should_add
                node = node.next
            end
            self.class.new_from_array(new_vals) 
        else
            to_enum(:filter)
        end
    end

    def sort(&block)
        if block_given?
            self.class.new_from_array(self.to_a.sort(&block))
        else
            self.class.new_from_array(self.to_a.sort)
        end
    end

    def sort_by(attr)
        self.class.new_from_array(self.to_a.sort_by(attr))
    end

    def delete_at(index)
        index = index < 0 ? length + index : index
        raise ArgumentError.new("Index out of range") if index < 0 || index >= length
        if index == 0
            shift
        elsif index == length - 1
            pop
        else
            node = self.[](index - 1)
            node.delete_next
        end

    end

    def node_at(i)
        raise NotImplementedError.new("Implement node_at method") 
    end
    
    def [](i)    
        raise NotImplementedError.new("Implement [] method")   
    end

    def reverse
        raise NotImplementedError.new("Override this method")
    end

    def []=(i, val)
        raise ArgumentError.new("#{i} must be an Integer not a #{i.class}") if !i.is_a?(Integer)
        node_to_change = self.node_at(i)
        raise ArgumentError.new("LinkedList out of bounds") if node_to_change.nil?
        if val.is_a?(@node_type)
            node_to_change.data = val.data
        else
            node_to_change.data = val
        end
    end

    def insert(i, *vals)
        count = 0
        for val in vals
            if i < 0
                insert_data(val, at_index: i)
            else
                insert_data(val, at_index: i + count)
                count += 1
            end
        end
    end

    def first
        self.[](0)
    end


    def last
        self.[](-1)
    end

    def to_s
        to_a.to_s
    end

    def insert_data(val, at_index: )
        new_node = to_node(val)
        if at_index == 0
            @head.insert(new_node)
        elsif at_index >= length
            # TODO: Make custom error
            raise ArgumentError.new("Exceeded LinkedList length")
        else
            prev_node = self.node_at(at_index - 1)
            prev_node.insert(new_node)
        end
    end

    def unshift(val)
        node = to_node(val)
        @head.insert(node)
    end

    def shift
        if @length == 0
            nil
        else
            to_del = @head.next
            @head.delete_next
            to_del.value
        end
    end
     
    def ==(ll)
        return false if ll.class != self.class
        return false if ll.length != self.length
        my_node = self.node_at(0)
        ll_node = ll.node_at(0)
        self.length.times do 
            return false if my_node.data != ll_node.data
            my_node = my_node.next
            ll_node = ll_node.next
        end
        return false if !my_node.tail? || !ll_node.tail?
        return true
    end

    def pop
        if @length == 0
            nil
        else
            second_to_last_node = self.node_at(-2)
            second_to_last_node ||= @head
            to_del = second_to_last_node.next
            second_to_last_node.delete_next
            to_del.value
        end
    end

    

    def push(arg)
        node = to_node(arg)
        if length == 0
            first_node = @head
            @head.insert(node)
        else
            last_node = self.node_at(-1)
            last_node.insert(node)
        end

    end

    def <<(arg)
        push(arg)
    end

    def concat(ll)
        raise ArgumentError.new("LinkedLists must be of the same type to concat") if !ll.is_a?(self.class)
        len = self.length + ll.length
        self_a = to_a
        lla = ll.to_a
        self.class.new(len) do |i|
            if i < self.length
                self_a[i]
            else
                lla[i - self.length]
            end
        end
    end

    def +(ll)
        concat(ll)
    end

    def reverse
        self.class.new_from_array(self.to_a.reverse)
    end

    def tortoise_hare
        super(self.node_at(0), ->(current_node){
            return nil if current_node.nil? || current_node.next.tail?
            return current_node.next
        })
    end

    private

    def set_head(new_head)
        @head = new_head
    end

    def set_tail(new_tail)
        @tail = new_tail
    end

    def is_linked_list_node?(arg)
        arg.is_a? @node_type
    end

    def to_node(dat)
        if dat.is_a?(@node_type)
            raise ArgumentError.new("Use LinkedList#concat or #+ to join two linked lists together") if dat.list != self
            dat
        else
            @node_type.new(dat, list: self)
        end
    end

end