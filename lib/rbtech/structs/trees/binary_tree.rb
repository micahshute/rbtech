class Rbtech::BinaryTree 

    include Rbtech::TreeMethods

    def initialize(nodes: [])
        @nodes = nodes 
    end

    def root
        @nodes[0]
    end

    def size
        @nodes.length
    end

    def parent_index(index)
        i = (index - 1) / 2
        i < 0 ? nil : i
    end

    def left_child_index(parent_index)
        i = parent_index * 2 + 1
        i >= size ? nil : i
    end

    def right_child_index(parent_index)
        i = parent_index * 2 + 2
        i >= size ? nil : i 
    end

    def right_child(parent_index)
        @nodes[right_child_index(parent_index)]
    end

    def left_child(parent_index)
        @nodes[left_child_index(parent_index)]
    end

    def add(node)
        @nodes << node
    end

    def update(index: , with: )
        @nodes[index] = with
    end


end