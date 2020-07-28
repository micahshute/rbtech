class Rbtech::UndirectedGraph < Rbtech::Graph

    def add_connection(node1, node2, weight: 1)
        n1i, n2i = to_index(node1), to_index(node2)
        @strat.add_connection(from_index: n1i, to_index: n2i, weight: weight)
        @strat.add_connection(from_index: n2i, to_index: n1i, weight: weight)
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
        fromi = to_index(n)
        data = {}
        @strat.get_connections_from(fromi).each do |nodei_weight_tuple|
            data[@nodes[nodei_weight_tuple[0]]] = nodei_weight_tuple[1]
        end
        data
    end

    def connection_exist?(from: , to: )
        fromi, toi = to_index(from), to_index(to)
        @strat.connection_exist?(from_index: fromi, to_index: toi)
    end

    def connection_weight(from:, to: )
        fromi, toi = to_index(from), to_index(to)
        @strat.connection_weight(from_index: fromi, to_index: toi)
    end


end