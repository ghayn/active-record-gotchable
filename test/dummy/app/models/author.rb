class Author < ApplicationRecord
  has_gotchable
  has_many :books
end
