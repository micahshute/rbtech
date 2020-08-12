class Rbtech::Graph

    STRATEGIES = [
        :adjacecny_list,
        :adjacency_matrix
    ]

    def self.new_from_nodes(nodes, strategy: :adjacecny_list)
        g = new(nodes: nodes, strategy: strategy)
        
    end


    def initialize(nodes: [], strategy: :adjacency_list)
        case connect_strat
        when :adjacency_list
            @strat = Rbtech::AdjacencyListStrategy.new(nodes)
        when :adjacency_matrix
            @strat = Rbtech::AdjacencyMatrixStrategy.new(nodes)
        else
            ArgumentError.new("Please choose a valid connection strategy: #{STRATEGIES}") if !STRATEGIES.include?(strategy)
        end
    end

    def nodes
        @strat.nodes
    end

    def add_node(data)
        @strat.add_node(data)
    end 

    # TODO: Strategies as of now just remove all connections to and
    # from a node. If one removes a node frequently, this could cause a 
    # sparse representation of a matrix with wasted space. Find a way to 
    # "clean up" the @strat 
    def remove_node(index)
        @strat.remove_node(index)
    end
    
end