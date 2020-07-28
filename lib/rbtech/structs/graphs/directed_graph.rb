class Rbtech::DirectedGraph < Rbtech::Graph


    def add_connection(from: , to: , weight: 1)
        fromi, toi = to_index(from), to_index(to)
        @strat.add_connection(from_index: fromi, to_index: toi, weight: weight)
    end

    def remove_connection(from:, to: )
        fromi, toi = to_index(from), to_index(to)
        @strat.remove_connection(from_index: fromi, to_index: toi)
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
        fromi = to_index(n)
        @strat.remove_connections_from(fromi)
    end

    def get_node(i)
        @nodes[i]
    end

    def [](index)
        @nodes[index]
    end

    def remove_connections_to(n)
        toi = to_index(n)
        @strat.remove_connections_to(toi)
    end

    def get_connections_from(n)
        fromi = to_index(n)
        data = {}
        @strat.get_connections_from(fromi).each do |nodei_weight_tuple|
            data[@nodes[nodei_weight_tuple[0]]] = nodei_weight_tuple[1]
        end
        data
    end

    def get_connections_to(n)
        toi = to_index(n)
        data = {}
        @strat.get_connections_to(toi).each do |nodei_weight_tuple|
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