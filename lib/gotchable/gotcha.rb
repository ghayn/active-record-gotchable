require "gotchable/gotchable_support"

module Gotcha
  extend ActiveSupport::Concern

  class_methods do
    def gotcha(equal_columns: [], like_columns: [], payload: {})
      @gotchable_support = Gotchable::GotchableSupport.new(self.where(nil))
      @gotchable_support.default_payload = payload
      if equal_columns.present?
        @gotchable_support = @gotchable_support.equals(equal_columns)
      end
      if like_columns.present?
        @gotchable_support = @gotchable_support.likes(like_columns)
      end
      @gotchable_support
    end
  end
end
