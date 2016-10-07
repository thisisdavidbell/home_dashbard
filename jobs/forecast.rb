require 'net/https'
require 'json'

# Forecast API Key from https://developer.forecast.io
forecast_api_key = "c1d38739aff9cc47ed148a6293714f93"

# Latitude, Longitude for location
forecast_location_lat = "50.929588"
forecast_location_long = "-1.303068"

hot = 18
cold = 13

# Unit Format
# "us" - U.S. Imperial
# "si" - International System of Units
# "uk" - SI w. windSpeed in mph
forecast_units = "uk"
  
SCHEDULER.every '5m', :first_in => 0 do |job|
  http = Net::HTTP.new("api.forecast.io", 443)
  http.use_ssl = true
  http.verify_mode = OpenSSL::SSL::VERIFY_PEER
  response = http.request(Net::HTTP::Get.new("/forecast/#{forecast_api_key}/#{forecast_location_lat},#{forecast_location_long}?units=#{forecast_units}"))
  forecast = JSON.parse(response.body)  
  forecast_current_temp = forecast["currently"]["temperature"].round
  forecast_current_icon = forecast["currently"]["icon"]
  forecast_current_desc = forecast["currently"]["summary"]
  if forecast["minutely"]  # sometimes this is missing from the response.  I don't know why
    forecast_next_temp  = forecast["hourly"]["data"][1]["temperature"].round
    forecast_next_desc  = forecast["minutely"]["summary"]
    forecast_next_icon  = forecast["minutely"]["icon"]
  else
    puts "Did not get minutely forecast data again"
    forecast_next_desc  = "No data"
    forecast_next_icon  = ""
  end
  forecast_later_temp  = forecast["daily"]["data"][2]["temperatureMax"].round
  forecast_later_desc   = forecast["hourly"]["summary"]
  forecast_later_icon   = forecast["hourly"]["icon"]

  # calulate true/false for hot nice cold
  current_is_hot = forecast_current_temp > hot
  current_is_cold = forecast_current_temp < cold
  current_is_nice = forecast_current_temp <= hot && forecast_current_temp >= cold

    # calulate true/false for hot nice cold
  next_is_hot = forecast_next_temp > hot
  next_is_cold = forecast_next_temp < cold
  next_is_nice = forecast_next_temp <= hot && forecast_next_temp >= cold

    # calulate true/false for hot nice cold
  later_is_hot = forecast_later_temp > hot
  later_is_cold = forecast_later_temp < cold
  later_is_nice = forecast_later_temp <= hot && forecast_later_temp >= cold


  send_event('forecast', { current_temp: "#{forecast_current_temp}&deg;C", current_icon: "#{forecast_current_icon}", current_desc: "#{forecast_current_desc}", next_icon: "#{forecast_next_icon}", next_desc: "#{forecast_next_temp}&deg;C</br>#{forecast_next_desc}", later_icon: "#{forecast_later_icon}", later_desc: "Max #{forecast_later_temp}&deg;C<br>#{forecast_later_desc}", current_red: current_is_hot, current_green: current_is_nice, current_blue: current_is_cold, next_red: next_is_hot, next_green: next_is_nice, next_blue: next_is_cold, later_red: later_is_hot, later_green: later_is_nice, later_blue: later_is_cold})
end
