RSpec.describe Rbtech::AdjacencyListStrategy do 

  let(:wrapper) do
    Struct.new(:data)
  end

  let(:sizes) do 
    sizes = bench_range(8, 200_000) # => [8, 64, 512, 4096, 32768, 100000]
  end

  let(:number_arrays) do 
    sizes.map { |n| Array.new(n) { rand(n) } }
  end

  let(:proto_graphs_no_conns) do
    number_arrays.map do |arr|
      described_class.new(arr)
    end
  end

  let(:proto_graphs_with_conns) do
    r = Random.new
    number_arrays.map do |arr|
      g = described_class.new(arr)
      for i in 0...g.nodes.length
        node_connections = r.rand(g.nodes.length) + 1
        node_connections.times do 
          g.add_connection(from: i, to: r.rand(g.nodes.length), weight: r.rand(10) + 1)
        end
      end
      g
    end
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
      g.add_node(wrapper.new({x: 10, y: 30}))
      expect(g.nodes.length).to eq(1)
      expect(g.instance_variable_get("@adj_list").length).to eq(1)
    end


    it "adds a node in constant time" do
      graphs = proto_graphs_no_conns
      expect{ |n,i|
        graphs[i].add_node(wrapper.new("new node"))
      }.to perform_constant.in_range(sizes).sample(500).times
    end
  end

  describe "#remove_node" do
    it "properly removes a node" do 
      nodes = (0...100).map{|n| wrapper.new(n)}
      r = Random.new
      g = described_class.new(nodes)
      conns_to_node_99 = []
      for i in 0...100 
        conn_count = r.rand(100)
        conn_count.times do 
          to = r.rand(g.nodes.length)
          weight = r.rand(10) + 1
          g.add_connection(from: i, to: to, weight: weight)
          conns_to_node_99.unshift(to) if i == 99
        end
      end
      expect(g.nodes.last.data).to eq(99)
      connected_nodes = g.get_connections_from(99)
      expect(connected_nodes.map{|nw| nw[0]}).to eq(conns_to_node_99)
      connection_exists = false
      for i in 0...99
        if g.connection_exist?(from: i, to: 99)
          connection_exists = true
          break
        end
      end
      expect(connection_exists).to eq(true)
      g.remove_node(99)
      expect(g.nodes.last).to be(nil)
      expect(g.get_connections_from(99).length).to eq(0)
      for i in 0...100
        expect(g.connection_exist?(from: i, to: 99)).to eq(false)
      end
      
    end

    it "removes a node in linear (edge count) time" do
      # graphs = proto_graphs_with_conns
      # expect{ |n,i|
      #   graphs[i].remove_node(0)
      # }.to perform_linear.in_range(sizes).sample(2).times
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

