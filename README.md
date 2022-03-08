# Weather Watering

An app reminds you when to water your plants based on the weather in your area, daily water loss and the amount of water your plant requires to stay healthy.

## Install

### Clone the repository

```shell
$ git clone https://github.com/DanaGS/Weather-Watering
```

### Check your Ruby version

```shell
$ ruby -v
```

This project uses Ruby version 3.1.0 and Rails 7.0.2.2 version. If you you are using an older version you can see instructions on how to install the latest release on: https://www.ruby-lang.org/en/downloads/.

### Install dependencies

```shell
$ bundle install
```

### Set environment variables

This project uses Figaro to store environment variables: https://github.com/laserlemon/figaro. You will need to replace database name and credentials. 

This app uses external apis to obtain geolocation and weather data. You will need to sign up and obtain an api key for each:

https://openweathermap.org/
https://www.geoapify.com/


### Initialize the database

```shell
$ rails db:create db:migrate db:seed
```

### Serve

```shell
$ rails s
```

Run on localhost port:300

### Run Sidekiq and background tasks

The app uses Sidekiq with Redis to run background jobs. These jobs include making scheduled calls to OpenWeatherMap API to update weather data, calculate daily evapotranspiration, update plants soil water deficit, and send email reminders.

To run Redis:

```shell
$ redis-server
```

To run Sidekiq:

```shell
$ sidekiq
```
