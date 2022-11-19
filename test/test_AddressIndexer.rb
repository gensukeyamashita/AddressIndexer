# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path("../test", __dir__)
require "test_helper"

class TestAddressIndexer < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::AddressIndexer::VERSION
  end

  def test_it_does_something_useful
    #AddressIndexer.loadCsvIntoListOfList
    #AddressIndexer.printList
    AddressIndexer.printListForUserInput('東京都')
    #assert false
  end
end
