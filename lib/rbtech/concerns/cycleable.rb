module Cycleable


    ## Detect cycles and return the starting element
    # ARGS:
    # first_pointer :: the "pointer" to the first element in the list. 
    # This should be the same datatype that you want take_step to return in
    # the future. 
    #
    # take_step :: lambda (or proc). 
    # Take_step takes in the output of the previous take_step 
    # (whatever is best for that data structure. This can be implemented by the "user")
    # or the data structure can override this method and implement it itself). At the end of the
    # day, take_step should return some "pointer" to the associated element in the collection, and be 
    # able to use that to get the next element when it is called in the future
    # If the end of the collection is hit, the take_step method should return nil
    # If no loop is found, tortoise_hare returns null
    #
    # The block is used to compare / check equality
    # If no block is given, the default is ==
    def tortoise_hare(first_pointer, take_step, &block)
        # Start with the tortoise and the hare on the first element
        tortoise = first_pointer
        hare = take_step[tortoise]

        # Return nil if we have reached the end of the list
        return nil if !tortoise || !hare

        #If a block is not supplied, just do a simple equality check on
        # the two pointers
        if !block_given?
            block = ->(a,b){ a == b }
        end

        # While the cycle has not been found 
        while !block[tortoise,hare]
            # Move the tortoise one space and the hare 2 spaces
            tortoise = take_step[tortoise]
            hare = take_step[take_step[hare]]
            # Return nil if the end of the list has been reached
            return nil if !tortoise || !hare 
    
        end

        # The code only gets here if a cycle has been found. Otherwise
        # it would have returned nil on lines 24 or 39.
        # To determine the first element in the cycle, put the tortoise
        # at the very beginning and step them both until their values agree
        # (See description below)

        tortoise = first_pointer
        hare = take_step[hare]

        while !block[tortoise, hare]
            tortoise = take_step[tortoise]
            hare = take_step[hare]
            if tortoise.nil? || hare.nil?
                return nil
            end
        end

        # Code will get here once the tortoise and the hare are on the 
        # same block

        # We will have the tortoise win the race
        # Return the pointer to the first element in the cycle
        return tortoise

    end

    # Logic behind tortoise and hare:
    # If a cycle exists (of size N), then for any element in a collection i, if you 
    # went to the "next" element i + kN times (where k is any integer), then you would 
    # be on the same element as you started. Therefore it follows that if "original" index i
    # is the value kN, then the element 2i will be the same element as i. (This is because
    # i = kN, so 2i = 2kN = kN because k is any integer). So, the hare will always just go  
    # two steps for every step that the tortoise takes. If a cycle exists, once the tortoise gets
    # to an index in the cycle which is some kN, then the hare will be at the same element. 
    #
    # After it is found that a cycle exists, the tortoise is put back at the very beginning and 
    # the hare is incremented a single step. (This is because they both began "before" the first
    # element, so by putting the tortoise on the first element to keep the same distance the hare must
    # be incremented a single step. You could implement it so they begin on the first element and you 
    # would not step the hare in this case)
    # We know that the distance between the tortoise and the hare is now some kN value, because 
    # they met at some i = kN. Because the distance between the two is an exact multiple
    # of the cycle length, then if we maintain this distance between them by moving them both one 
    # pace at a time, as soon as the tortoise gets to the cycle the hare will be at the same position,
    # thus revealing the FIRST element in the cycle.
    #
    # This algorithm was influenced by "exponential search", which can help speed up binary
    # search by, instead of starting to search in the middle of the array, instead 
    # start with the first element in the array and then each subsequent 2*i element until you find 
    # an upper bound to the element you are searching for. Then binary search within that range.
    # Instead of binary searching, we are checking each 2^xth value to see if a cycle exists.
    # Once we know it does, we do a linear step until the first element is reached.

end