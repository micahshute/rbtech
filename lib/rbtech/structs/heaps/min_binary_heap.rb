class Rbtech::MinBinaryHeap < Rbtech::BinaryTree

    include Rbtech::Heapable


    def initialize
        @heap_type = :min
    end

    def children_indices(i)
        [left_child_index(i), right_child_index(i)].filter{|el| !el.nil? }
    end

end