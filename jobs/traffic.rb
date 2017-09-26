require 'net/http'
require 'net/https'
require 'uri'
require 'json'

office_location = URI::encode('50.929588,-1.303068')
key             = URI::encode('ewtq388cxgnu8uqfgbkabxks')
locations       = []
#locations << { name: "Sam2", location: URI::encode('-25.764803,28.34625') } # example location format
locations << { name: "IBM (back route)", targettime: "26", redtime: "30", via: URI::encode('50.993645,-1.328241'), location: URI::encode('51.021931,-1.394223') }
locations << { name: "IBM (motorway)", targettime: "25", redtime: "29", via: URI::encode('50.983058,-1.365861'), location: URI::encode('51.021931,-1.394223') }
locations << { name: "Harefield", targettime: "15", redtime: "20", via: URI::encode('50.925351,-1.350519'), location: URI::encode('50.920739,-1.346909') }
locations << { name: "Gatcombe Gdns", targettime: "14", redtime: "18", via: URI::encode('50.927199,-1.326009'), location: URI::encode('50.929479,-1.354186') }
#locations << { name: "Pr Anne Hospital", targettime: "23", redtime: "30", via: URI::encode('50.934836,-1.434885'), location: URI::encode('50.934971,-1.435207') }
SCHEDULER.every '10m', :first_in => '15s' do |job|
    routes = []

    # pull data
    locations.each do |location|
        uri = URI.parse("https://api.tomtom.com/routing/1/calculateRoute/#{office_location}:#{location[:via]}:#{location[:location]}/json?routeType=fastest&traffic=true&travelMode=car&key=#{key}")
        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = true
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE

        request = Net::HTTP::Get.new(uri.request_uri)
        response = http.request(request)
        routes << { name: location[:name], location: location[:location], targettime: location[:targettime], redtime: location[:redtime], route: JSON.parse(response.body)["routes"][0] }
    end
#print "ROUTES after REST CALL"
#puts routes

    # find winner
    if routes
        #dont reorder
        # routes.sort! { |route1, route2| route2[:route]["summary"]["travelTimeInSeconds"] <=> route1[:route]["summary"]["travelTimeInSeconds"] }
        routes.map! do |r|
            { name: r[:name],
                time: seconds_in_words(r[:route]["summary"]["travelTimeInSeconds"].to_i),
                road: delay(r[:route]["summary"]["trafficDelayInSeconds"]),
                distance: meters_to_miles(r[:route]["summary"]["lengthInMeters"].to_i),
                red: r[:redtime].to_i*60 < r[:route]["summary"]["travelTimeInSeconds"].to_i,
                amber: (r[:targettime].to_i*60) <= r[:route]["summary"]["travelTimeInSeconds"].to_i && (r[:redtime].to_i*60) >= r[:route]["summary"]["travelTimeInSeconds"].to_i,
                green: (r[:targettime].to_i*60) > r[:route]["summary"]["travelTimeInSeconds"].to_i
            }
        end
    end

#    print "ROUTES after PROCESSING"
#    puts routes
    # send event
  send_event('tomtom', { results: routes } )
end

def seconds_in_words(secs)
    m, s = secs.divmod(60)
    h, m = m.divmod(60)

    plural_hours = if h > 1 then "s" else "" end
    plural_minutes = if m > 1 then "s" else "" end

    if secs >= 3600
        "#{h} hour#{plural_hours}, #{m} min#{plural_minutes}"
    else
        "#{m} min#{plural_minutes}"
    end
end

def delay(delay_seconds)
    m, s = delay_seconds.divmod(60)
    h, m = m.divmod(60)

    if delay_seconds >= 60
        "#{m} min delay"
    elsif delay_seconds == 0
        ""
    else
        "#{s} sec delay"
    end
end

def meters_to_miles(meters)
    miles = (meters / 1609.34).round(1)
    "(#{miles} miles)"
end
