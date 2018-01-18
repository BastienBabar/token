require "active_record"
require "token"

module ActiveRecord
  class Base
    def self.tokenize!(options = {})
      unknown_keywords = options.keys - [ :attribute, :separator, :block_size, :number_of_blocks ]
      raise ArgumentError, "unknown keywords: #{unknown_keywords.join(", ")}" if unknown_keywords.any?

      self.instance_variable_set(:@token, Token::Identifier.new(self, options[:attribute],
                                                    {
                                                      separator: options[:separator],
                                                      block_size: options[:block_size],
                                                      number_of_blocks: options[:number_of_blocks]
                                                    }))

    end

    instance_eval do
      before_create do
        self.send("#{ self.class.instance_variable_get(:@token).attribute }=", self.class.instance_variable_get(:@token).generate)
      end
    end
  end


end