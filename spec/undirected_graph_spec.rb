RSpec.describe Rbtech::UndirectedGraph do 


  it "can have nodes that can be connected" do 

    g = described_class.new
    node_values = (0...10).to_a
    for n in node_values
      g.add_node(n)
    end
    g.connect(0,2)
    g.connect(2,4)
    g.connect(4,6)
    g.connect(6,8)
    g.connect(0,1)
    g.connect(1,3)
    g.connect(3,5)
    g.connect(5,7)
    g.connect(7,9)

    expect(g.connection_exist?(0,2)).to be(true)
    expect(g.connection_exist?(2,4)).to be(true)
    expect(g.connection_exist?(4,6)).to be(true)
    expect(g.connection_exist?(6,8)).to be(true)
    expect(g.connection_exist?(0,1)).to be(true)
    expect(g.connection_exist?(1,3)).to be(true)
    expect(g.connection_exist?(3,5)).to be(true)
    expect(g.connection_exist?(5,7)).to be(true)
    expect(g.connection_exist?(7,9)).to be(true)
    expect(g.connection_exist?(2,8)).to be(false)

  end

  describe ".new_from_nodes" do 
    it "can make a new graph from an array of node values" do
      vals = (0...100).to_a
      g = described_class.new_from_nodes(vals)
      expect(g.size).to eq(100)
      expect(g.nodes).to eq(vals)
    end
  end

  it "can connect nodes with specific weights" do 
    town = described_class.new
    Place = Struct.new(:name, :value)
    places = [
      Place.new("library", 100),
      Place.new("coast", 50),
      Place.new("lighthouse", 75),
      Place.new("bar", 150),
      Place.new("farmhouse", 100),
      Place.new("mansion", 500)
    ]

    places.each do |p|
      town.add_node(p)
    end

    town.connect(0,1, weight: 10)
    town.connect(0,3, weight: 5)
    town.connect(0,4, weight: 3)
    town.connect(1,3, weight: 1)
    town.connect(1,2, weight: 1)
    town.connect(2,4, weight: 14)
    town.connect(3,4, weight: 8)

    expect(town.connection_weight(0,1)).to eq(10)
    expect(town.connection_weight(4,3)).to eq(8)
    expect(town.connection_weight(1,2)).to eq(1)
    expect(town.connection_weight(2,1)).to eq(1)
    expect(town.connection_weight(4,1)).to eq(Float::INFINITY)

  end

  it "can be made with an adjacency list, adjacency matrix, or an incidence list" do
    
  end

  describe "#" do

  end

end

