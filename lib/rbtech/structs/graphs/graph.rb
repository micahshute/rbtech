class Rbtech::Graph

    STRATEGIES = [
        :adjacecny_list,
        :adjacency_matrix
    ]

    attr_reader :root, :nodes

    def initialize(root=nil, strategy: :adjacency_list)
        case connect_strat
        when :adjacency_list
            @strat = Rbtech::AdjacencyListStrategy.new
        when :adjacency_matrix
            @strat = Rbtech::AdjacencyMatrixStrategy.new
        else
            ArgumentError.new("Please choose a valid connection strategy: #{STRATEGIES}") if !STRATEGIES.include?(strategy)
        end
        @node_id = -1
        @nodes = []
        add_node(root) if root
    end


    def add_node(data)
        id = next_node_id
        @nodes[id] = Rbtech::GraphNode.new(data, id)
        @strat.add_node()
        id
    end 

    # TODO: Strategies as of now just remove all connections to and
    # from a node. If one removes a node frequently, this could cause a 
    # sparse representation of a matrix with wasted space. Find a way to 
    # "clean up" the @strat 
    def remove_node(node)
        index = to_index(node)
        @nodes[index] = nil
        @strat.remove_node(index)
    end



    private

    def to_index(node)
        node.respond_to?(:id) ?  node.id : node
    end

    def next_node_id
        @node_id += 1
    end

    
end