# LunchTime

#### 📀 Setup 📀

#### API Mode

While LunchTime will by default load the schedule from a configuration stored on the device, it can also pull data from 
a mock server built with [Sinatra](http://sinatrarb.com/).

In order for this to work, the Sinatra server must be installed and running. Within the root of the project:

```
gem install sinatra-contrib
ruby ./server.rb
```

#### Instructions

For this next step, you'll be creating a small sample app that showcases your skill and talent as an engineer. Expect
to take about 1-2 hours to complete it. Once completed, please reply with your code attached. Once the code has been
evaluated by our engineering team, you may be invited for a full panel interview with various members of the team. At
the full panel interview, we'll review your app with you and ask you to enhance it with a new set of requirements.

As we evaluate your code, we'll be looking for the following:

- Code structure and software architecture principles
- Ability to navigate ambiguous requirements
- Your unique strengths as a software engineer

Requirements

At Gusto, we really enjoy our catered lunches. We use a rotating schedule for the lunch menu, but it has been tricky
for us to keep track of it. To help us plan our week, we'd like an app that displays the lunch schedule on a calendar.
You'll find the raw lunch schedule data below.

Week 1
- Monday - Chicken and waffles
- Tuesday - Tacos
- Wednesday - Curry
- Thursday - Pizza
- Friday - Sushi

Week 2
- Monday - Breakfast for lunch
- Tuesday - Hamburgers
- Wednesday - Spaghetti
- Thursday - Salmon
- Friday - Sandwiches 