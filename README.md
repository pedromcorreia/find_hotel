
# Find Hotel Test
> I tried to divide my resolution in a linear progression with my reasoning, problems faced, and so on.

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

![https://s3-us-west-2.amazonaws.com/secure.notion-static.com/341f2b7c-850e-4708-9b4b-c155042cdf5d/Untitled.png](https: // s3-us-west -2.amazonaws.com/secure.notion-static.com/341f2b7c-850e-4708-9b4b-c155042cdf5d/Untitled.png)

Ok, the result was expressive, but not ideal, as no user could be waiting for your answer, and a timeout could happen in the middle of the process, for that, my first attempt was to create a Genserver to deal with this problem:

![https://s3-us-west-2.amazonaws.com/secure.notion-static.com/9236b095-0c06-4918-9041-55b84fffe957/Untitled.png](https: // s3-us-west -2.amazonaws.com/secure.notion-static.com/9236b095-0c06-4918-9041-55b84fffe957/Untitled.png)

And the result was good, the process happened in the background, with that the process happened in parallel and in the background, validating my ideas, I got as a result for 1_000 records:

![https://s3-us-west-2.amazonaws.com/secure.notion-static.com/fbd07b9d-d98d-47e2-9cae-310a1b0def46/Untitled.png](https: // s3-us-west -2.amazonaws.com/secure.notion-static.com/fbd07b9d-d98d-47e2-9cae-310a1b0def46/Untitled.png)

However, I noticed some problems with this approach that I have been working with Genserver:

1. What would happen with the next deployment with the processes scheduled on the Genserver or that are still running?
2. If we are running on Kubernetes, depending on the number of replicates, we will have this amount of Genserver, in that sense, not knowing which pod has a problem in the middle of the process or if we need to access some data from within the Genserver is a bit complicated, each one of us is going to create our own Genserver, we can get around this, but it is not ideal.

Okay, knowing these problems, we could go for an approach to use [Oban] (https://github.com/sorentwo/oban), he persists his workers inside Postgres, we can let him know when to run or not a certain process, besides that we can use it as a cronjob, the choice of it made me safer when viewing jobs running, problems that I listed with the choice of Genserver and synchronous use, in addition, it was the fastest process.

### Project

Okay, but I realized one of the specifications was that the resolution has two applications, a Parser to process the files and a web to consume the Parser's data, my first idea was to create two applications, a web with only phoenix and another ecto project containing the whole process, however, one of the points that most intrigued me, is that the repository should be private, to get around this, a long time ago, 2015, I worked with an Umbrella project, very similar where we had a web interface, and it consumed the data from a Parser, so that was my choice.

![https://s3-us-west-2.amazonaws.com/secure.notion-static.com/ced00245-dd68-458a-8d32-43c1ec00c7a7/Untitled_Diagram_ (7) .png](https: // s3- us-west-2.amazonaws.com/secure.notion-static.com/ced00245-dd68-458a-8d32-43c1ec00c7a7/Untitled_Diagram_(7).png)

There are some problems with this approach, such as:

1. High coupling and code dependency in two different applications;
2. For large projects maintenance is complex, and decoupling applications is difficult;

**TL; DR** This test was the most complex tests I ever received, but it was nice to solve and think in different cases.
