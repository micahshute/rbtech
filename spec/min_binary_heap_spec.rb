require 'ostruct'
RSpec.describe Rbtech::MinBinaryHeap do 


  describe "#heapify" do

    it "can be instantiated with an unordered array and turned into a heapified ds" do
       r = Random.new
      unordered_arr = Array.new(100){r.rand(1000)}
      min_heap = described_class.new(nodes: unordered_arr)
      # min_heap.heapify
      expect(min_heap.size).to eq(100)
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

    it "allows a block to be entered to specify how to compare nodes" do 
      r = Random.new

      unordered_arr = Array.new(100){OpenStruct.new(data: r.rand(1000))}
      min_heap = described_class.new(nodes: unordered_arr, key: :data)
      expect(min_heap.size).to eq(100)
      for i in 0...min_heap.size
        parent = min_heap.nodes[i]
        right_child = min_heap.right_child(i)
        left_child = min_heap.left_child(i)
        if right_child
          expect(parent.data).to be <= right_child.data
        end
        if left_child
          expect(parent.data).to be <= left_child.data
        end
      end
    end 

  end

  describe "#pop" do
    it "returns the smallest element in the heap" do
      r = Random.new
      unordered_arr = Array.new(1000){ r.rand(10000) }
      min_heap = described_class.new(nodes: unordered_arr)
      val = min_heap.pop
      while true
        nextval = min_heap.pop
        if nextval
          expect(val).to be <= nextval
          val = nextval
        else
          break
        end
      end
    end

    it "allows an object's key to be entered to specify how to compare nodes" do 
      r = Random.new
      unordered_arr = Array.new(1000){ OpenStruct.new(distance: r.rand(100000)) }
      min_heap = described_class.new(nodes: unordered_arr, key: :distance)
      val = min_heap.pop
      while true
        nextval = min_heap.pop
        if nextval 
          expect(val.distance).to be <= nextval.distance
          val = nextval
        else
          break
        end
      end
    end 
  end

# end

