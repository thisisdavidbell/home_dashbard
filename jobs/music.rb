SCHEDULER.every '10s', :first_in => '0s' do |job|
  `osascript /Users/davidbell/projects/dashing/home_dashboard/spotify.scpt`
end
