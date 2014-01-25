#!/usr/bin/ruby
# encoding: utf-8

require 'carrier-pigeon'
require 'twitter'
require 'pp'
require 'kconv'

Twitter.configure do |config|
  config.consumer_key       = ''
  config.consumer_secret    = ''
  config.oauth_token        = ''
  config.oauth_token_secret = ''
end 

server = "irc.freenode.org:6667"
channel = '#hosting-ja'
now = Time.new

# color code of message
# \x03 + color number
#
# 0 white
# 1 black
# 2 blue (navy)
# 3 green
# 4 red
# 5 brown (maroon)
# 6 purple
# 7 orange (olive)
# 8 yellow
# 9 light green (lime)
# 10 teal (a green/blue cyan)
# 11 light cyan (cyan) (aqua)
# 12 light blue (royal)
# 13 pink (light purple) (fuchsia)
# 14 grey
# 15 light grey (silver)
color = "\x0312"

interest_users = [
  "def_jp",
  "jpcert",
  "malware_jp",
  "security_info",
  "JVN",
  "security_inci",
  "FSECUREBLOG",
  "exploitdb",
]

interest_users.each do |user|
  Twitter.user_timeline(user).each do |tweet|
    if now - tweet[:created_at] < 60 * 15
      message = tweet.text.sub(/\n/, "")
      CarrierPigeon.send(
        :uri      => "irc://" + user + "tter@" + server + "/" + channel,
        :message  => color + "[" + tweet[:created_at].to_s + "] " + message,
        :ssl      => false,
        :join     => false,
        :notice   => true,
      )
      sleep 2
    end
  end
  sleep 1
end

