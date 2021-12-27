require 'sinatra'
require 'sinatra/reloader'
require 'json'

get '/api/menu' do
  [
    {
      "dayOfTheWeek": "Sunday"
    },
    {
      "dayOfTheWeek": "Monday",
      "description": "Chicken and Waffles"
    },
    {
      "dayOfTheWeek": "Tuesday",
      "description": "Tacos"
    },
    {
      "dayOfTheWeek": "Wednesday",
      "description": "Curry"
    },
    {
      "dayOfTheWeek": "Thursday",
      "description": "Pizza"
    },
    {
      "dayOfTheWeek": "Friday",
      "description": "Sushi"
    },
    {
      "dayOfTheWeek": "Saturday",
    },
    {
      "dayOfTheWeek": "Sunday"
    },
    {
      "dayOfTheWeek": "Monday",
      "description": "Breakfast"
    },
    {
      "dayOfTheWeek": "Tuesday",
      "description": "Hamburgers"
    },
    {
      "dayOfTheWeek": "Wednesday",
      "description": "Spaghetti"
    },
    {
      "dayOfTheWeek": "Thursday",
      "description": "Salmon"
    },
    {
      "dayOfTheWeek": "Friday",
      "description": "Sandwiches"
    },
    {
      "dayOfTheWeek": "Saturday",
    }
  ].to_json
end