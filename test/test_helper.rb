# Configure Rails Environment
ENV["RAILS_ENV"] = "test"

require_relative "../test/dummy/config/environment"
ActiveRecord::Migrator.migrations_paths = [File.expand_path("../test/dummy/db/migrate", __dir__)]
require "rails/test_help"
require "time"

# Filter out Minitest backtrace while allowing backtrace from other libraries
# to be shown.
Minitest.backtrace_filter = Minitest::BacktraceFilter.new

require "rails/test_unit/reporter"
Rails::TestUnitReporter.executable = 'bin/test'

# Load fixtures from the engine
if ActiveSupport::TestCase.respond_to?(:fixture_path=)
  ActiveSupport::TestCase.fixture_path = File.expand_path("fixtures", __dir__)
  ActionDispatch::IntegrationTest.fixture_path = ActiveSupport::TestCase.fixture_path
  ActiveSupport::TestCase.file_fixture_path = ActiveSupport::TestCase.fixture_path + "/files"
  ActiveSupport::TestCase.fixtures :all
end

def create_author_list(prefix: "author", count:, payload: {})
  (1..count).map do |n|
    Author.create({ name: "#{prefix}#{n}" }.merge(payload))
  end
end

def create_author_with_books_list(prefix:"author", author_count:, book_count:, author_payload: {}, book_payload: {})
  (1..author_count).map do |author_n|
    author = Author.create!({ name: "#{prefix}#{author_n}" }.merge(author_payload))
    book_count.times do |book_n|
      author.books.create!({
        name: "#{author.name}'s book#{book_n}",
        isbn: "#{author.name}'s isbn#{book_n}"
      }.merge(book_payload))
    end
    author
  end
end
