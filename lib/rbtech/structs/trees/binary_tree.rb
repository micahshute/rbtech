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
        @nodes[right_child_index(parent_i)]
    end

    def left_child(parent_i)
        @nodes[left_child_index(parent_i)]
    end

    def add(node)
        @nodes << node
    end

    def update(index: , with: )
        @nodes[index] = with
    end


end