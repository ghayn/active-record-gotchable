require 'test_helper'

class DataGeneratorTest < ActiveSupport::TestCase
  def test_create_author_list
    create_author_list(prefix: "author", count: 10)
    assert_equal 10, Author.count
  end

  def test_create_author_should_has_uniq_name
    create_author_list(prefix: "author", count: 5)
    create_author_list(prefix: "user", count: 5)
    assert_equal 10, Author.all.map(&:name).uniq.size
  end

  def test_create_author_with_books_list
    create_author_with_books_list(prefix: "author", author_count: 5, book_count: 3)
    assert_equal 5, Author.count
    assert_equal 15, Book.count
  end

  def test_create_author_with_books_list_author_has_books
    create_author_with_books_list(prefix: "author", author_count: 5, book_count: 5)
    Author.all.each do |author|
      assert_equal 5, author.books.count
    end
  end

  def test_create_author_with_books_list_should_has_different_book_and_author
    create_author_with_books_list(prefix: "author", author_count: 3, book_count: 5)
    create_author_with_books_list(prefix: "user", author_count: 2, book_count: 5)
    assert_equal 5, Author.all.map(&:name).uniq.size
    assert_equal 25, Book.all.map(&:name).uniq.size
    assert_equal 25, Book.all.map(&:isbn).uniq.size
  end
end
