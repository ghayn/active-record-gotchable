require 'test_helper'

class GotChaEqualsTest < ActiveSupport::TestCase
  def test_equals
    create_author_list(count: 5)

    author = Author.first
    records = Author.gotcha(payload: {
      name: author.name
    }).equals([:name]).relation

    assert_equal 1, records.count
    assert_equal [author.name], records.map(&:name)
  end

  def test_equals_with_miss_match
    create_author_list(count: 5)

    records = Author.gotcha(payload: {
      name: "foobar"
    }).equals([:name]).relation

    assert_equal 0, records.count
  end

  def test_equals_with_joins
    create_author_with_books_list(author_count: 5, book_count: 5)

    author = Author.first

    records = Book.joins(:author).gotcha(payload: {
      "author_name": author.name
    }).equals(["authors.name"]).relation

    assert_equal author.books.count, records.count
    assert_equal author.books.map(&:name), records.map(&:name)
  end

  def test_equals_with_joins_miss_match
    create_author_with_books_list(author_count: 5, book_count: 5)
    records = Book.joins(:author).gotcha(payload: {
      "author_name": "foobar"
    }).equals(["authors.name"]).relation

    assert_equal 0, records.count
  end
end
