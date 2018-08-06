module Gotchable
  if defined?(::Rails)
    require "gotchable/railtie"
  elsif defined?(::ActiveRecord)
    require "gotchable/acts_as_gotchable"
    ActiveRecord::Base.send :extend, Gotchable::ActsAsGotchable
  end
end
