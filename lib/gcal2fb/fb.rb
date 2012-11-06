module Gcal2Fb
  class Fb
    def initialize
      @page_graph = Koala::Facebook::API.new(Config.page_token)
    end
    
    def remind_users(events)
      raise 'Posting events on FB failed.' if !@page_graph.put_connections('me', 'notes', subject: 'We have following events tomorrow', message: format(events))
    end
    
    def format(events)
      formatted = events.inject(String.new) do | formatted, event |
        formatted.insert(-1, "
          <p>Title: #{event['title']}</p>
          <p>Time: #{event['start_time']} - #{event['end_time']}</p>
          <p>Location: #{event['location']}</p>
          <p>Details: #{event['details']}</p>
          <br>
        ")
      end
      formatted.insert(-1, "<p>For more information, refer to the <a href = \'https://www.google.com/calendar/embed?src=#{Config.cal_id}\'>calendar</a>.</p>")
    end
    
    def notify_admin(err_msg)
      puts err_msg
    end
  end
end