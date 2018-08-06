require 'test_helper'

class GotchaScopeTest < ActiveSupport::TestCase
  def before_setup
    super

    @matched_time = Time.parse("1997-4-1").to_s
    matched_time_before = Time.parse("1997-3-31").to_s
    matched_time_after = Time.parse("1997-4-2").to_s
    @matched_author_book_count = 6

    @matched_authors = create_author_with_books_list(prefix: "author", author_count: 6, book_count: @matched_author_book_count, author_payload: { created_at: @matched_time })
    create_author_with_books_list(prefix: "author", author_count: 4, book_count: 4, author_payload: { created_at: matched_time_before })
    create_author_with_books_list(prefix: "author", author_count: 5, book_count: 5, author_payload: { created_at: matched_time_after })
  end

  def test_between_scope_time_match
    records = Author.gotcha.between_scope(["created_at"], { "created_at" => [@matched_time, @matched_time] }).relation

    assert_equal @matched_authors.count, records.count
    assert_equal @matched_authors.map(&:name), records.map(&:name)
  end

  def test_between_scope_value_match
    records = Author.gotcha.between_scope(["books_count"], { "books_count" => [@matched_author_book_count, @matched_author_book_count + 1 ]}).relation

    assert_equal @matched_authors.count, records.count
    assert_equal @matched_authors.map(&:name), records.map(&:name)
  end

  def test_between_time_scope_match
    records = Author.gotcha.between_time_scope(["created_at"], { "created_at" => [@matched_time, @matched_time]}).relation

    assert_equal @matched_authors.count, records.count
    assert_equal @matched_authors.map(&:name), records.map(&:name)
  end

  def test_between_value_scope_match
    records = Author.gotcha.between_value_scope(["books_count"], { "books_count" => [@matched_author_book_count, @matched_author_book_count + 1 ]}).relation

    assert_equal @matched_authors.count, records.count
    assert_equal @matched_authors.map(&:name), records.map(&:name)
  end

  def test_between_scope_time_with_specified_type_match
    records = Author.gotcha.between_scope(["created_at"], { "created_at" => [@matched_time, @matched_time]}, :datetime).relation

    assert_equal @matched_authors.count, records.count
    assert_equal @matched_authors.map(&:name), records.map(&:name)
  end

  def test_between_scope_value_with_specified_type_match
    records = Author.gotcha.between_scope(["books_count"], { "books_count" => [@matched_author_book_count, @matched_author_book_count + 1 ]}, :other).relation

    assert_equal @matched_authors.count, records.count
    assert_equal @matched_authors.map(&:name), records.map(&:name)
  end

  def test_between_time_scope_miss_match
    time_str = Time.now.to_s
    records = Author.gotcha.between_scope(["created_at"], { "created_at" => [time_str, time_str]}, :datetime).relation
    assert_equal 0, records.count
  end

  def test_between_value_scope_miss_match
    records = Author.gotcha.between_value_scope(["books_count"], { "books_count" => [1000, 2000]}).relation
    assert_equal 0, records.count
  end
end
