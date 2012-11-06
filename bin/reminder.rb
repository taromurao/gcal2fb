$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'gcal2fb/reminder'

reminder = Gcal2Fb::Reminder.new
reminder.run