# frozen_string_literal: true

$LOAD_PATH.unshift File.dirname(__FILE__)

require 'date'

class Probe
  attr_reader :name

  def initialize(name, mod_date, ctime)
    @name = name
    @mod_date = mod_date
    @ctime = ctime
  end

  def days_silent?(date_now)
    # approx secs/day is good enough
    (seconds_silent?(date_now) / 86_400).to_i
  end

  def hours_silent?(date_now)
    (seconds_silent?(date_now) / 3600).to_i
  end

  def seconds_silent?(date_now)
    check_epoch = Time.at(date_now)
    mod_epoch = Time.at(@mod_date)
    ctime_epoch = Time.at(@ctime)

    return -1 if mod_epoch == ctime_epoch

    [0, (check_epoch - mod_epoch)].max
  end

  def silent?(date_now, interval)
    case interval
    when :seconds
      seconds_silent?(date_now)
    when :hours
      hours_silent?(date_now)
    else
      days_silent?(date_now)
    end
  end
end
