require 'docile'
require_relative 'dsl/content_builder'

module LDIF
  module DSL
    def ldif(&block)
      Docile.dsl_eval(ContentBuilder.new, &block).build
    end
    module_function :ldif
  end
end
