class Rbtech::Graph

    STRATEGIES = [
        :adjacency_list,
        :adjacency_matrix
    ]

    def self.new_from_nodes(nodes, strategy: :adjacency_list)
        new(nodes: nodes, strategy: strategy)
    end

    attr_reader :size

    def initialize(nodes: [], strategy: :adjacency_list)
        case strategy
        when :adjacency_list
            @strat = Rbtech::AdjacencyListStrategy.new(nodes)
        when :adjacency_matrix
            @strat = Rbtech::AdjacencyMatrixStrategy.new(nodes)
        else
            raise ArgumentError.new("Please choose a valid connection strategy: #{STRATEGIES}") 
        end
        @size = nodes.length
    end

    def nodes
        @strat.nodes
    end

    def add_node(data)
        @strat.add_node(data)
        @size += 1
    end 

    # TODO: Strategies as of now just remove all connections to and
    # from a node. If one removes a node frequently, this could cause a 
    # sparse representation of a matrix with wasted space. Find a way to 
    # "clean up" the @strat 
    def remove_node(index)
        @strat.remove_node(index)
        @ize -= 1
    end
    
end