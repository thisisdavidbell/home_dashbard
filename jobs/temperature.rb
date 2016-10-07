rooms = []
rooms << { name: "Nursery", idx: "5", dataid: 'nursery-temp' }
rooms << { name: "Master", idx: "6", dataid: 'master-temp' }
hot = 20
cold = 16

# jobs/market.rb
SCHEDULER.every "10s", first_in: 0 do |job|
#  data = [
#    { "x" => 1980, "y" => 1323 },
#    { "x" => 1981, "y" => 53234 },
#    { "x" => 1982, "y" => 2344 }
#  ]
#  send_event(:market_value, points: data)

  rooms.each do |room|
        uri = URI.parse("http://192.168.1.80:8081/json.htm?type=graph&sensor=temp&idx=#{room[:idx]}&range=day")
        http = Net::HTTP.new(uri.host, uri.port)
   #     http.use_ssl = true
   #     http.verify_mode = OpenSSL::SSL::VERIFY_NONE

        request = Net::HTTP::Get.new(uri.request_uri)
        response = http.request(request)
    temp_array = JSON.parse(response.body)['result']
    array_length = temp_array.length
    data = []

 #   print "last element: "
 #   puts temp_array.last

#    print "array length: "
#    output = array_length
#    puts output

#    print "start: "
    start = (array_length % 4) - 1
#    output = start
#    puts output

    (start..(array_length-1)).step(4) do |it| 
#        puts it
#        puts temp_array[it]['te']
        data << { x: it, y: temp_array[it]['te'] }
    end

#    puts data
    displayValue = "#{room[:name]} #{temp_array.last['te']} C";
  
    currtemp = temp_array.last['te']
    toohot =  currtemp >= hot
    toocold = currtemp <= cold
    justright = currtemp > cold && currtemp < hot

    send_event(room[:dataid], points: data, min:15, max:25, renderer: 'area', colors:'grey', displayedValue: displayValue, red: toohot, green: justright, blue: toocold)

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