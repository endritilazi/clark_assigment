# README

Clark assignment solution (Implement a system for calculating rewards based on recommendations of customers.):

I have used Ruby on Rails framework for assignment. All the logic of the implementation will be found under services/rewards_system directory. I have created a class called `CustomersCollection` which holds an hash inside with all the customers that will be in input data. For Customer representation I have created another class called `Customer` that contains all the nessesary fields for name, inviter, points and confirmed status. Also I have done the other implementation for the validation of the data, input parser, api formater, reward calculator etc. All of these implementation with be found in seperated classes under the services/rewards_system directory. The API endpoint implementation will be found at `RewardsController`. I have tried to seperate all the thing having in mine that this project has to be scalable/changable easily and also I have tried to follow the priniciples that we talked about in the first interview. For unit testing I have user rspec gem and for the code style I have used rubocop gem. There is no extra gem used beside these two one


### Database
   - `There is no database as long as it was not required and I didn't see it nessesary`

### Requirements:
 - `Ruby version >= 2.4.1`
 - `Bundler version 1.16.1`

### Installation:
 - `bundle install`

### Running Tests:
 - `bundle exec rspec`
 - `rubocop`

### Run:
 - `rails s`
 
### Api endpoint for test
 - `curl -X POST localhost:3000/rewards/calculate --data-binary @history_example.txt`
