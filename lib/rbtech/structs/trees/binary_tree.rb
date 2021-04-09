class Rbtech::BinaryTree 

    include Rbtech::TreeMethods

    attr_reader :nodes

    def initialize(nodes: [])
        @nodes = nodes.dup
    end

    def root
        @nodes[0]
    end

    def size
        @nodes.length
    end

    def parent_index(index)
        return nil if index >= nodes.length
        i = (index - 1) / 2
        i < 0 ? nil : i
    end

    def parent(index)
        i = parent_index(index)
        i.nil? ? i : @nodes[i]
    end

    def left_child_index(parent_i)
        i = parent_i * 2 + 1
        i >= size ? nil : i
    end

    def right_child_index(parent_i)
        i = parent_i * 2 + 2
        i >= size ? nil : i 
    end

    def right_child(parent_i)
        rci = right_child_index(parent_i)
        rci.nil? ? nil : @nodes[rci]
    end

    def left_child(parent_i)
        lci = left_child_index(parent_i)
        lci.nil? ? nil : @nodes[lci]
    end

    def add(node)
        @nodes << node
    end

    def update(index: , to: )
        @nodes[index] = to
    end


end