module Generator
  class SampleData
    # quantity should be less than 17. Otherwise, generated time is going to exceed 24:00.
    def events(quantity)
      (1..quantity).inject([]) do |events, i|
        events << {
          "title" => "Event " + i.to_s, 
          "location" => "Location " + i.to_s, 
          "details" => "Details " + i.to_s + ". Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.", 
          "start_time" => sprintf('%02d', (i - 1) + 6) + ":00",
          "end_time" => sprintf('%02d', (i - 1) + 7) + ":00"
        }
      end
    end
    
    def get_data_raw(events)
      data = '{"data":{"items":['
      events.each do |event|
        data += %{
          {
            "title":"#{event['title']}",
            "location":"#{event['location']}",
            "details":"#{event['details']}",
            "when":[
              {
                "start":"#{Date.today.next.to_s}T#{event['start_time']}:00.000+09:00",
                "end":"#{Date.today.next.to_s}T#{event['end_time']}:00.000+09:00"
              }
            ]
          },
        }
      end
      data.slice!(-10) if events.count > 1
      data += ']}}'
    end
  end
end