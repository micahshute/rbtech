RSpec.describe Rbtech::BinaryTree do 


  let(:bt) do
    r = Random.new
    bta = Array.new(100) do
      r.rand(1000)
    end
    described_class.new(nodes: bta)
  end


  describe "#root" do
    it "returns the correct value" do
      expect(bt.root).to eq(bt.nodes.first)
    end
  end

  describe "#size" do 

    it "correctly returns the size of the binary tree" do
      expect(bt.size).to eq(bt.nodes.length)
    end
  end

  describe "#add" do 
    it "correctly adds a node at the bottom of the tree" do
      last_node = bt.nodes.last
      node_to_add = last_node + 5
      bt.add(node_to_add)
      expect(bt.nodes.last).to eq(node_to_add)
    end
  end


  describe "#update" do
    it "correclty updates a given node" do 
      r = Random.new
      nth_node = r.rand(bt.nodes.length)
      nth_value = bt.nodes[nth_node]
      bt.update(index: nth_node, to: nth_value - 10)
      expect(bt.nodes[nth_node]).to eq(nth_value - 10)
    end
  end

  describe "#right_child_index" do 
    it "correctly calculates the right child index" do 
      r = Random.new
      parent = r.rand(25)
      expect(bt.right_child_index(parent)).to eq(parent * 2 + 2)
    end

    it "returns nil if there is no right child" do 
      parent = 80
      expect(bt.right_child_index(parent)).to be(nil)
    end
  end

  describe "#left_child_index" do 
    it "correctly calculates the left child index" do 
      r = Random.new
      parent = r.rand(25)
      expect(bt.left_child_index(parent)).to eq(parent * 2 + 1)
    end

    it "returns nil if there is no left child" do 
      parent = 80
      expect(bt.left_child_index(parent)).to be(nil)
    end
  end

  describe "#right_child" do 
    it "correctly calculates the right child" do
      r = Random.new
      parent = r.rand(25)
      expect(bt.right_child(parent)).to eq(bt.nodes[parent * 2 + 2])
    end

    it "returns nil if there is no right child" do 
      parent = 80
      expect(bt.right_child(parent)).to be(nil)
    end
  end
  
  describe "#left_child" do 
    it "correctly calculates the left child" do
      r = Random.new
      parent = r.rand(25)
      expect(bt.left_child(parent)).to eq(bt.nodes[parent * 2 + 1])
    end

    it "returns nil if there is no left child" do 
      parent = 80
      expect(bt.left_child(parent)).to be(nil)
    end
  end

  describe "#parent_index" do 
    it "correctly calculates the parent index" do
      r = Random.new
      child = r.rand(99) + 1
      expect(bt.parent_index(child)).to eq((child - 1) / 2)
    end

    it "returns nil if there is no parent" do 
      expect(bt.parent_index(0)).to eq(nil)
    end

    it "returns nil for a child which does not exist" do
      expect(bt.parent_index(bt.nodes.length)).to eq(nil)
    end
  end

  describe "#parent" do 
    it "correctly calculates the parent" do
      r = Random.new
      child = r.rand(99) + 1
      expect(bt.parent(child)).to eq(bt.nodes[bt.parent_index(child)])
    end

    it "returns nil if there is no parent" do 
      expect(bt.parent(0)).to eq(nil)
    end

    it "returns nil for a child which does not exist" do
      expect(bt.parent(bt.nodes.length)).to eq(nil)
    end
  end

end

