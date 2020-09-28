class Rbtech::AdjacencyListStrategy

    include Rbtech::HasNodes

    def initialize(nodes = [])
        # adj list is a multi-dimensional array.
        # each element of the outside arary is an array
        # of [connected_node, distance] tuples
        @nodes = nodes
        @adj_list = Array.new(@nodes.length){ Array.new }
    end

    # O(1)
    def add_node(data)
        @nodes << data
        @adj_list << Array.new
    end

    # O(edge_count)
    def remove_node(node_index)
        @nodes[node_index] = nil
        remove_connections_from(node_index)
        remove_connections_to(node_index)
    end

    # O(1)
    def remove_connections_from(node_index)
        @adj_list[node_index] = Array.new
    end


    #O(edge_count)
    def remove_connections_undirected(node_index)
        @adj_list[node_index].each do |i_weight_tuple|
            @adj_list[i_weight_tuple[0]] = @adj_list[i_weight_tuple[0]].filter{ |iwt| iwt[0] != node_index }
        end
        @adj_list[node_index] = Array.new
    end

    #O(edge_count)
    def remove_connections_to(node_index)
        for i in 0...@adj_list.length
            @adj_list[i] = @adj_list[i].filter{ |index_weight_tuple| index_weight_tuple[0] != node_index }
        end
    end

    # O(1)
    def add_connection(from: , to:, weight: 1)
        @adj_list[from] << [to, weight]
    end

    # O(edge_count)
    def remove_connection(from: , to: )
        @adj_list[from] = @adj_list[from].filter do |index_weight_tuple|
            index_weight_tuple[0] != to
        end
    end

    # O(1)
    def get_connections_from(node_index)
        @adj_list[node_index].to_a
    end

    # O(edge_count)
    def get_connections_to(node_index) 
        @adj_list.map.with_index do |connections, from_index|
            connections.find{|conn| conn[0] == node_index}&.dup&.tap{|conn| conn[0] = from_index }
        end.compact
    end

    # O(edge_count)
    def connection_exist?(from:, to:)
        connection_weight(from: from, to: to) < Float::INFINITY 
    end

    # O(edge_count)
    # Return infiinity if no connection exists
    def connection_weight(from: , to: )
        @adj_list[from].each do |index_weight_tuple|
            if index_weight_tuple[0] == to
                return index_weight_tuple[1]
            end
        end
        Float::INFINITY
    end

 end