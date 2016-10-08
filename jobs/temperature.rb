require 'time'

rooms = []
rooms << { name: "Nursery", idx: "5", dataid: 'nursery-temp', desc: 'nursery' }
rooms << { name: "Master", idx: "6", dataid: 'master-temp', desc: 'master' }
hot = 20
cold = 16
batteryChange = 5
warningAppear = 120

# jobs/market.rb
SCHEDULER.every "10s", first_in: 0 do |job|
#  data = [
#    { "x" => 1980, "y" => 1323 },
#    { "x" => 1981, "y" => 53234 },
#    { "x" => 1982, "y" => 2344 }
#  ]
#  send_event(:market_value, points: data)

  rooms.each do |room|
    idx = 0;
    battery = 0;
    lastUpdated = 0;
# find idx from device description
        uri = URI.parse("http://192.168.1.80:8081/json.htm?type=devices&filter=temp&used=true&order=Name")
        http = Net::HTTP.new(uri.host, uri.port)
        request = Net::HTTP::Get.new(uri.request_uri)
        response = http.request(request)
        jsonresponse = JSON.parse(response.body)
    devices_array = jsonresponse['result']
    # puts devices_array
    devices_array.each do |device|
      if device['Description'] == room[:desc]
        idx = device['idx']
        battery = device['BatteryLevel']
        lastUpdated = Time.parse(device['LastUpdate']).to_i
      end
    end

    # calculate time since last update
    actualTime = jsonresponse['ActTime']
    timeSinceLastUpdate = actualTime - lastUpdated

    hide_warning = timeSinceLastUpdate < warningAppear

# get temp for device from idx
        uri = URI.parse("http://192.168.1.80:8081/json.htm?type=graph&sensor=temp&idx=#{idx}&range=day")
        http = Net::HTTP.new(uri.host, uri.port)
        request = Net::HTTP::Get.new(uri.request_uri)
        response = http.request(request)
    temp_array = JSON.parse(response.body)['result']
    array_length = temp_array.length
    data = []

    start = (array_length % 4) - 1

    (start..(array_length-1)).step(4) do |it| 
        data << { x: it, y: temp_array[it]['te'] }
    end

    # should we display the battery icon?
    hide_battery = battery > batteryChange;
    
    displayValue = "#{room[:name]} #{temp_array.last['te']} C";
  
    # determine temp colour
    currtemp = temp_array.last['te']
    toohot =  currtemp >= hot
    toocold = currtemp <= cold
    justright = currtemp > cold && currtemp < hot

    send_event(room[:dataid], points: data, min:15, max:25, renderer: 'area', colors:'grey', displayedValue: displayValue, red: toohot, green: justright, blue: toocold, hideBattery: hide_battery, hideWarning: hide_warning)

  end
  send_event('temptile', nothing: 'this_sets_updated_at')
#points = [{x:1, y: 20}, {x:2, y:15}, {x:3, y:25}]

#print "points: "
#puts points

#send_event('nursery-temp', points: points, min:10, max:30, renderer: 'area', colors:'grey', displayedValue: "Nursery 25 C")
end




# pasted notes
#    locations.each do |location|
#        uri = URI.parse("https://api.tomtom.com/routing/1/calculateRoute/#{office_location}:#{location[:via]}:#{location[:location]}/json?routeType=fastest&traffic=true&travelMode=car&key=#{key}")
#        http = Net::HTTP.new(uri.host, uri.port)
#        http.use_ssl = true
#        http.verify_mode = OpenSSL::SSL::VERIFY_NONE
#
#        request = Net::HTTP::Get.new(uri.request_uri)
#        response = http.request(request)
#        routes << { name: location[:name], location: location[:location], targettime: location[:targettime], redtime: location[:redtime], route: JSON.parse(response.body)["routes"][0] }
#    end