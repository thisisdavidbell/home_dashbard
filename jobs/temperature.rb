# jobs/market.rb
SCHEDULER.every "10s", first_in: 0 do |job|
#  data = [
#    { "x" => 1980, "y" => 1323 },
#    { "x" => 1981, "y" => 53234 },
#    { "x" => 1982, "y" => 2344 }
#  ]
#  send_event(:market_value, points: data)
points = [{x:1, y: 20}, {x:2, y:15}, {x:3, y:25}]
send_event('nursery-temp', points: points, min:10, max:30, renderer: 'area', colors:'grey', displayedValue: "Nursery 25 C")

end
