class Rbtech::AdjacencyListStrategy

    def initialize(node_count=0)
        # adj list is a multi-dimensional array.
        # each element of the outside arary is an array
        # of [connected_node, distance] tuples

        # TODO: Turn into an array of LinkedList Objects (prevents array resizing)
        @adj_list = Array.new(node_count){ [] }
    end

    # O(1)
    def add_node
        @adj_list << []
    end

    # O(edge_count)
    def remove_node(node_index)
        remove_connections_from(node_index)
        remove_connections_to(node_index)
    end

    # O(1)
    def remove_connections_from(node_index)
        @adj_list[node_index] = []
    end

    #O(edge_count)
    def remove_connections_undirected(node_index)
        @adj_list[node_index].each do |i_weight_tuple|
            @adj_list[i_weight_tuple[0]] = @adj_list[i_weight_tuple[0]].filter{ |iwt| iwt[0] != node_index }
        end
        @adj_list[node_index] = []
    end

    #O(edge_count)
    def remove_connections_to(node_index)
        for i in 0...@adj_list.length
            @adj_list[i] = @adj_list[i].filter{ |index_weight_tuple| index_weight_tuple[0] != node_index }
        end
    end

    # O(1)
    def add_connection(from_index: , to_index:, weight: 1)
        @adj_list[from_index] << [to_index, weight]
    end

    # O(edge_count)
    def remove_connection(from_index: , to_index: )
        @adj_list[from_index] = @adj_list[from_index].filter do |index_weight_tuple|
            index_weight_tuple[0] != to_index 
        end
    end

    # O(1)
    def get_connections_from(node_index)
        @adj_list[node_index]
    end

    # O(edge_count)
    def get_connections_to(node_index) 
        @adj_list.map.with_index do |connections, from_index|
            connections.find{|conn| conn[0] == node_index}
        end.compact
    end

    # O(edge_count)
    def connection_exist?(from_index:, to_index:)
        connection_weight(from_index: from_index, to_index: to_index) < Float::INFINITY 
    end

    # O(edge_count)
    # Return infiinity if no connection exists
    def connection_weight(from_index: , to_index: )
        @adj_list[from_index].each do |index_weight_tuple|
            if index_weight_tuple[0] == to_index
                return index_weight_tuple[1]
            end
        end
        Float::INFINITY
    end

end