# :first_in sets how long it takes before the job is first run. In this case, it is run immediately
SCHEDULER.every '30s', :first_in => 0 do |job|
  send_event('camera', { image: "http://admin:10psyrdrb@192.168.1.93:81/live/0/mjpeg.jpg" })
end
