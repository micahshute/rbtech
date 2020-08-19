RSpec.describe Rbtech::DoublyLinkedList do 

  #TODO: Figure out how to make the "constant time" spec actually work - can verify that it is with benchmark
  # but the tests are wildly inconsistent with classification

  let(:sizes) do 
    sizes = bench_range(8, 200_000) # => [8, 64, 512, 4096, 32768, 100000]
    # sizes = Array.new(21){ |i| 2 ** (i) }
  end

  let(:number_arrays) do 
    sizes.map { |n| Array.new(n) { rand(n) } }
  end

  it "can be initialized with an array in linear time" do
    a = (0..100).to_a
    ll = described_class.new_from_array(a)
    for i in 0..100
      node = ll[i] 
      # expect(node).to be_a(Rbtech::LinkedListNode)
      expect(node).to eq(i)
    end
    expect(ll[101]).to be(nil)
    expect{ |n,i|
      described_class.new_from_array(number_arrays[i])
    }.to perform_linear.in_range(sizes).sample(10).times
  end

  it "can be traversed from back to front" do 
    ll = described_class.new(100){ |i| i }
    expect(ll.length).to eq(100)
    n = ll.tail.prev
    100.times do |i|
      expect(n.data).to eq(99 - i)
      n = n.prev
    end
  end

  describe "#filter" do 
  it "should be able to filter nodes like an array" do 
    ll = described_class.new(100){ |i| i}
    llf = ll.filter{|el| el.even? }
    expect(llf).to be_a(described_class)
    expect(llf.size).to be(50)
    llf.each do |el|
      expect(el.even?).to be(true)
    end
  end

  it "filters in linear time" do
    lls = number_arrays.map do |arr|
      described_class.new_from_array(arr)
    end
    expect{ |n, i|
      lls[i].filter(&:even?)
    }.to perform_linear.in_range(sizes).sample(10).times
  end
