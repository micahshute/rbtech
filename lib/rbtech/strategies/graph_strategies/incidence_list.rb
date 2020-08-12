class Rbtech::IncidenceListStrategy


    def initialize(nodes)
        @nodes = nodes
    end

    # O(1)
    def add_node(data)
        @nodes << Node.new(data)
    end

    # O(edge_count)
    def remove_node(i)
        n = @nodes[i]
        n.connections.each do |c|
            other_node = c.from == n ? c.to : c.from
            other_node.remove_connection(n)
        end
        @nodes[i] = nil
    end

    def remove_connections_from(arg)
        node = to_node(arg)
        node.remove_connections_from
    end

    def remove_connections_to(arg)
        node = to_node(arg)
        node.remove_connections_to
    end

    def remove_connections_undirected(arg)
        node = to_node(arg)
        node.remove_connections
    end
    
    def add_connection(from: arg1, to: arg2, weight: 1)
        node1 = to_node(arg1)
        node2 = to_node(arg2)
        node1.connect(to: node2, weight: weight)
    end
     
    def remove_connection(from: , to: )
        from_node = to_node(from)
        dest_node = to_node(to)
        from_node.remove_connection_to(dest_node)
    end

    def get_connections_from(arg)
        node = to_node(arg)
        node.connections_from
    end

    def get_connections_to(arg)
        node = to_node(arg)
        node.connections_to
    end

    def connection_exist?(from: , to:)
        from_node = to_node(from)
        dest_node = to_node(to)
        from_node.connection?(dest_node)
    end

    def connection_weight(from: , to:)
        from_node, dest_node = to_node(from), to_node(to)
        from_node.weight_to(dest_node)
    end


    class Connection

        attr_accessor :from, :to, :weight

        def initialize(from: , to: , weight: )
            @from, @to, @weight = from, to, weight
            @from.connections.add self
            @to.connections.add self
        end

        def remove
            @from.connections.delete self
            @to.connections.delete self
        end

        def destroy 
            remove
        end

    end


    class Node

        attr_accessor :data
        attr_reader :connections

        def initialize(data)
            @data = data
            @connections = Set.new
        end

        def connect(to: node, weight: 1)
            Connection.new(from: self, to: node, weight: weight)
        end

        def remove_connection(node)
            conns = connections.select{ |c| c.to == node || c.from == node}
            conns.each{ |c| c.remove }
        end

        def remove_connection_to(node)
            c = connections.find{|c| c.to == node}
            if c
                c.remove
                true
            else
                false
            end

        end

        def remove_connection_from(node)
            c = connections.find{|c| c.from == node}
            if c 
                c.remove
                true
            else
                false
            end
        end

        def connection_to?(node)
            self.connections.include?{ |c| c.to == node }
        end

        def connection_from?(node)
            self.connections.include?{ |c| c.from == node }
        end

        def connection?(node)
            self.connections.include?{ |c| c.to == node || c.from == node }
        end

        def connections_from
            self.connections.select{|c| c.from == self }
        end

        def connections_to
            self.connections.select{|c| c.to == self}
        end

        def remove_connections_from
            conns = connections.select{|c| c.from == self }
            conns.each { |c| c.remove }
        end

        def remove_connections_to
            conns = connections.select{|c| c.to == self }
            conns.each { |c| c.remove }
        end
        
        def weight_to(node)
            conn = self.connections.find do |c|
                c.to == node
            end
            conn ? conn.weight : Float::INFINITY
        end

    end

    private

    def to_node(arg)
        if arg.is_a? Node
            return arg
        elsif arg.is_a? Integer
            return @nodes[arg]
        else
            raise ArgumentError.new("You must pass in a Node object or an Integer")
        end
    end


end