class Rbtech::MinBinaryHeap < Rbtech::BinaryTree

    include Rbtech::Heapable


    def initialize(nodes: [], key: nil)
        super(nodes: nodes)
        @heap_type = :min
        @key = key
        @comparison_proc = key ? ->(node){node.send(key)} : ->(node){node}
        self.heapify(&@comparison_proc)
    end

    def children_indices(i)
        [left_child_index(i), right_child_index(i)].filter{|el| !el.nil? }
    end

    def increase_key(index, newval=nil, &update)
        if !block_given?
            if newval.nil?
                raise ArgumentError.new("You must either add a new value or an update proc")
            else
                @key ? increase_value(index, ->(e){ e.send("#{@key}=", newval); e }, &@comparison_proc) : increase_value(index, ->(e){ newval }, &@comparison_proc)
            end
        else
            if newval
                raise ArgumentError.new("Yout cannot have both a new value and an update proc")
            else
                increase_value(index, update, &@comparison_proc)
            end
        end
    end

    def decrease_key(index, newval=nil, &update)
        if !block_given?
            if newval.nil?
                raise ArgumentError.new("You must either add a new value or an update proc")
            else
                @key ? decrease_value(index, ->(e){ e.send("#{@key}=", newval); e }, &@comparison_proc) : decrease_value(index, ->(e){ newval }, &@comparison_proc)
            end
        else
            raise ArgumentError.new("Yout cannot have both a new value and an update proc") if newval
            decrease_value(index, update, &@comparison_proc)
        end
        
    end 

    def update_key(index, newval=nil, &update)
        if !block_given?
            if newval.nil?
                raise ArgumentError.new("You must either add a new value or an update proc")
            else
                @key ? update_node(index, ->(e){ e.send("#{@key}=", newval); e }, &@comparison_proc) : update_node(index, ->(e){ newval }, &@comparison_proc)
            end
        else
            if newval
                raise ArgumentError.new("Yout cannot have both a new value and an update proc") 
            else
                update_node(index, update, &@comparison_proc)
            end
        end
    end

    def add(node)
        insert(node, &@comparison_proc)
    end

    def pop_each(&block)
        pop_iter(@comparison_proc, &block)
    end

    def pop
        pop_root(&@comparison_proc)
    end



end