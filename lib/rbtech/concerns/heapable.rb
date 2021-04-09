module Rbtech::Heapable

    include Rbtech::TrackableNodes

    # def self.included(klass)
    #     klass.class_eval do 
    #         include Rbtech::TrackableNodes
    #     end
    # end

    # APIs required to include:
    # #children_indices -> return array of all children indices given a node index
    # @heap_type must be set upon instantiation (to a valid value in HEAP_TYPES)
    # #parent_index needed for bubble_up

    HEAP_TYPES = [
        :min,
        :max
    ]

    def insert(val, &block)
        if !block_given?
            block = ->(a){a}
        end
        location = add_node(val)
        bubble_up(location, &block)
    end

    # &block is handed a node and is in charge of returning the 
    # property that should be evaluated by the should_swap_predicate
    def heapify_node(node_index, &block)
        heap_type = @heap_type
        raise ArgumentError.new("@heap_type must be one of the following: #{HEAP_TYPES}") if !HEAP_TYPES.include?(heap_type)

        should_swap_predicate = predicate
        if !block_given?
            block = ->(a){a}
        end

        cis = children_indices(node_index)
        minmax_index = node_index
        minmax_node = nodes[node_index]

        for i in 0...cis.length
            if should_swap_predicate[block[nodes[cis[i]]], block[minmax_node]]
                minmax_index = cis[i]
                minmax_node = nodes[cis[i]]
            end
        end

        if minmax_index != node_index
            swap_nodes(node_index, minmax_index)
            heapify_node(minmax_index, &block) 
        end
    end

    def heapify(&block)
        for i in (nodes.length - 1).downto(0) 
            heapify_node(i, &block)
        end
    end

    def pop_iter(predicate_fn, &block)
        while nodes.length > 0
            yield(pop_root(&predicate_fn))
        end
    end

    def delete_node(index, &block) 
        # swap first node and node at index
        # delete first node (pop)
        # buble_up node at index (first node)
    end

    def pop_root(&block)
        return nil if nodes.length == 0
        if nodes.length == 1
            orig_val = current_to_original_mapping[0]
            current_to_original_mapping[0] = nil
            original_to_current_mapping[orig_val] = nil
            return nodes.pop
        end
        last = nodes.pop
        popval = nodes[0]
        nodes[0] = last
        original_last = current_to_original_mapping[nodes.length]
        original_first = current_to_original_mapping[0]
        original_to_current_mapping[original_first] = nil
        original_to_current_mapping[original_last] = 0
        current_to_original_mapping[0] = original_last
        current_to_original_mapping[nodes.length] = nil
        heapify_node(0, &block)
        popval
    end

    def update_node(index , update_proc, &comparison_proc)
        if !block_given?
            comparison_proc = ->(a){a}
        end
        relative_index = get_current_node_index(index)
        update(relative_index, update_proc)
        bubble_up(relative_index, &comparison_proc)
        heapify_node(relative_index, &comparison_proc)
    end

    def increase_value(index, update_proc, &comparison_proc)
        if !block_given?
            comparison_proc = ->(a){a}
        end
        relative_index = get_current_node_index(index)
        case @heap_type
        when :min
            update_heapify_node(relative_index, update_proc, &comparison_proc)
        when :max
            update_bubble_up(relative_index, update_proc, &comparison_proc)
        else
            raise ArgumentError.new("Incorrect @heap_type given: #{@heap_type}; must be in #{HEAP_TYPES}")
        end
    end

    def decrease_value(index, update_proc, &comparison_proc)
        if !block_given?
            comparison_proc = ->(a){a}
        end
        relative_index = get_current_node_index(index)
        case @heap_type
        when :min
            update_bubble_up(relative_index, update_proc, &comparison_proc)
        when :max
            update_heapify_node(relative_index, update_proc, &comparison_proc)
        else
            raise ArgumentError.new("Incorrect @heap_type given: #{@heap_type}; must be in #{HEAP_TYPES}")
        end
    end

    def peek
        nodes[0]
    end


    private

    def predicate
        case @heap_type
        when :min
            return ->(a,b){ a < b}
        when :max
            return ->(a,b){ a > b}
        else
            raise StandardError("Incorrect @heap_type given, curent value is #{@heap_type}")
        end
    end

    def update(index, update_proc)
        @nodes[index] = update_proc[@nodes[index]]
    end

    # Used if decreasing a value in a min node
    # or increasing a value in a max node

    # Block input -> node ; output -> updated/new node
    def bubble_up(index, &comparison_proc)
        pi = parent_index(index)
        i = index
        should_swap = predicate
        while pi && should_swap[comparison_proc[@nodes[i]], comparison_proc[@nodes[pi]]]
            swap_nodes(pi, i)
            i = pi
            pi = parent_index(i)
        end
    end 

    def update_bubble_up(index, update_proc, &comparison_proc)
        update(index, update_proc)
        bubble_up(index, &comparison_proc)
    end

    # Used if increase a value in min node
    # or decreasing a value in a max node
    def update_heapify_node(index, update_proc, &comparison_proc)
        update(index, update_proc)
        heapify_node(index, &comparison_proc)
    end


end