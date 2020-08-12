class Rbtech::AdjacencyMatrixStrategy

    def initialize(nodes = [])
        # adj list is a multi-dimensional array.
        # each element of the outside arary is an array
        # of [connected_node, distance] tuples
        @nodes = nodes
        @adj_mat = Array.new(node_count) do |i|
            Array.new(node_count){|j| Float::INFINITY } # TODO: i == j ? 0 : Float::INFINITY ???
        end
    end

    # O(n^2) due to memory re-allocation under the hood
    def add_node(data)
        @nodes << data
        for i in 0...node_count
            @adj_mat[i] << Float::INFINITY
        end
        @adj_mat << Array.new(node_count + 1){ Float::INFINITY }
    end

    # O(edge_count)
    def remove_node(node_index)
        @nodes[node_index] = nil
        remove_connections_from(node_index)
        remove_connections_to(node_index)
    end

    # O(1)
    def remove_connections_from(node_index)
        @adj_mat[node_index] = Array.new(node_count){ Float::INFINITY }
    end

    #O(vertex_count)
    def remove_connections_to(node_index)
        for i in 0...@adj_mat.length
            @adj_mat[i][node_index] = Float::INFINITY
        end
    end

    #O(vertice_count)
    def remove_connections_undirected(node_index)
        @adj_mat[node_index].each.with_index do |weight, other_node_index|
            if weight < Float::INFINITY
                @adj_mat[node_index][other_node_index] = Float::INFINITY
                @adj_mat[other_node_index][node_index] = Float::INFINITY
            end
        end
    end

    # O(1)
    def add_connection(from: , to:, weight: 1)
        @adj_mat[from][to] = weight
    end

    # O(1)
    def remove_connection(from_index: , to_index: )
        @adj_mat[from_index][to_index] = Float::INFINITY
    end

    # O(vertex_count)
    def get_connections_from(node_index)
        @adj_mat[node_index].map.with_index do |weight, to_index|
            weight < Float::INFINITY ? [to_index, weight] : nil
        end.compact
    end

    # O(vertex_count)
    def get_connections_to(node_index) 
        @adj_mat.map.with_index do |row, from_index|
            row[node_index] < Float::INFINITY ? [from_index, weight] : nil
        end.compact
    end

    # O(1)
    def connection_exist?(from:, to:)
        connection_weight(from: from, to: to) < Float::INFINITY 
    end

    # O(1)
    # Return infiinity if no connection exists
    def connection_weight(from: , to: )
        @adj_mat[from][to]
    end

    private

    def node_count
        @adj_mat.length
    end

end