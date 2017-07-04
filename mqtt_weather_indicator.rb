#!/usr/bin/ruby
# -*- coding: utf-8 -*-
#
#  mqtt_weather_indicator.rb - mqtt_neopixelと組み合わせて使う3時間おきの天気予報表示
#
#  mqtt_neopixel
#    https://github.com/yoggy/mqtt_neopixel
#
#  how to use
#    $ git clone https://github.com/yoggy/mqtt_weather_indicator
#    $ cd mqtt_weather_indicator
#    $ sudo gem install mqtt
#    $ sudo gem install weather_pinpoint_jp
#    $ cp config.yaml.sample config.yaml
#    $ vi config.yaml
#
#        host:      iot.eclipse.org
#        port:      1883
#        use_auth:  false
#        username:  username
#        password:  password
#        postalcode: 2300000
#        publish_topic: weather/2300000
#
#    $ ./mqtt_weather_indicator.rb
#
#    $ crontab -e 
#    3 0 * * * /home/pi/work/mqtt_weather_indicator/mqtt_weather_indicator.rb >/dev/null 2>&1
#
#  license:
#    Copyright (c) 2017 yoggy <yoggy0@gmail.com>
#    Released under the MIT license
#    http://opensource.org/licenses/mit-license.php;
#
require 'mqtt'
require 'weather_pinpoint_jp'
require 'yaml'
require 'pp'

$stdout.sync = true

$log = Logger.new(STDOUT)
$log.level = Logger::DEBUG

$conf = YAML.load_file(File.dirname($0) + '/config.yaml')

# 天気データを取得
forecast = WeatherPinpointJp.get($conf['postalcode'], WeatherPinpointJp::POSTAL_CODE)
codes = forecast.weather_3h.slice(0, 8)

# 天気コード -> ws2812 color code
map = {
  100 => '#0c0600',  # sunny
  200 => '#060606',  # cloudy
  300 => '#00000c',  # rainy
  400 => '#000606',  # snowy
  500 => '#060101',  # too hot
  850 => '#04000c',  # heavy rain
}
color_code = codes.map{|c| map[c]}.join(",")

# mqtt publish
conn_opts = {
  "remote_host" => $conf["host"],
  "remote_port" => $conf["port"]
}
if $conf["use_auth"]
  conn_opts["username"] = $conf["username"]
  conn_opts["password"] = $conf["password"]
end

MQTT::Client.connect(conn_opts) do |c|
  $log.info "publish=" + color_code
  c.publish($conf['publish_topic'], color_code, true)
end

