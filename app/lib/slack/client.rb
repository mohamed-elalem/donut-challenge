class Slack::Client
  class << self
    def instance
      @instance ||= Slack::Web::Client.new
      
      @instance
    end
  end
end