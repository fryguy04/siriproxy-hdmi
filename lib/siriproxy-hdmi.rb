require 'cora'
require 'siri_objects'
require 'pp'

#######
######

class SiriProxy::Plugin::Hdmi < SiriProxy::Plugin
  attr_accessor :deviceHash
  attr_accessor :roomHash

  def initialize(config)
    @rooms   = Hash.new
    @devices = Hash.new
    @rooms   = config["roomHash"]
    @devices = config["deviceHash"]

  end

  # Examples: 
  #   Watch Tivo Everywhere
  #   Watch Apple in Basement

  # TODO: Passed in via config

  listen_for /(?:Watch|Launch) (TiVo|DVD|Apple|PC)(?: ?TV)? (?:every where|everywhere)/i do |device|

    say "Watching #{device} Everywhere" #say something to the user!

    puts "**************************"
    dev = deviceHash[device].to_s()

    for room in 1..4
      cmd = room.to_s() + dev
      puts cmd
      `echo #{cmd} | nc 192.168.0.70 4999`
      sleep 0.5
    end
    request_completed #always complete your request! Otherwise the phone will "spin" at the user!
  end

  # 
  listen_for /(?:Watch|Launch) (TiVo|DVD|Apple|PC)(?: ?TV)? (?:in|and)(?: the)? (family room|kitchen|bedroom|basement)/i do |device,room|
    say "Watching #{device} in the #{room}" #say something to the user!

    puts "**************************"
    cmd = roomHash[room].to_s() + deviceHash[device].to_s()
    puts cmd

    `echo #{cmd} | nc 192.168.0.70 4999`

    request_completed #always complete your request! Otherwise the phone will "spin" at the user!
  end

end
