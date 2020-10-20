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

  end

  describe "#left_child_index" do 

  end

  describe "#right_child" do 

  end
  
  describe "#left_child" do 

  end

  describe "#parent_index" do 

  end

  describe "#parent" do 

  end

end

