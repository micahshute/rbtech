class Rbtech::DirectedGraph < Rbtech::Graph


    def add_connection(from: , to: , weight: 1)
        @strat.add_connection(from_index: fromi, to_index: toi, weight: weight)
    end

    def remove_connection(from:, to: )
        @strat.remove_connection(from_index: from, to_index: to)
    end

    def remove_connections(from: nil, to: nil )
        raise ArgumentError.new("You cannot specify from and to") if from && to
        raise ArgumentError.new("You must specify either from: or to: which node connections are to be removed from") if !(from || to)
        if from
            remove_connections_from(from)
        end 
        if to
            remove_connections_to(to)
        end
    end

    def remove_connections_from(n)
        @strat.remove_connections_from(n)
    end

    def get_node(i)
        @strat.nodes[i]
    end

    def [](index)
        strat.nodes[index]
    end

    def remove_connections_to(n)
        @strat.remove_connections_to(n)
    end

    def get_connections_from(n)
        @strat.get_connections_from(fromi)
    end

    def get_connections_to(n)
        @strat.get_connections_to(toi)
    end

    def connection_exist?(from: , to: )
        @strat.connection_exist?(from_index: from, to_index: to)
    end

    def connection_weight(from:, to: )
        @strat.connection_weight(from_index: from, to_index: to)
    end



end