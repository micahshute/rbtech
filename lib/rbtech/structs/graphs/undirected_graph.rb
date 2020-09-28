class Rbtech::UndirectedGraph < Rbtech::Graph

    def connect(node1, node2, weight: 1)
        add_connection(node1, node2, weight: weight)
    end

    def add_connection(node1, node2, weight: 1)
        n1i, n2i = to_index(node1), to_index(node2)
        @strat.add_connection(from: n1i, to: n2i, weight: weight)
        @strat.add_connection(from: n2i, to: n1i, weight: weight)
    end

    def remove_connection(node1, node2)
        n1i, n2i = to_index(node1), to_index(node2)
        @strat.remove_connection(from_index: n1i, to_index: n2i)
        @strat.remove_connection(from_index: n2i, to_index: n1i)
    end

    def remove_connections(node)
        ni = to_index(node)
        @strat.remove_connections_undirected(ni)
    end

    def get_node(i)
        @nodes[i]
    end

    def [](index)
        @nodes[index]
    end

    def get_connections(n)
        @strat.get_connections_from(fromi)
    end

    def connection_exist?(a,b)
        fromi, toi = to_index(a), to_index(b)
        @strat.connection_exist?(from: fromi, to: toi) || @strat.connection_exist?(from: toi, to: fromi)
    end

    def connection_weight(a,b)
        fromi, toi = to_index(a), to_index(b)
        d1 = @strat.connection_weight(from: fromi, to: toi) 
        d1 < Float::INFINITY ? d1 : @strat.connection_weight(from: toi, to: fromi)
    end

    #TODO: Decide whether or not to allow nodes to be passed in
    def to_index(arg)
        arg
    end

end