# it "is faster than an array for repeatedly finding the minimum value" do
#   expect { ... }.to perform_faster_than { ... }
# end

  describe "better than an array at:" do 
    it "repeatedly finding the minimum value" do
      r = Random.new
      data = Array.new(10000){ r.rand(10000000)}
      data2 = data.dup

      # expect { 
      5.times do 
        t1 = Time.now
        heap = described_class.new(nodes: data)
        val = heap.pop
        while val
          val = heap.pop
        end
        t2 = Time.now
        heap_time = t2 - t1
      # }.to perform_faster_than {  # This kept saying "Same time" even though heap was significantly faster...
        t3 = Time.now
        test_data = data2.dup
        while test_data.length > 0
            min = test_data.min
            test_data.delete(min) 
        end
        t4 = Time.now
        heap_time = t2 - t1
        array_time = t4 - t3
        puts "Heap time: #{heap_time}; Array time: #{array_time}"
        expect(heap_time).to be < array_time
      # }
      end
    end

    it "adding information into the structure and then removing it in order" do
      r = Random.new
      data = Array.new(10000){ r.rand(1000000)}
      data2 = data.dup
      5.times do
      # expect { 
        t1 = Time.now
        heap = described_class.new(nodes: data)
        while heap.size > 0
          rand_i = heap.current_to_original_mapping[r.rand(heap.size)]
          heap.update_key(rand_i){ r.rand(10000000) } 
          val = heap.pop
        end
        t2 = Time.now
      # }.to perform_faster_than {  # Saying same runtime when this was not the case
        # TODO: Code my own time check that works better than Time.now and this 
        # rspec-benchmark library which does not work well
        t3 = Time.now
        test_data = data2.dup
        while test_data.length > 0
          test_data[r.rand(test_data.length)] = r.rand(10000000)
          min = test_data.min
          test_data.delete(min) 
        end
        t4 = Time.now
        heap_time = t2 - t1
        array_time = t4 - t3
        puts "Heap time: #{heap_time}; Array time: #{array_time}"
        expect(heap_time).to be < array_time
      # }
      end
    end
  end


  describe "trackable" do
    it "keeps track of current location of nodes based on their original order" do
      r = Random.new
      original_nodes = Array.new(1000){ r.rand(1000000)}
      heap = described_class.new(nodes: original_nodes)
      original_nodes.each.with_index do |el, i|
        expect(heap.get_node(i)).to eq(el)
      end
      while heap.size > 0
        original_location = heap.current_to_original_mapping[0]
        expect(heap.pop).to eq(original_nodes[original_location])
      end
    end
  end

  describe "#update_node and #update_key" do
    it "updates the correct node" do
      r = Random.new
      nodes = Array.new(1000){ r.rand(1000000) }
      heap = described_class.new(nodes: nodes)
      100.times do |i|
        rand_i = r.rand(heap.size)
        new_val = r.rand(1000000)
        expect(heap.get_node(rand_i)).to eq(nodes[rand_i])
        heap.update_node(rand_i, ->(e){new_val})
        expect(heap.get_node(rand_i)).to eq(new_val)
        nodes[rand_i] = new_val
      end

      r = Random.new
      nodes = Array.new(1000){ r.rand(1000000) }
      heap = described_class.new(nodes: nodes)
      100.times do |i|
        rand_i = r.rand(heap.size)
        new_val = r.rand(1000000)
        expect(heap.get_node(rand_i)).to eq(nodes[rand_i])
        heap.update_key(rand_i){ new_val }
        expect(heap.get_node(rand_i)).to eq(new_val)
        nodes[rand_i] = new_val
      end

      r = Random.new
      nodes = Array.new(1000){ r.rand(1000000) }
      heap = described_class.new(nodes: nodes)
      100.times do |i|
        rand_i = r.rand(heap.size)
        new_val = r.rand(1000000)
        expect(heap.get_node(rand_i)).to eq(nodes[rand_i])
        heap.update_key(rand_i, new_val)
        expect(heap.get_node(rand_i)).to eq(new_val)
        nodes[rand_i] = new_val
      end
    end

    it "updates the node location to the correct spot" do
      r = Random.new
      nodes = Array.new(1000){ r.rand(1000000) }
      heap = described_class.new(nodes: nodes)
      100.times do 
        rand_i = r.rand(heap.size)
        new_val = r.rand(1000000)
        heap.update_node(rand_i, ->(e){new_val})
        heap.nodes.each.with_index do |el, i|
          left_child = heap.left_child(i)
          right_child = heap.right_child(i)
          if left_child
            expect(el).to be <= left_child
          end
          if right_child
            expect(el).to be <= right_child
          end
        end
      end

      r = Random.new
      nodes = Array.new(1000){ r.rand(1000000) }
      heap = described_class.new(nodes: nodes)
      100.times do 
        rand_i = r.rand(heap.size)
        new_val = r.rand(1000000)
        heap.update_key(rand_i){new_val}
        heap.nodes.each.with_index do |el, i|
          left_child = heap.left_child(i)
          right_child = heap.right_child(i)
          if left_child
            expect(el).to be <= left_child
          end
          if right_child
            expect(el).to be <= right_child
          end
        end
      end

      r = Random.new
      nodes = Array.new(1000){ r.rand(100000) }
      heap = described_class.new(nodes: nodes)

      100.times do 
        rand_i = r.rand(heap.size)
        new_val = r.rand(100000)
        heap.update_key(rand_i, new_val)
        heap.nodes.each.with_index do |el, i|
          left_child = heap.left_child(i)
          right_child = heap.right_child(i)
          if left_child
            expect(el).to be <= left_child
          end
          if right_child
            expect(el).to be <= right_child
          end
        end
      end


    end

    it "allows an object to be put into a heap with a specified key" do 
      r = Random.new
      nodes = Array.new(1000){ OpenStruct.new(data: r.rand(100000))}
      heap = described_class.new(nodes: nodes, key: :data)

      100.times do 
        rand_i = r.rand(heap.size)
        new_val = r.rand(100000)
        heap.update_key(rand_i){ |e| e.data = new_val; e }
        heap.nodes.each.with_index do |el, i|
          left_child = heap.left_child(i)
          right_child = heap.right_child(i)
          if left_child
            expect(el.data).to be <= left_child.data
          end
          if right_child
            expect(el.data).to be <= right_child.data
          end
        end
      end
    end 

    it "allows a value to be passed in as a second argument" do

      r = Random.new
      nodes = Array.new(1000){ OpenStruct.new(data: r.rand(100000))}
      heap = described_class.new(nodes: nodes, key: :data)

      100.times do 
        rand_i = r.rand(heap.size)
        new_val = r.rand(100000)
        heap.update_key(rand_i, new_val)
        heap.nodes.each.with_index do |el, i|
          left_child = heap.left_child(i)
          right_child = heap.right_child(i)
          if left_child
            expect(el.data).to be <= left_child.data
          end
          if right_child
            expect(el.data).to be <= right_child.data
          end
        end
      end

    end

  end

  describe "#add_node" do 
    it "adds a node" do 

    end

    it "puts the new node in its correct position" do

    end

    it "keeps track properly in the node mapping arrays" do

    end

    it "allows a block to be entered to specify how to compare nodes" do 
      expect(false).to eq(true)
    end 
  end


  describe "#delete_node" do 
    it "properly deletes a node" do 

    end

    it "maintains the heap property" do 

    end

    it "allows a block to be entered to specify how to compare nodes" do 
      expect(false).to eq(true)
    end 

  end


  describe "#increase_key" do


  end


  describe "#decrease_key" do

  end


end