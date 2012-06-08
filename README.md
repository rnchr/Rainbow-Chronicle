# README for Rainbow Chronicle
## Intro
Overall, the site is not incredibly complicated. I tried to DRY up the code while writing it, but there are some quirks and non-DRY annoyances.

## Server Info
### Accounts
		root:railgunAJ4j7Gln6
		andrew:rainbows47

Note: andrew has full sudo privileges.

Host: 50.56.182.200

### Production:
We are running a Phusion Passenger standalone instance under the 'andrew' user account. We also have a staging instance, although I haven't used it in a while.

		/home/andrew/rails_apps/production/Rainbow-Chronicle

To start:

		sudo passenger start -p 80 --user=andrew -d -e production
To stop:

		sudo passenger stop --pid-file tmp/pids/passenger.80.pid

To run migrations, be sure set the environment!

		RAILS_ENV=production rake db:migrate

### Deployment:
The general procedure is to develop and test features on your own machine, and then push directly to production.

On your machine, first push to the github repo:

		git push origin master
Then log into the server, cd to the production instance and

		git pull
Changes generally take some time to propagate unless you restart the server. Keep in mind that each time you modify the stylesheets or assets, you will need to re-compile them on the server (incl. env).

		rake assets:precompile
#### Trivia
We are also using Redis for caching. There is no password on the instance, but in the event of a server restart, you may need to restart it as well.

		redis-server

## Models

There are four primary models.

News, Events, Leaders and Places

News is very straightforward, but E/L/P are very much the same. I will briefly outline the three.

* Each has_many ratings, which are implemented as a (Leader|Event|Place)Rating type.
* Each belongs_to a user.
* Each has_many users through ratings
* Each has\_many (leader|event|place)_types, which are joined through the respective *\_categories tables. The type refers to the tagged category hierarchy. The hierarchical categories are handled using the closure\_tree gem.
** This is confusing, so please note: all of the \*Type models are children of the Category model, not related to the *Category models. Class Category defines the acts\_as\_tree relation to make them hierarchical.

News is much simpler, it just has a bunch of comments attached and an author.

The other important mode is Report, which handles reported postings. Apparently this is actually a legal requirement.

There is also a Rating model, which defines questions for each listing type that will appear on their respective pages.

## How Things Work
### Geolocation awareness
We use the geocoder gem for location based queries and detection. The relevant load\_location function, which is run for all pageviews, is located in application\_controller.rb
### DRY controllers for E/L/P models
If you have a look in these controllers, I've attempted to abstract common actions. The quirk is that because there are two types of places, corporate and local, I don't use the general functions in PlacesController#show. This is shitty, but make sure when you are editing some functionality for all three that you refactor this or add the appropriate change in PlacesController as well.
### Tests
There aren't any. :(
### Monitoring
We use New Relic for monitoring. They are pretty awesome.