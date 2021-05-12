# Find Hotel Test
I tried to divide my resolution in a linear progression with my reasoning, problems faced, and so on.

## Process and choices

### CSV processing

First, I received the CSV with the data and I thought, ok, it will be simple, I will read the file and store it if necessary, but first I will go through a function and list the lines. It was fast and met my expectations, it only took 23 seconds.

### Data validation and processing

However, everything was too good to be true, I realized that some data was empty, without validation, so I needed to create some validations, such as:

- unique IP;
- Latitude and longitude;
- Country;
- Country code;
- Parents and the code were the same;
- I realized that the city could be validated, but I didn't find anything simple to do that unless a textual search on google, for this reason, I didn't implement it.

> In positivity, I added a contribution to the lib that I used from countries [https://github.com/SebastianSzturo/countries/pull/56/201(https://github.com/SebastianSzturo/countries/pull/56).

After creating the validations, I ran it again and inserted the valid entries into the bank, but to my surprise, it took 2 hours to process the entire CSV, so I thought, how can I do to reduce the processing time? Well, we can parallelize it and to my surprise, the idea was very valid.

With the functions parallel, the validations and creations in the bank was reduced to less than an hour of processing.

![image](https://user-images.githubusercontent.com/11159324/117871731-257f9200-b274-11eb-92fd-b73c17723b30.png)

Ok, the result was expressive, but not ideal, as no user could be waiting for your answer, and a timeout could happen in the middle of the process, for that, my first attempt was to create a Genserver to deal with this problem:

![image](https://user-images.githubusercontent.com/11159324/117871788-33351780-b274-11eb-8d56-734dd909eff5.png)

And the result was good, the process happened in the background, with that the process happened in parallel and in the background, validating my ideas, I got as a result for 1_000 records:

![image](https://user-images.githubusercontent.com/11159324/117871829-3cbe7f80-b274-11eb-8673-0fbe87969201.png)

However, I noticed some problems with this approach that I have been working with Genserver:

1. What would happen with the next deployment with the processes scheduled on the Genserver or that are still running?
2. If we are running on Kubernetes, depending on the number of replicates, we will have this amount of Genserver, in that sense, not knowing which pod has a problem in the middle of the process or if we need to access some data from within the Genserver is a bit complicated, each one of us is going to create our own Genserver, we can get around this, but it is not ideal.

Okay, knowing these problems, we could go for an approach to use [Oban] (https://github.com/sorentwo/oban), he persists his workers inside Postgres, we can let him know when to run or not a certain process, besides that we can use it as a cronjob, the choice of it made me safer when viewing jobs running, problems that I listed with the choice of Genserver and synchronous use, in addition, it was the fastest process.

### Cronjob

As part of requirements is to think in a process to run a schedule job, with Oban we can use as a  [Cronjob](https://github.com/sorentwo/oban#periodic-jobs)  adding a new module "Parser.Cron.CoordinateCron" that will follow the config rules defined in "config/config.exs" with:

    config :parser, Oban,
      repo: Parser.Repo,
      plugins: [
        {Oban.Plugins.Cron,
         crontab: [
           {"@daily", Parser.Cron.CoordinateCron}
         ]}
      ]

Or we can configure as a scheduled job, the default Parser configuration is 5 minutes, you can change in config/config.ex

    config :parser,
      schedule_job_time: 300

So every process will return with a status: "scheduled".

### Project

Okay, but I realized one of the specifications was that the resolution has two applications, a Parser to process the files and a web to consume the Parser's data, my first idea was to create two applications, a web with only phoenix and another ecto project containing the whole process, however, one of the points that most intrigued me, is that the repository should be private, to get around this, a long time ago, 2015, I worked with an Umbrella project, very similar where we had a web interface, and it consumed the data from a Parser, so that was my choice.

![Untitled Diagram (7)](https://user-images.githubusercontent.com/11159324/117871853-421bca00-b274-11eb-8032-c18563077cf2.png)

There are some problems with this approach, such as:

1. High coupling and code dependency in two different applications;
2. For large projects maintenance is complex, and decoupling applications is difficult;

**TL; DR** This test was the most complex tests I ever received, but it was nice to solve and think in different cases.

## How to run?

### Get Started
To run this project you, docker and docker-compose need to be installed on your machine.

#### Clone this repository

    git clone git@github.com:pedromcorreia/find_hotel.git
    cd find_hotel

#### Build project with docker

    docker-compose build

#### Create database and run migrations

    docker-compose run --rm web mix do ecto.create, ecto.migrate

#### Run all services

    docker-compose up

Use -d to run in the background. Use --build to ensure images are rebuilt. Use docker-compose down to stop all services.

HTTP endpoint available at: http://localhost:4000/
Or you can check with:

    curl --request GET --url http://localhost:4000/api/coordinates/ip_address/:ip_address

#### Attach iex


    docker-compose run --rm web bash
#### Attach session

    docker attach (docker ps -lq)
  #### To populate the Parser service
 This will create data with sample CSV.

      docker-compose run --rm web bash
      iex -S mix
 1. You can create a process with sample data as:

      iex> Parser.init
      [info] Import completed, result: %{errors: 996, success: 4, time_elapsed: 108}
2. Or with a CSV placed in parser/priv/NAME.csv

      iex> Parser.init "DIR/Name.csv"
      [info] Import completed, result: %{errors: XXX, success: XXX, time_elapsed: XXX}
Then in your favorite terminal

    curl --request GET --url http://localhost:4000/api/coordinates/ip_address/38.111.125.236

#### Run integration tests

    docker-compose run --rm web mix test
