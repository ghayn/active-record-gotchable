require "gotchable/gotcha"

module Gotchable
  module ActsAsGotchable
    def has_gotchable
      include Gotcha
    end
  end
end
