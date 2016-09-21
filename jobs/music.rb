SCHEDULER.every '10s', :first_in => '0s' do |job|
  `osascript /Users/david/dashing/home_dashboard/spotify.scpt`
end
