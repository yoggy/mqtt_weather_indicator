mqtt_weather_indicator.rb
====
mqtt_neopixelと組み合わせて使う3時間おきの天気予報表示

- mqtt_neopixel
  - https://github.com/yoggy/mqtt_neopixel

How to use
----

    $ git clone https://github.com/yoggy/mqtt_weather_indicator
    $ cd mqtt_weather_indicator
    $ sudo gem install mqtt
    $ sudo gem install weather_pinpoint_jp
    $ cp config.yaml.sample config.yaml
    $ vi config.yaml

        host:      iot.eclipse.org
        port:      1883
        use_auth:  false
        username:  username
        password:  password
        postalcode: 2300000
        publish_topic: weather/2300000

    $ ./mqtt_weather_indicator.rb

    $ crontab -e 
    3 0 * * * /home/pi/work/mqtt_weather_indicator/mqtt_weather_indicator.rb >/dev/null 2>&1

Copyright and license
----
Copyright (c) 2017 yoggy

Released under the [MIT license](LICENSE.txt)
