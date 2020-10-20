RSpec.describe Rbtech::MinBinaryHeap do 

  it "does something useful" do
    expect(false).to eq(true)
  end

  describe "#heapify" do

    it "can be instantiated with an unordered array and turned into a heapified ds" do
       r = Random.new
      unordered_arr = Array.new(100){r.rand(1000)}
      min_heap = described_class.new(nodes: unordered_arr)
      min_heap.heapify
      for i in 0...min_heap.nodes.length
        parent = min_heap.nodes[i]
        right_child = min_heap.right_child(i)
        left_child = min_heap.left_child(i)
        if right_child
          expect(parent).to be <= right_child
        end
        if left_child
          expect(parent).to be <= left_child
        end
      end
    end

  end

end

