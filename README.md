# CFPB VS IEX

A quick and dirty to look up complaints in the Consumer Financial Protection
Bureau api, and compare that against IEX stock exchange data.

I'd been meaning to play with the CFPB data and this seemed like as good an
excuse as I was likely to find.

Programming time (including the design doc below) begins at 8pm.

## The APIs in question

* CFPB: https://dev.socrata.com/foundry/data.consumerfinance.gov/jhzv-w97w
* IEX: https://iextrading.com/developer/docs/#authentication

## Gameplan / milestones / punchlist

* Central goal A: Simple frontend to look up a company (or pick one at random) and see how their stock price is doing
* Central goal B: For the top 5 companies in terms of (some metric -- stock price?), how many consumer complaints do they have?

* Write a service connector for a CFPB complaint
* Write a service connector for an IEX 
* Figure out how to translate IEX companies into CFPB complaint companies
* Write a frontend for Goal A
* Dockerize so it's runnable
* In remaining time: Write a frontend for goal B

## Setup instructions

* clone
* `rails db:create` (there's no db here, it's all service objects)
* `rails s`
* Browser to `localhost:3000`
* Mash `toyota` in form and see what happens

## Postmortem

The core idea (match CFPB data to stock data) is at least technically feasible. The main technical wrench was writing a matching algorithm that could get from CFPB name (a case sensitive search!) to an IEX symbol. This is janky but it definitely works.

The limited scope of CFPB complaints and their data was a bit of a curveball. There just aren't that many of them, and most of them are small-scale collection agencies that aren't publicly traded. I think there's a story to tell with this data, but it is not 'consumer complaints vs stock price' which is largely meaningless. Maybe something like 'is there a relationship between a number of complaints in a calendar year vs a stock's change in a year for a certain 5 companies?' In other words, I think there's a story in here, but I didn't guess what it was in this MVP.

Knowing that I most likely won't touch the code again after this weekend means I left a couple bodies buried. The most egregious is that there's not a consistent approach to error handling or blank responses, which should be handled on the service object level instead of 'kinda the controller, but also kinda the service objects, but also kinda the views'. That's pretty awful, but also there's a working thing after 4hrs of programming, so hey!

Also, sorry for no tests.

Next three steps, were I to pick this back up or spend more than 4h on it:

* fix design flaws in the form/frontend (It doesn't really have that much charm, and doesn't feel like it pops)
* better and consistent error handling (Way too hard to trace problems)
* consistent data handling practices (I still feel a little bad about syms and strings as keys in the same hash)
