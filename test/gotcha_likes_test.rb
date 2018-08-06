
require 'test_helper'

class GotchaLikesTest < ActiveSupport::TestCase
  def test_likes_match
    matched_prefix = "author"
    matched_records = create_author_list(prefix: matched_prefix, count: 3)
    create_author_list(prefix: "user", count: 5)

    records = Author.gotcha(payload: {
      name: matched_prefix
    }).likes([:name]).relation

    assert_equal 3, records.count
    assert_equal matched_records.map(&:name), records.map(&:name)
  end

  def test_likes_with_miss_match
    miss_match_prefix = "foobar"
    create_author_list(prefix: "author", count: 3)
    create_author_list(prefix: "user", count: 5)

    records = Author.gotcha(payload: {
      name: miss_match_prefix
    }).likes([:name]).relation

    assert_equal 0, records.count
  end

  def test_likes_with_joins_match
    matched_prefix = "author"
    matched_records = create_author_with_books_list(prefix: "author", author_count: 3, book_count: 4).map(&:books).flatten
    create_author_with_books_list(prefix: "user", author_count: 5, book_count: 4)

    records = Book.joins(:author).gotcha(payload: {
      "author_name": matched_prefix
    }).likes(["authors.name"]).relation

    assert_equal 12, records.count
    assert_equal matched_records.map(&:name), records.map(&:name)
  end

  def test_likes_with_joins_miss_match
    miss_matched_prefix = "foobar"
    create_author_with_books_list(prefix: "author", author_count: 3, book_count: 4)
    create_author_with_books_list(prefix: "user", author_count: 5, book_count: 4)

    records = Book.joins(:author).gotcha(payload: {
      "author_name": miss_matched_prefix
    }).likes(["authors.name"]).relation

    assert_equal 0, records.count
  end
end
