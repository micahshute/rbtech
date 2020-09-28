module Rbtech::TrackableNodes

    include Rbtech::HasNodes

    def original_to_current_mapping
        @original_mapping ||= (0...@nodes.length).to_a
    end

    def current_to_original_mapping
        @current_mapping ||= (0...@nodes.length).to_a
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
