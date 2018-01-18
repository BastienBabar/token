require "test_helper"

class TokenTest < Minitest::Test
  def setup
    setup_db
    @token = TestModel.create
  end

  def test_that_it_has_a_version_number
    refute_nil ::Token::VERSION
  end

  def must_generate_a_default_formatted_token
    assert_match @token.generate, /([A-Z]{4})\-([A-Z]{4})\-([A-Z]{4})\-([A-Z]{4})/
  end

  def must_return_a_random_block_of_size_4
    assert_match @token.random_block(4), /([A-Z]{4})/
  end

  def must_return_a_token_with_3_blocks_of_size_3_with_separator
    assert_match @token.generate_token(3, "*", 3), /([A-Z]{3})\*([A-Z]{3})\*([A-Z]{3})/
  end

end

class TestModel < ActiveRecord::Base
  tokenize! attribute: 'identity', separator: ':', block_size: 4, number_of_blocks: 2
end