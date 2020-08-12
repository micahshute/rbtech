class Rbtech::LinkedListNode

    TYPES = [
        :NODE,
        :HEAD_SENTINEL,
        :TAIL_SENTINEL
    ]

    attr_accessor :data
    attr_reader :next, :list

    def initialize(data, list: nil,type: :NODE)
        @data = data
        @list = list
        raise ArgumentError.new("Type must be one of: #{TYPES}") if !TYPES.include?(type)
        @type = type
        @next = nil
    end

    def next=(n)
        # if !tail?
        raise ArgumentError.new("Must be a LinkedList Node") if !n.respond_to?(:next)
        @next = n
            # else
            #     raise ArgumentError.new("You cannot set the next property on a tail sentinel") 
            # end
    end

    def value
        @data
    end

    def attach_tail(tail)
        raise ArgumentError.new("Argument must be a tail node") if !tail.tail? || !tail.is_a?(self.class)
        self.next = tail
    end

    def insert(n)
        node = to_node(n)
        node.next = @next 
        @next = node
        increment_list_length
    end

    def <(n)
        self.data < n.data
    end

    def >(n)
        self.data > n.data
    end

    def <=>(n)
        self.data <=> n.data
    end

    def delete_next
        raise ArgumentError.new("Cannot delete sentinels") if self.next.tail?
        self.next = self.next.next
        decrement_list_length
    end

    def head?
        @type == :HEAD_SENTINEL
    end

    def tail?
        @type == :TAIL_SENTINEL
    end

    private

    def to_node(dat)
        if dat.is_a?(self.class)
            dat.list = @list if dat.list.nil?
            raise ArgumentError.new("Use LinkedList#concat or #+ to join two linked lists together") if dat.list.object_id != @list.object_id
            dat
        else
            self.class.new(dat, list: @list)
        end
    end

    def increment_list_length
        @list.instance_variable_set("@length", @list.length + 1)
    end

    def decrement_list_length
        @list.instance_variable_set("@length", @list.length - 1)
    end

end