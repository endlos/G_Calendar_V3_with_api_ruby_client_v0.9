class StaticController < ApplicationController
require 'googleauth'
require 'google/apis/calendar_v3'

ENV['GOOGLE_APPLICATION_CREDENTIALS'] = "M4H2-4d7d508c4d96.json"
Calendar = Google::Apis::CalendarV3

  def calendar
    @custom_calendar="tcau6tfdf80sga1t1p5r7lkmio@group.calendar.google.com"
    #@custom_calendar="primary"

    calendar = Calendar::CalendarService.new
    calendar.authorization = Google::Auth.get_application_default([Calendar::AUTH_CALENDAR])
    
    # Create an event, adding any emails listed in the command line as attendees
    event = Calendar::Event.new(summary: 'A sample event',
                                location: '1600 Amphitheatre Parkway, Mountain View, CA 94045',
                                attendees: ARGV.map { |email| Calendar::EventAttendee.new(email: email) },
                                start: Calendar::EventDateTime.new(date_time: DateTime.parse('2015-12-31T20:00:00')),
                                end: Calendar::EventDateTime.new(date_time: DateTime.parse('2016-01-01T02:00:00')))
    event = calendar.insert_event("#{@custom_calendar}", event, send_notifications: true)
    puts "Created event '#{event.summary}' (#{event.id})"
    
    # List upcoming events
    events = calendar.list_events("#{@custom_calendar}", max_results: 10, single_events: true,
                                  order_by: 'startTime', time_min: Time.now.iso8601)
    puts "Upcoming events:"
    events.items.each do |event|
      start = event.start.date || event.start.date_time
      puts "- #{event.summary} (#{start}) (ID: #{event.id})"
    end

    redirect_to ok_path
  end

  def ok
  end
end
