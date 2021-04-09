module Rbtech::GraphSearchable


    include Rbtech::HasNodes


    def bfs(start_node, get_connections_lambda, &block)
        seen = Array.new(nodes.length, false)
        queue = [start_node]
        while queue.length > 0
            node = queue.shift
            if !seen[node]
                seen[node] = true
                break if yield(node)
                conns = get_connections_lambda(node)
                conns.each do |conn|
                    queue << conn
                end
            end
        end
        
    end


    def dfs(start_node, get_connections_lambda, &block)
        seen = Array.new(node.length, false)
        stack = [start_node]
        seen[start_node] = true
        while stack.length > 0
            conns = get_connections_lambda(stack[-1]).filter{|el| !seen[el] }
            if conns.length > 0
                conns.each do |conn|
                    stack << conn
                    stack[conn] = true
                end
            else
                node = stack.pop
                break if yield(node)
            end
        end
    end

    def dijkstra(start_node, get_connections_lambda, end_node = nil)

        node_heap = Rbtech::BinaryHeap.new(nodes: nodes)
        lengths = Array.new(node.length)
        paths = Array.new(node.length)
        node_heap.update_node(start_node, ->(node){node.update})

    end

    class DijkstraNode

        attr_reader :id, :dist, :hops

        def initialize(id)
            @id = id
            @dist = 0
            @hops = []
        end

        def update(dist, hops)
            @dist, @hops = dist, hops
        end

    end


end