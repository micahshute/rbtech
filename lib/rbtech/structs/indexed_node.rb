class Rbtech::IndexedNode

    attr_accessor :data
    attr_reader :id

    def initialize(data, id=nil)
        @data, @id = data, id 
    end

end