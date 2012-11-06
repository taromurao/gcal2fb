module Gcal2Fb
  class Gcal
    def events
      if (data = data_raw['data']['items']).count == 0
        nil
      else
        data.inject([]) do |events, event|
          events << {
           'title' => event['title'],
           'location' => event['location'],
           'details' => event['details'],
           'start_time' => DateTime.parse(event['when'][0]['start']).strftime('%H:%M'),
           'end_time' => DateTime.parse(event['when'][0]['end']).strftime('%H:%M'),
          }
        end
      end
    end
    
    def data_raw
      uri = URI.parse("http://www.google.com")
      
      # Fetches events starting from next day 00:00 to 23:59
      start_time = Date.today.next.to_time.to_datetime.to_s.gsub('+','%2B')
      end_time = (Date.today.next.next.to_time - 1).to_datetime.to_s.gsub('+','%2B')
      
      req = Net::HTTP::Get.new("/calendar/feeds/#{Config.cal_id}/public/full?start-min=#{start_time}&start-max=#{end_time}&sortorder=a&alt=jsonc")
      http = Net::HTTP.new(uri.host, uri.port)
      res = http.start { |http| http.request(req) }
      if res.code == '200'
        JSON.parse(res.body)
      else
        raise 'Failed to connect to GCal API'
      end
    end
  end
end