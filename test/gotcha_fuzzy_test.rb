require 'test_helper'

class GotchaFuzzyTest < ActiveSupport::TestCase
  def test_fuzzy_full_match
    matched_prefix = "author"
    create_author_list(prefix: "author", count: 5)
    records = Author.gotcha.fuzzy([:name], matched_prefix).relation
    assert_equal Author.count, records.count
    assert_equal Author.all.map(&:name), records.map(&:name)
  end

  def test_fuzzy_partial_match
    create_author_list(prefix: "author", count: 5)
    author = Author.first
    records = Author.gotcha.fuzzy([:name], author.name).relation
    assert_equal 1, records.count
    assert_equal [author.name], records.map(&:name)
  end

  def test_fuzzy_with_miss_match
    miss_matched_prefix = "foobar"
    create_author_list(prefix: "author", count: 5)
    records = Author.gotcha.fuzzy([:name], miss_matched_prefix).relation
    assert_equal 0, records.count
  end

  def test_fuzzy_with_joins_match
    create_author_with_books_list(author_count: 5, book_count: 5)
    author = Author.first
    records = Book.gotcha.joins(:author).fuzzy(['authors.name', 'books.isbn'], author.name).relation
    assert_equal author.books.count, records.count
    assert_equal author.books.map(&:name), records.map(&:name)

  end

  def test_fuzzy_with_joins_miss_match
    miss_matched_prefix = "foobar"
    create_author_with_books_list(author_count: 5, book_count: 5)

    records = Author.gotcha.joins(:books).fuzzy(['authors.name', 'books.isbn'], miss_matched_prefix).relation
    assert_equal 0, records.count
  end
end
