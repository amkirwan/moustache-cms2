require 'time_formatted'

module MoustacheCMS2
  module StateSetable
    extend ActiveSupport::Concern

    included do
      # attr_accessible :current_state, :current_state_attributes

      embeds_one :current_state, 
                 :as => :publishable,
                 :cascade_callbacks => true 
                
      accepts_nested_attributes_for :current_state

      validates :current_state, :presence => true

    end

    MoustacheCMS2::TimeFormatted.instance_methods(false).each do |method|
      delegate method, :to => :current_state_humanize, :allow_nil => true
    end

    def current_state_humanize
      MoustacheCMS2::TimeFormatted.new(self)
    end

  end
end