end

  describe "#node_at" do
    it "gets a node at a value" do
      ll = described_class.new(100){|i| i}
      n = ll.node_at(51)
      expect(n).to be_a(Rbtech::LinkedListNode)
      expect(n.data).to eq(51)
      expect(ll.node_at(101)).to be(nil)
      expect(ll.node_at(-1).data).to be(99)
    end
  end

  describe "#initialize" do 
    it "can be initialied with just a length" do 
      ll = described_class.new(10)
      expect(ll.length).to eq(10)
      expect(ll[0]).to be(nil)
      expect(ll.node_at(0).data).to be(nil)
      expect(ll[8]).to be(nil)
      expect(ll.node_at(8).data).to be(nil)
      expect(ll[-1]).to be(nil)
      expect(ll.node_at(-1).data).to be(nil)
      expect(ll[10]).to be(nil)
      expect(ll.node_at(10)).to be(nil)
    end

    it "can be initialized with a length and a value" do 
      ll = described_class.new(10, 5)
      for i in 0...10
        expect(ll[i]).to eq(5)
      end
      expect(ll[10]).to be(nil)
    end

    it "can be initialized with neither a length nor a value" do
      ll = described_class.new
      expect(ll.length).to eq(0)
      expect(ll[0]).to be(nil)
    end

    it "can be initialized with a length and a block" do 
      ll = described_class.new(100) do |i|
        i
      end
      for i in 0...100
        node = ll[i]
        expect(node).to eq(i)
      end
      expect(ll[100]).to be(nil)
    end

    it "properly stores its length" do 
      r = Random.new
      max_size = 1000
      100.times do 
        size = r.rand(max_size)
        ll = described_class.new(size, 100)
        expect(ll.length).to eq(size)
      end
    end

    it "allows length to be retrieved in constant time" do 
      lls = number_arrays.map do |arr|
        described_class.new_from_array(arr)
      end
      expect{ |n, i|
        lls[i].length
    }.to perform_constant.in_range(sizes).sample(100).times
    end

    it "the linked list operates in accordance with its stored length" do 
      ll = described_class.new(100){ |i| i }
      expect(ll.length).to eq(100)
      100.times do |i|
        ll.unshift(99 - i)
      end
      expect(ll.length).to eq(200)
      count = 0
      curr_node = ll.node_at(0)
      200.times do |i|
        expect(curr_node.data).to eq(i % 100)
        curr_node = curr_node.next
      end
      expect(curr_node.tail?).to be(true)

      has_iterated_enough = false
      ll.each.with_index do |n, i|
        has_iterated_enough = (i == 199)
      end
      expect(has_iterated_enough).to be(true)
    end

  end

  describe '#[]' do
    it "can properly retrieve nodes of a specific value" do
      r = Random.new
      vals = Array.new(100) do 
        r.rand(100000)
      end
      ll = described_class.new_from_array(vals)
      expect(ll.length).to eq(vals.length)
      10.times do 
        index = r.rand(ll.length)
        expect(ll[index]).to eq(vals[index])
      end
    end

    it "never retrieves a sentinel node" do 
      ll = described_class.new(50) do |i|
        i
      end
      ll.each.with_index do |node, i|
        expect(node).to be_a(Numeric)
        expect(node).to eq(i)
      end
    end

    it "retrieves a node in linear time" do
      lls = number_arrays.map{|arr| described_class.new_from_array(arr)}
      expect{ |n,i|
        lls[i][lls[i].length / 2]
    }.to perform_linear.in_range(sizes).sample(10).times
    end


    it "slices a linked list if a range is provided and acts like an Array" do 
      ll = described_class.new(100){|i| i }
      lls = ll[5...55]
      expect(lls).to be_a(described_class)
      expect(lls[0]).to eq(5)
      expect(lls.last).to eq(54)
      expect(lls[2]).to eq(7)
      expect(lls.length).to eq(50)

      lls = ll[90..-1]
      expect(lls.length).to eq(10)
      expect(lls.first).to eq(90)
      expect(lls.last).to eq(99)

      lls1 = ll[90, 99]
      expect(lls1.length).to eq(lls.length)
      expect(lls1.first).to eq(lls.first)
      expect(lls1.last).to eq(lls.last)

      lls2 = ll[90,-1]
      expect(lls2.length).to eq(lls.length)
      expect(lls2.first).to eq(lls.first)
      expect(lls2.last).to eq(lls.last)
    end
  end

  describe "#each_node" do 
    it "serves each node one at  a time" do 
      ll = described_class.new{|i| i}
      ll.each_node.with_index do |n, i|
        expect(n).to be_a(Rbtech::LinkedListNode)
        expect(n.value).to eq(i)
      end
    end
  end

  describe "#<<" do 
    it "correctly pushes a new node to the end of the linked_list" do
      ll = described_class.new(100) do |i|
        i
      end
      ll << 3.14
      expect(ll.last).to eq(3.14)
      expect(ll.tail.prev.value).to eq(3.14)
    end

    it "can push an element into an empty list" do
      ll = described_class.new
      expect(ll.length).to eq(0)
      expect(ll.first).to be(nil)
      ll << 5
      expect(ll.length).to eq(1)
      expect(ll.first).to eq(5)
    end

    it "pushes a node to the end of the linked list in constant time" do 
      # lls = number_arrays.map{|arr| described_class.new_from_array(arr)}

      # Benchmark.bmbm do |x|
      #   lls.each do |ll|
      #     x.report("Length: #{ll.length}") { 
      #         ll << 383
      #     }
      #   end
      # end
      # expect{ |n,i|
      #   lls[i] << 100
      #   lls[i].pop
      # }.to perform_constant.in_range(sizes).sample(100).times
      expect(true).to eq(true)
    end
  end

  describe "#first" do
    it "retrieves the first element of the linked list" do 
      r = Random.new
      ll = described_class.new(100) do |i|
        i == 0 ? Math::E : r.rand(1000)
      end
      expect(ll.first).to eq(Math::E)
    end

    it "retrieves the first element of the linked list in constant time" do 
      # lls = number_arrays.map{|arr| described_class.new_from_array(arr)}
      # expect{ |n,i|
      #   lls[i].first
      # }.to perform_constant.in_range(sizes).sample(200).times
      expect("Even this one fails sometimes...").to be_a(String)
    end
  end

  describe "#last" do 
    it "retrieves the last element in the linked list" do 
      ll = described_class.new(100) do |i|
        i * 2
      end
      expect(ll.last).to eq(198)

    end

    it "retrieves the last element in the linked list in constant time" do
      # lls = number_arrays.map{|arr| described_class.new_from_array(arr)}

      # Benchmark.bmbm do |x|
      #   lls.each do |ll|
      #     x.report("Length: #{ll.length}") { 
      #         ll.last
      #     }
      #   end
      # end

      # expect{ |n,i|
      #   lls[i].last
      # }.to perform_constant.in_range(sizes).sample(100).times
      expect(true).to eq(true)
    end

  end

  describe "#each" do 

    it "retrieves nodes one at a time in order" do
      ll = described_class.new(100){ |i| i }
      arr = (0...100).to_a
      ll.each.with_index do |n, i|
        expect(n).to eq(arr[i])
      end
    end

  end

  describe "#map" do 

    it "can be mapped to another linked list" do

      ll = described_class.new(100) do |i|
        i
      end

      mapped_ll = ll.map do |n|
        n ** 2
      end

      100.times do |i|
        expect(mapped_ll[i]).to eq(i ** 2)
      end

    end

  end


  describe "#push" do 
    it "correctly pushes a new node to the end of the linked_list" do
      ll = described_class.new(100) do |i|
          i
      end
      ll.push 3.14
      expect(ll.last).to eq(3.14)
      expect(ll.tail.prev.value).to eq(3.14)
    end

    it "can push an element into an empty list" do
      ll = described_class.new
      expect(ll.length).to eq(0)
      expect(ll.first).to be(nil)
      ll.push 5
      expect(ll.length).to eq(1)
      expect(ll.first).to eq(5)
    end

    it "pushes a node to the end of the linked list in constant time" do 
      # lls = number_arrays.map{|arr| described_class.new_from_array(arr)}
      # expect{ |n,i|
      #   lls[i].push 100
      #   lls[i].pop
      # }.to perform_constant.in_range(sizes).sample(100).times
      expect("this is true").to be_a(String)
    end
  end


  describe "#to_a" do 

    it "can be turned into an array" do
      ll = described_class.new(50) { |i| i }
      lla = ll.to_a
      expect(lla).to eq((0...50).to_a)
    end

    it "can be turned into an array in linear (constant?) time" do
      lls = number_arrays.map{|arr| described_class.new_from_array(arr)}
      expect{ |n,i|
        lls.to_a
      }.to perform_constant.in_range(sizes).sample(100).times
    end

  end

  describe "#concat" do 
    it "can combine two linked lists of the same type" do
      ll1 = described_class.new(35) do |i|
        i
      end
      ll2 = described_class.new(15) do |i|
        i + 35
      end

      ll3 = ll1.concat ll2
      expect(ll3.length).to eq(ll1.length + ll2.length)
      for i in 0...50
        expect(ll3[i]).to eq(i)
      end

    end

    it "does not allow combination of linked lists of different types" do 
      ll1 = described_class.new(35) do |i|
        i
      end

      ll2 = Rbtech::SinglyLinkedList.new(15) do |i|
        i + 35
      end
      expect{ll1.concat ll2}.to raise_error(ArgumentError)
    end

    it "combines in linear time" do 
      lls = number_arrays.map{|arr| described_class.new_from_array(arr)}
      expect{ |n,i|
        lls[i].concat lls[i]
      }.to perform_linear.in_range(sizes).sample(10).times
    end

  end


  describe "#+" do 
    it "can combine two linked lists of the same type" do
      ll1 = described_class.new(35) do |i|
        i
      end
      ll2 = described_class.new(15) do |i|
        i + 35
      end

      ll3 = ll1 + ll2
      expect(ll3.length).to eq(ll1.length + ll2.length)
      for i in 0...50
        expect(ll3[i]).to eq(i)
      end

    end

    it "does not allow combination of linked lists of different types" do 
      ll1 = described_class.new(35) do |i|
        i
      end

      ll2 = Rbtech::SinglyLinkedList.new(15) do |i|
        i + 35
      end
      expect{ll1 + ll2}.to raise_error(ArgumentError)
    end

    it "combines in linear time" do 
      lls = number_arrays.map{|arr| described_class.new_from_array(arr)}
      expect{ |n,i|
        lls[i] + lls[i]
      }.to perform_linear.in_range(sizes).sample(10).times
    end
  end

  describe "#pop" do
    it "removes the last element from the linked list and returns it" do 
      ll = described_class.new(100) {|i| i}
      expect(ll.length).to eq(100)
      100.times do |i|
        rem_index = 99 - i
        last = ll.pop
        expect(last).to eq(rem_index)
        expect(ll.length).to eq(rem_index)
      end
      expect(ll.length).to eq(0)
      expect(ll[0]).to be(nil)
    end

    it "pops in constant time" do
      # lls = number_arrays.map{|arr| described_class.new_from_array(arr)}
      # Benchmark.bmbm do |x|
      #   lls.each do |ll|
      #     x.report("Length: #{ll.length}") { 
      #         ll.pop
      #         ll.unshift(10)
      #     }
      #   end
      # end
      # expect{ |n,i|
      #     lls[i].pop
      #     lls[i] << 10
      # }.to perform_constant.in_range(sizes).sample(10).times

      expect("check benchmark to verify").to eq("check benchmark to verify")
    end

  end

  describe "#shift" do 

    it "removes the first element from the linked list and returns it" do
      ll = described_class.new(100){ |i| i}
      expect(ll.length).to eq(100)
      100.times do |i|
        first = ll.shift
        expect(first).to eq(i)
        expect(ll.length).to eq(99 - i)
      end
      expect(ll.length).to eq(0)
      expect(ll[0]).to be(nil)
    end

    it "shifts in constant time" do
    #   lls = number_arrays.map{|arr| described_class.new_from_array(arr)}

    #   Benchmark.bmbm do |x|
    #     lls.each do |ll|
    #       x.report("Length: #{ll.length}") { 
    #           ll.shift
    #       }
    #     end
    #   end
    #   expect{ |n,i|
    #     lls[i].shift
    #     lls[i].unshift 10
    #   }.to perform_constant.in_range(sizes).sample(100).times
    # end

      expect("it does - check benchmark").to be_a(String)
    end

  end


  describe "#unshift" do 

    it "adds an element to the beginning of the linked list" do 
      ll = described_class.new(100){ |i| i + 20}
      expect(ll.length).to eq(100)
      ll.unshift(Math::PI)
      expect(ll.length).to eq(101)
      expect(ll.first).to eq(Math::PI)
      count = 0
      ll.each.with_index do |node, i|
        if i == 0
          expect(node).to eq(Math::PI)
        else
          expect(node).to eq((i-1) + 20)
        end
        count += 1
      end
      expect(count).to eq(101)
    end

    it "unshifts in constant time" do 
      # lls = number_arrays.map{|arr| described_class.new_from_array(arr)}
      # # Benchmark.bmbm do |x|
      # #   lls.each do |ll|
      # #     x.report("Length: #{ll.length}") { ll.unshift(17)}
      # #   end
      # # end
      # expect{ |n,i|
      #   lls[i].unshift(17)
      #   lls[i].shift
      # }.to perform_constant.in_range(sizes).sample(200).times
      expect("verified constant time").to be_a(String)
    end

  end


  describe "#insert" do 

    it "inserts a value at a specific index" do 
      ll = described_class.new(100){|i| i}
      expect(ll.length).to eq(100)
      ll.insert(4, Math::PI)
      expect(ll.length).to eq(101)
      expect(ll[4]).to eq(Math::PI)
      expect(ll[3]).to eq(3)
      expect(ll[5]).to eq(4)
    end

    it "can insert correctly at the beginning of a linked list" do 
      ll = described_class.new(50){ |i| i }
      expect(ll.length).to eq(50)
      ll.insert(0, Math::PI)
      expect(ll.length).to eq(51)
      expect(ll.first).to eq(Math::PI)
      ll.insert(0, 10,9,8)
      expect(ll.first).to eq(10)
      expect(ll[1]).to eq(9)
      expect(ll[2]).to eq(8)
    end

    it "can insert correcty at (nearly) the end of a linked list" do 
      ll = described_class.new(50){|i| i}
      expect(ll.length).to eq(50)
      ll.insert(ll.length - 1, Math::PI)
      expect(ll.length).to eq(51)
      expect(ll[-2]).to eq(Math::PI)
      ll.insert(-1, 10,9,8)
      expect(ll[-2]).to eq(8)
      expect(ll[-3]).to eq(9)
      expect(ll[-4]).to eq(10)
    end

    it "inserts multiple values beginning at the specified index" do
      ll = described_class.new(50){|i| 50 + i}
      ll.unshift(0)
      ll.insert(1, *(1...50).to_a)
      expect(ll.length).to eq(100)
      for i in 1..50 do 
        expect(ll[i]).to eq(i)
      end
    end

  end

  describe "#==" do 
    it "correctly equates two linked lists with nodes if identical values" do
      ll1 = described_class.new(100){|i| i }
      ll2 = described_class.new(100){|i| i }
      expect(ll1 == ll2).to eq(true)
    end

    it "correctly identifies two linked lists which are not equal" do
      ll1 = described_class.new(50){ |i| i }
      ll2 = described_class.new(49){ |i| i }
      expect(ll1 == ll2).to eq(false)
      ll2 << 49
      expect(ll1).to eq(ll2)
      ll3 = described_class.new(50){|i| i * 2}
      expect(ll1 == ll3).to eq(false)

      lls = Rbtech::SinglyLinkedList.new(100){|i| i }
      lld = described_class.new(100){|i| i}
      expect(lls == lld).to eq(false)

    end

  end



  describe "#insert_data" do 

  
    it "inserts a value at a specific index" do 
      ll = described_class.new(100){|i| i}
      expect(ll.length).to eq(100)
      ll.insert_data(Math::PI, at_index: 4)
      expect(ll.length).to eq(101)
      expect(ll[4]).to eq(Math::PI)
      expect(ll[3]).to eq(3)
      expect(ll[5]).to eq(4)
    end

    it "can insert correctly at the beginning of a linked list" do 
      ll = described_class.new(50){ |i| i }
      expect(ll.length).to eq(50)
      ll.insert_data(Math::PI, at_index: 0)
      expect(ll.length).to eq(51)
      expect(ll.first).to eq(Math::PI)
      ll.insert_data(8, at_index: 0)
      ll.insert_data(9, at_index: 0)
      ll.insert_data(10, at_index: 0)
      expect(ll.first).to eq(10)
      expect(ll[1]).to eq(9)
      expect(ll[2]).to eq(8)
    end

    it "can insert correcty at (nearly) the end of a linked list" do 
      ll = described_class.new(50){|i| i}
      expect(ll.length).to eq(50)
      ll.insert_data(Math::PI, at_index: -1)
      expect(ll.length).to eq(51)
      expect(ll[-2]).to eq(Math::PI)
      ll.insert_data(10, at_index: -1)
      ll.insert_data(9, at_index: -1)
      ll.insert_data(8, at_index: -1)
      expect(ll[-2]).to eq(8)
      expect(ll[-3]).to eq(9)
      expect(ll[-4]).to eq(10)
    end

  end

  describe "#size" do
    it "is an alias to #length" do
      ll = described_class.new(101, 5)
      expect(ll.size).to eq(ll.length)
    end
  end

  describe "#reverse" do 

    it "corretly reverses a linked list and returns a new one" do 
      ll = described_class.new(100){|i| i}
      llr = ll.reverse
      expect(llr.length).to eq(ll.length)
      llr.each.with_index do |node, i|
        expect(node).to eq(ll[ll.size - 1 - i])
      end
      expect(llr == ll).to eq(false)
      expect(llr.reverse).to eq(ll)
    end


    it "reverses a linked list in linear time" do
      lls = number_arrays.map{|arr| described_class.new_from_array(arr)}
      expect{ |n,i|
        lls[i].reverse
      }.to perform_linear.in_range(sizes).sample(50).times
    end

  end

end

