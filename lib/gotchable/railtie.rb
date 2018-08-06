module Gotchable
  class Railtie < ::Rails::Railtie
    initializer "gotchable.active_record" do
      ActiveSupport.on_load :active_record do
        require "gotchable/acts_as_gotchable"
        ActiveRecord::Base.send :extend, Gotchable::ActsAsGotchable
      end
    end
  end
end
