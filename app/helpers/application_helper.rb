module ApplicationHelper
  def google_map(center)
  "https://maps.googleapis.com/maps/api/staticmap?center=#{center}&size=300x300&zoom=17"
  end
  def format_time(time)
  	time.in_time_zone(Time.zone).strftime('%B %e at %l:%M %p')
  end
end
