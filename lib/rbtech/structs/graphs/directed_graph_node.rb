class Rbtech::DirectedGraphNode << Rbtech::IndexedNode


    def initialize(data, id, graph)
        super(data, id)
        @graph = graph
    end

    def connections
        @graph.connections(self.id)
    end

    def add_connection(to:)

    end

    def add_connection(from: )

    end

    



end