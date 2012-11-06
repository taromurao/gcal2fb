module Gcal2Fb
  class Config
    class << self
      attr_reader :cal_id, :page_token
    end

    @cal_id = ENV['DEPLOY'] == 'true' ? ENV['CAL_ID'] : ''
    @page_token = ENV['DEPLOY'] == 'true' ? ENV['PAGE_TOKEN'] : ''
  end
end