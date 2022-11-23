# -*- encoding: SHIFT_JIS -*-
# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path("../test", __dir__)
require "test_helper"

class TestAddressIndexer < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::AddressIndexer::VERSION
  end
  def test_step1
    AddressIndexer.join_same_records '/test.csv'
  end
  def test_step2
    AddressIndexer.index_csv_file '/KEN_JOINED.csv'
  end
  def test_step3
    AddressIndexer.create_ngram_index_file '/KEN_JOINED.csv'
  end
  def test_step4
    AddressIndexer.search_using_ngram_and_index_files('飯田','/KEN_JOINED.csv')
  end

end
