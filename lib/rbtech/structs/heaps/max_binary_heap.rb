class Rbtech::MaxBinaryHeap < Rbtech::BinaryTree

    include Rbtech::Heapable

    def initialize(nodes: [])
        super(nodes: nodes)
        @heap_type = :max
    end

    def children_indices(i)
        [left_child_index(i), right_child_index(i)].filter{|el| !el.nil?}
    end

end