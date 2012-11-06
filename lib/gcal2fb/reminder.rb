# Include Gcal2Fb modules
require 'gcal2fb/gcal'
require 'gcal2fb/fb'
require 'gcal2fb/config'

# Require external modules
require 'net/http'
require 'json'
require 'time'
require 'koala'

module Gcal2Fb
  class Reminder
    def initialize
      @gcal = Gcal.new
      @fb = Fb.new
    end
    
    def run
      begin
        return if !events = @gcal.events
        @fb.remind_users(events)
      rescue
        @fb.notify_admin($!.message)
      end
    end
  end
end