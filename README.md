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
