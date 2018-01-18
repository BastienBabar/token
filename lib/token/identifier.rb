module Token
  class Identifier
    # *ar_model* must be an activerecord model with a string *attribute* we want to tokenize
    #
    # ==== Options
    # * :separator - String separator between blocks in token
    # * :block_size - Size of each block
    # * :number_of_blocks - Number of blocks
    attr_accessor :attribute
    def initialize(ar_model, attribute, options = {})
      @ar_model = ar_model
      @attribute = attribute
      @separator = options[:separator] || '-'
      @block_size = options[:block_size] || 4
      @number_of_blocks = options[:number_of_blocks] || 4
    end

    def generate
      begin
        token = generate_token(@number_of_blocks, @separator, @block_size)
      end while @ar_model.find_by(@attribute.to_sym => token).present?
      token
    end

    def generate_token(number_of_blocks, separator, block_size)
      number_of_blocks.to_i.times.map { random_block(block_size) }.join(separator.to_s)
    end

    def random_block(block_size)
      [*('A'..'Z')].sample(block_size).join
    end

  end
end
