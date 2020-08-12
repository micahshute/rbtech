require "rbtech/version"

module Rbtech
  class Error < StandardError; end
  # Your code goes here...
end

require 'bundler/setup'
Bundler.require(:default)
require_all 'lib/rbtech/concerns'
require_all 'lib/rbtech/strategies'
require_relative './rbtech/structs/linked_lists/linked_list_node'
require_relative './rbtech/structs/linked_lists/doubly_linked_list_node'
require_relative './rbtech/structs/indexed_node'
require_relative './rbtech/structs/graphs/graph'
require_relative './rbtech/structs/linked_lists/abstract_linked_list'
require_relative './rbtech/structs/linked_lists/singly_linked_list'
require_relative './rbtech/structs/linked_lists/doubly_linked_list'
require_all 'lib/rbtech/structs'

