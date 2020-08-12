RSpec.describe Rbtech::AdjacencyListStrategy do 

  let(:Wrapper) do
    Struct.new(:data)
  end


  it "can be instantiated with an arry of nodes" do 
    nodes = (0...100).to_a
    g = described_class.new(nodes)
    expect(g.nodes.length).to eq(100)
    expect(g.instance_variable_get("@adj_list").length).to eq(100)
  end

  it "can be instantiated with no input arguments" do 
    g = described_class.new
    expect(g.nodes).to eq([])
    expect(g.instance_variable_get("@adj_list").length).to eq(0)
    expect(g.instance_variable_get("@adj_list")).to be_a(Rbtech::DoublyLinkedList)
  end

  describe "#add_node" do
    it "properly adds a node" do
      g = described_class.new
      g.add_node(Wrapper.new({x: 10, y: 30}))
      expect(g.nodes.length).to eq(1)
      expect(g.instance_variable_get("@adj_list").length).to eq(1)
    end


    it "adds a node in constant time" do
      let(:sizes) do 
        sizes = bench_range(8, 200_000) # => [8, 64, 512, 4096, 32768, 100000]
      end
    
      let(:number_arrays) do 
        sizes.map { |n| Array.new(n) { rand(n) } }
      end
    end
  end

  describe "#remove_node" do
    it "properly removes a node" do 
      expect(false).to eq(true)
    end

    it "removes a node in linear (edge count) time" do
      expect(false).to eq(true)
    end
  end

  describe "#remove_connections_from" do 
    it "correctly removes connections from a certain node" do
      expect(false).to eq(true)
    end

    it "removes connections in O(1) time" do
      expect(false).to eq(true)
    end
  end

  describe "#remove_connections_undirected" do 
    it "correctly removes connections to and from a node" do 
      expect(false).to eq(true)
    end

    it "performs in linear (edge_count) time" do 
      expect(false).to eq(true)
    end
  end

  describe "#remove_connections_to" do 
    it "removes connections to a node" do
      expect(false).to eq(true)
    end

    it "performs in linear (edge count) time" do
      expect(false).to eq(true)
    end
  end

  describe "#add_connection" do
    it "adds a connection between two nodes" do
      expect(false).to eq(true)
    end

    it "performs in constant time" do
      expect(false).to eq(true)
    end
  end

  describe "#remove_connection" do
    it "correctly removes a connection" do 
      expect(false).to eq(true)
    end

    it "performs in linear (edge_count) time" do
      expect(false).to eq(true)
    end
  end

  describe "#get_conections_from" do 
    it "correctly gets connections from a node" do 
      expect(false).to eq(true)
    end

    it "performs in constant time" do
      expect(false).to eq(true)
    end
  end

  describe "#get_connections_to" do 
    it "correctly gets connections to a node" do
      expect(false).to eq(true)
    end

    it "performs in linear (edge count) time" do 
      expect(false).to eq(true)
    end
  end

  describe "#connection_exist?" do 
    it "correctly determines if a connection exists between two nodes" do 
      expect(false).to eq(true)
    end

    it "performs in linear (edge count) time" do
      expect(false).to eq(true)
    end
  end

  describe "connection_weight" do 
    it "correctly determines the connection weight between two nodes" do
      expect(false).to eq(true)
    end

    it "returns infinity if no connection exists" do
      expect(false).to eq(true)
    end

    it "performs in linear (edge count) time" do
      expect(false).to eq(true)
    end
  end

end

