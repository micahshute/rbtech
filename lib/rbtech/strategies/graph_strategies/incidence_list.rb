class Rbtech::IncidenceListStrategy


    def initialize(node_list)
        @node_list
    end


    def get_connections_from(node_index)
        @node_list[node_index].connections
    end


end