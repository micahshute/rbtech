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

  let(:proto_graph_no_conns) do
    arr = 100.times.map{ wrapper.new(rand(100)) }
    described_class.new(arr)
  end



  let(:proto_graphs_with_conns) do
    r = Random.new
    number_arrays.map do |arr|
      g = described_class.new(arr)
      for i in 0...g.nodes.length
        node_connections = r.rand(g.nodes.length) + 1
        node_connections.times do 
          rand_conn = r.rand(g.nodes.length)
          while rand_conn == i || g.connection_exist?(from: i, to: rand_conn)
            rand_conn = r.rand(g.nodes.length)
          end
          g.add_connection(from: i, to: rand_conn, weight: r.rand(10) + 1)
        end
      end
      g
    end
  end


  let(:proto_graph_with_conns) do 
    r = Random.new
    arr = 100.times.map{ wrapper.new(r.rand(100))}
    g = described_class.new(arr)
    for i in 0...g.nodes.length
      node_connections = r.rand(g.nodes.length) + 1
      node_connections.times do 
        g.add_connection(from: i, to: r.rand(g.nodes.length), weight: r.rand(10) + 1)
      end
    end
    g
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
    expect(g.instance_variable_get("@adj_list")).to be_a(Array)
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
      
      # nas = (1..12).to_a.map{|n| 2 ** n}.map{|size| Array.new(size){rand(size)}}
      
      # Benchmark.bmbm do |x|
      #   r = Random.new
      #   nas.map do |arr|
      #     g = described_class.new(arr)
          
      #     x.report("LL w/length: #{g.nodes.length}") { 
      #       for i in 0...g.nodes.length
      #         node_connections = g.nodes.length + 1
      #         node_connections.times do 
      #           g.add_connection(from: i, to: r.rand(g.nodes.length), weight: r.rand(10) + 1)
      #         end
      #       end
      #     }
      #   end
      # end

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
          conns_to_node_99 << to if i == 99
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
      graphs = proto_graphs_no_conns
      expect{ |n,i|
        graphs[i].remove_node(0)
      }.to perform_linear.in_range(sizes).sample(10).times
      # expect(false).to eq(true)
    end
  end

  describe "#remove_connections_from" do 
    it "correctly removes connections from a certain node" do
      g = proto_graph_with_conns
      r = Random.new
      rand_node = r.rand(g.nodes.length)
      expect(g.get_connections_from(rand_node).length).to be > 0
      g.remove_connections_from(rand_node)
      expect(g.get_connections_from(rand_node).length).to eq(0)
    end

    it "removes connections in O(1) time" do
      graphs = proto_graphs_no_conns
      r = Random.new
      for graph in graphs
        50.times do
          graph.add_connection(from: 0, to: r.rand(graph.nodes.length))
        end
      end
      
      expect{ |n,i|
        graphs[i].remove_connections_from(0)
        50.times do
          graphs[i].add_connection(from: 0, to: r.rand(graphs[i].nodes.length))
        end
      }.to perform_constant.in_range(sizes).sample(100).times
    end
  end

  describe "#remove_connections_undirected" do 
    it "correctly removes connections to and from a node if connected in an undirected fashion" do 
      als = proto_graph_no_conns
      r = Random.new
      rand_node = r.rand(als.nodes.length)
      already_connected = Set.new 
      10.times do 
        rand_connection = r.rand(als.nodes.length)
        while rand_connection == rand_node || already_connected.include?(rand_connection)
          rand_connection = r.rand(als.nodes.length)
        end
        als.add_connection(from: rand_node, to: rand_connection)
        als.add_connection(from: rand_connection, to: rand_node)
        already_connected.add(rand_connection)
      end
      expect(als.get_connections_from(rand_node).length).to eq 10
      expect(als.get_connections_to(rand_node).length).to eq 10
      als.remove_connections_undirected(rand_node)
      expect(als.get_connections_from(rand_node).length).to eq(0)
      expect(als.get_connections_to(rand_node).length).to eq(0)
    end

    it "performs in linear (edge_count) time" do 
      graphs = proto_graphs_no_conns
      r = Random.new
      rand_nodes = []
      for graph in graphs
        rand_node = r.rand(graph.nodes.length)
        rand_nodes << rand_node
        already_connected = Set.new
        (graph.nodes.size - 1).times do 
          rand_connection = r.rand(graph.nodes.length)
          while rand_connection == rand_node || already_connected.include?(rand_connection)
            rand_connection = r.rand(graph.nodes.length)
          end
          graph.add_connection(from: rand_node, to: rand_connection)
          graph.add_connection(from: rand_connection, to: rand_node)
          already_connected.add(rand_connection)
        end
      end
      
      expect{ |n,i|
        rand_node = rand_nodes[i]
        already_connected = Set.new
        graphs[i].remove_connections_undirected(rand_node)
        (graphs[i].nodes.length - 1).times do
          rand_connection = r.rand(graph.nodes.length)
          while rand_connection == rand_node || already_connected.include?(rand_connection)
            rand_connection = r.rand(graph.nodes.length)
          end
          graph.add_connection(from: rand_node, to: rand_connection)
          graph.add_connection(from: rand_connection, to: rand_node)
          already_connected.add(rand_connection)
        end
      }.to perform_linear.in_range(sizes).sample(5).times
    end
  end

  it "can remove all connections to and from" do
    als = proto_graph_with_conns
    r = Random.new
    rand_node = r.rand(als.nodes.length)
    expect(als.get_connections_from(rand_node).length).to be > 0
    expect(als.get_connections_to(rand_node).length).to be > 0
    als.remove_connections_to(rand_node)
    als.remove_connections_from(rand_node)
    expect(als.get_connections_from(rand_node).length).to eq(0)
    expect(als.get_connections_to(rand_node).length).to eq(0)
  end

  describe "#remove_connections_to" do 
    it "removes connections to a node" do
      als = proto_graph_with_conns
      r = Random.new
      rand_node = r.rand(als.nodes.length)
      expect(als.get_connections_to(rand_node).length).to be > 0
      als.remove_connections_to(rand_node)
      expect(als.get_connections_to(rand_node).length).to eq(0)
    end

    it "performs in linear (edge count) time" do
      graphs = proto_graphs_no_conns
      r = Random.new
      rand_nodes = []
      for graph in graphs
        rand_node = r.rand(graph.nodes.length)
        rand_nodes << rand_node
        already_connected = Set.new
        (graph.nodes.size - 1).times do 
          rand_connection = r.rand(graph.nodes.length)
          while rand_connection == rand_node || already_connected.include?(rand_connection)
            rand_connection = r.rand(graph.nodes.length)
          end
          graph.add_connection(from: rand_node, to: rand_connection)
          graph.add_connection(from: rand_connection, to: rand_node)
          already_connected.add(rand_connection)
        end
      end
      
      expect{ |n,i|
        rand_node = rand_nodes[i]
        already_connected = Set.new
        graphs[i].remove_connections_to(rand_node)
        (graphs[i].nodes.length - 1).times do
          rand_connection = r.rand(graph.nodes.length)
          while rand_connection == rand_node || already_connected.include?(rand_connection)
            rand_connection = r.rand(graph.nodes.length)
          end
          graph.add_connection(from: rand_node, to: rand_connection)
          graph.add_connection(from: rand_connection, to: rand_node)
          already_connected.add(rand_connection)
        end
      }.to perform_linear.in_range(sizes).sample(5).times
    end
  end

  describe "#add_connection" do
    it "adds a connection between two nodes" do
      als = proto_graph_no_conns
      r = Random.new
      rand_node = r.rand(als.nodes.length)
      expect(als.get_connections_to(rand_node).length).to eq(0)
      expect(als.get_connections_from(rand_node).length).to eq(0)
      rand_to = r.rand(als.nodes.length)
      while rand_to == rand_node
        rand_to = r.rand(als.nodes.length)
      end
      als.add_connection(from: rand_node, to: rand_to)
      expect(als.get_connections_to(rand_node).length).to eq(0)
      expect(als.get_connections_from(rand_node).length).to eq(1)
    end

    it "performs in constant time" do
      graphs = proto_graphs_no_conns
      r = Random.new
      expect{ |n,i|
        rand_from = r.rand(graphs[i].nodes.length)
        rand_to = r.rand(graphs[i].nodes.length)
        graphs[i].add_connection(from: rand_from, to: rand_to)
      }.to perform_constant.in_range(sizes).sample(50).times
    end
  end

  describe "#remove_connection" do
    it "correctly removes a connection" do 
      als = proto_graph_with_conns
      r = Random.new
      rand_node = r.rand(als.nodes.length)
      connected_node = als.get_connections_from(rand_node)[0][0]
      expect(als.connection_exist?(from: rand_node, to: connected_node)).to be(true)
      als.remove_connection(from: rand_node, to: connected_node)
      expect(als.connection_exist?(from: rand_node, to: connected_node)).to be(false)

    end

    it "performs in linear (edge_count) time" do
      graphs = proto_graphs_no_conns
      r = Random.new
      rand_nodes = []
      for graph in graphs
        rand_node = r.rand(graph.nodes.length)
        rand_nodes << rand_node
        already_connected = Set.new
        (graph.nodes.size - 1).times do 
          rand_connection = r.rand(graph.nodes.length)
          while rand_connection == rand_node || already_connected.include?(rand_connection)
            rand_connection = r.rand(graph.nodes.length)
          end
          graph.add_connection(from: rand_node, to: rand_connection)
          graph.add_connection(from: rand_connection, to: rand_node)
          already_connected.add(rand_connection)
        end
      end
      
      expect{ |n,i|
        rand_node = rand_nodes[i]
        node_to_remove = graphs[i].get_connections_from(rand_node)[0][0]
        graphs[i].remove_connection(from: rand_node, to: node_to_remove)
        graphs[i].add_connection(from: rand_node, to: node_to_remove)
      }.to perform_linear.in_range(sizes).sample(50).times
    end
  end

  describe "#get_conections_from" do 
    it "correctly gets connections from a node" do 
      als = proto_graph_no_conns
      r = Random.new
      rand_node = r.rand(als.nodes.length)
      expect(als.get_connections_from(rand_node).length).to eq(0)
      rand_to = r.rand(als.nodes.length) + 1
      while rand_to == rand_node
        rand_to = r.rand(als.nodes.length) + 1
      end
      weight = 10
      als.add_connection(from: rand_node, to: rand_to, weight: weight)
      expect(als.get_connections_from(rand_node).length).to eq(1)
      expect(als.get_connections_from(rand_node)).to eq([[rand_to, weight]])
      als.add_connection(from: rand_node, to: rand_to - 1, weight: weight + 1)
      expect(als.get_connections_from(rand_node).length).to eq(2)
      expect(als.get_connections_from(rand_node)).to eq([[rand_to, weight], [rand_to - 1, weight + 1]])
    end

    it "performs in constant time" do
      graphs = proto_graphs_no_conns
      r = Random.new
      rand_nodes = []
      for graph in graphs
        rand_node = r.rand(graph.nodes.length)
        rand_nodes << rand_node
        already_connected = Set.new
        (graph.nodes.size - 1).times do 
          rand_connection = r.rand(graph.nodes.length)
          while rand_connection == rand_node || already_connected.include?(rand_connection)
            rand_connection = r.rand(graph.nodes.length)
          end
          graph.add_connection(from: rand_node, to: rand_connection)
          graph.add_connection(from: rand_connection, to: rand_node)
          already_connected.add(rand_connection)
        end
      end
      
      expect{ |n,i|
        rand_node = rand_nodes[i]
        graphs[i].get_connections_from(rand_node)
      }.to perform_constant.in_range(sizes).sample(50).times
    end
  end

  describe "#get_connections_to" do 
    it "correctly gets connections to a node" do
      als = proto_graph_no_conns
      r = Random.new
      rand_node = r.rand(als.nodes.length) + 1
      expect(als.get_connections_from(rand_node).length).to eq(0)
      rand_to = r.rand(als.nodes.length)
      while rand_to == rand_node
        rand_to = r.rand(als.nodes.length)
      end
      weight = 10
      als.add_connection(from: rand_node, to: rand_to, weight: weight)
      expect(als.get_connections_to(rand_to).length).to eq(1)
      expect(als.get_connections_to(rand_to)).to eq([[rand_node, weight]])
      als.add_connection(from: rand_node - 1, to: rand_to, weight: weight + 1)
      expect(als.get_connections_to(rand_to).length).to eq(2)
      expect(als.get_connections_to(rand_to)).to eq([[rand_node - 1, weight+1], [rand_node, weight]])
    end

    it "performs in linear (edge count) time" do 
      graphs = proto_graphs_no_conns
      r = Random.new
      rand_nodes = []
      for graph in graphs
        rand_node = r.rand(graph.nodes.length)
        rand_nodes << rand_node
        already_connected = Set.new
        (graph.nodes.size - 1).times do 
          rand_connection = r.rand(graph.nodes.length)
          while rand_connection == rand_node || already_connected.include?(rand_connection)
            rand_connection = r.rand(graph.nodes.length)
          end
          graph.add_connection(from: rand_node, to: rand_connection)
          graph.add_connection(from: rand_connection, to: rand_node)
          already_connected.add(rand_connection)
        end
      end
      
      expect{ |n,i|
        rand_node = rand_nodes[i]
        graphs[i].get_connections_to(rand_node)
      }.to perform_linear.in_range(sizes).sample(50).times
    end
  end

  describe "#connection_exist?" do 
    it "correctly determines if a connection exists between two nodes" do 
      als = proto_graph_no_conns
      r = Random.new
      rand_node = r.rand(als.nodes.length) + 1
      expect(als.get_connections_from(rand_node).length).to eq(0)
      rand_to = r.rand(als.nodes.length)
      while rand_to == rand_node
        rand_to = r.rand(als.nodes.length)
      end
      weight = 10
      als.add_connection(from: rand_node, to: rand_to, weight: weight)
      expect(als.connection_exist?(from: rand_node, to: rand_to)).to be(true)
      expect(als.connection_exist?(from: rand_to, to: rand_node)).to be(false)
    end

    it "performs in linear (edge count) time" do
      graphs = proto_graphs_no_conns
      r = Random.new
      rand_nodes = []
      for graph in graphs
        rand_node = r.rand(graph.nodes.length)
        rand_nodes << rand_node
        already_connected = Set.new
        (graph.nodes.size - 1).times do 
          rand_connection = r.rand(graph.nodes.length)
          while rand_connection == rand_node || already_connected.include?(rand_connection)
            rand_connection = r.rand(graph.nodes.length)
          end
          graph.add_connection(from: rand_node, to: rand_connection)
          graph.add_connection(from: rand_connection, to: rand_node)
          already_connected.add(rand_connection)
        end
      end
      
      expect{ |n,i|
        rand_node = rand_nodes[i]
        graphs[i].connection_exist?(from: rand_node, to: r.rand(graphs[i].nodes.length))
      }.to perform_linear.in_range(sizes).sample(50).times
    end
  end

  describe "connection_weight" do 
    it "correctly determines the connection weight between two nodes" do
      als = proto_graph_no_conns
      r = Random.new
      rand_node = r.rand(als.nodes.length) + 1
      expect(als.get_connections_from(rand_node).length).to eq(0)
      rand_to = r.rand(als.nodes.length)
      while rand_to == rand_node
        rand_to = r.rand(als.nodes.length)
      end
      weight = 10
      als.add_connection(from: rand_node, to: rand_to, weight: weight)
      expect(als.connection_weight(from: rand_node, to: rand_to)).to be(weight)
      expect(als.connection_weight(from: rand_to, to: rand_node)).to be(Float::INFINITY)
    end

    it "returns infinity if no connection exists" do
      als = proto_graph_no_conns
      r = Random.new
      rand_node = r.rand(als.nodes.length) + 1
      expect(als.get_connections_from(rand_node).length).to eq(0)
      rand_to = r.rand(als.nodes.length)
      while rand_to == rand_node
        rand_to = r.rand(als.nodes.length)
      end
      weight = 10
      als.add_connection(from: rand_node, to: rand_to, weight: weight)
      expect(als.connection_weight(from: rand_node, to: rand_to)).to be(weight)
      expect(als.connection_weight(from: rand_to, to: rand_node)).to be(Float::INFINITY)
    end

    it "performs in linear (edge count) time" do
      graphs = proto_graphs_no_conns
      r = Random.new
      rand_nodes = []
      for graph in graphs
        rand_node = r.rand(graph.nodes.length)
        rand_nodes << rand_node
        already_connected = Set.new
        (graph.nodes.size - 1).times do 
          rand_connection = r.rand(graph.nodes.length)
          while rand_connection == rand_node || already_connected.include?(rand_connection)
            rand_connection = r.rand(graph.nodes.length)
          end
          graph.add_connection(from: rand_node, to: rand_connection)
          graph.add_connection(from: rand_connection, to: rand_node)
          already_connected.add(rand_connection)
        end
      end
      
      expect{ |n,i|
        rand_node = rand_nodes[i]
        graphs[i].connection_weight(from: rand_node, to: r.rand(graphs[i].nodes.length))
      }.to perform_linear.in_range(sizes).sample(50).times
    end
  end

end

