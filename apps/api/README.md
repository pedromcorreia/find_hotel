# API

API is a simple project created with [Elixir](https://elixir-lang.org/) and [Phoenix](https://www.phoenixframework.org/).
## Implementation

This project follow the [Phoenix Documentation](https://www.phoenixframework.org/),
It is required some libs and one of then is [Parser](https://github.com/pedromcorreia/find_hotel/tree/main/apps/parser), that supports with data and some resources used to list coordinates.

## Features

The only resource of API project is to create an interface between User and Parser application, response with information about the locations of an IP address, with and response with data if it is valid.

**Examples:**

    curl --request GET --url ${host}/api/coordinates/ip_address/38.111.125.236
    {
      "data": {
        "city": "Sethfurt",
        "country": "Bahrain",
        "country_code": "BH",
        "id": 1,
        "ip_address": "38.111.125.236",
        "latitude": -46.83383421249039,
        "longitude": 175.30463608673932,
        "mystery_value": "9875158070"
      }
    }

Or

    curl --request GET --url ${host}/api/coordinates/ip_address/invalid_ip_address
    {"data":null}
