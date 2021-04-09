module Rbtech::TrackableNodes

    include Rbtech::HasNodes

    def original_to_current_mapping
        @original_mapping ||= (0...@nodes.length).to_a
    end

    def current_to_original_mapping
        @current_mapping ||= (0...@nodes.length).to_a
    end

    def add_node(val)
        original_and_current_position = @nodes.length
        @nodes << val
        original_to_current_mapping << original_and_current_position
        current_to_original_mapping << original_and_current_position
        original_and_current_position
    end

    def get_current_node_index(original_index)
        original_to_current_mapping[original_index]
    end

    def get_node(original_index)
        @nodes[original_to_current_mapping[original_index]]
    end

    def swap_nodes(i,j)
        original_i_position = current_to_original_mapping[i]
        original_j_position = current_to_original_mapping[j]
        original_to_current_mapping[original_i_position] = j
        original_to_current_mapping[original_j_position] = i
        current_to_original_mapping[i] = original_j_position
        current_to_original_mapping[j] = original_i_position
        @nodes[i], @nodes[j] = @nodes[j], @nodes[i]
    end


end
