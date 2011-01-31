require 'time'
require 'active_support/all'

class App < Sinatra::Base
  set :gowalla, Gowalla::Client.new(:username => ENV['GOWALLA_USER'],
                                    :password => ENV['GOWALLA_PASS'],
                                    :api_key => ENV['GOWALLA_APIKEY'])
  set :haml, :format => :html5

  get '/' do
    @at_polly = :no
    # Determine if the last place I checked in was polly. If < 3 hours ago I'm there, otherwise maybe
    if settings.gowalla.user.last_checkins[0].spot.name == 'Polly'
      checkin_time = Time.parse(settings.gowalla.user.last_checkins[0].created_at)
      if checkin_time < 6.hours.ago
        @at_polly = :no
      elsif checkin_time < 3.hours.ago
        @at_polly = :maybe
      else
        @at_polly = :yes
      end
    else
      # Checked in elsewhere, no
      @at_polly = :no
    end
    haml "%h1#outcome #{@at_polly.to_s.capitalize}"
  end
end
