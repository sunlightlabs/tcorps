# TransparencyCorps

TransparencyCorps is a volunteer-driven, decentralized microtask campaign platform.

## What does that mean?

In fact, it's really more of an enhanced microtask directory, as no tasks are actually hosted inside TransparencyCorps.  To keep a consistent user experience, TransparencyCorps will load these externally hosted tasks in an iframe, surrounded by a TransparencyCorps-branded bar, and the user will never appear to leave transparencycorps.org.

Since TransparencyCorps is volunteer-driven, users who complete tasks are awarded points, and after accumulating certain amounts of points, can reach certain "levels".  Users can upload avatars of themselves, and the most accomplished users are featured on the front page.

Organizations who want to run a TransparencyCorps task will create a "Campaign".  A campaign consists of some descriptive copy and HTML, the URL of their task application to land users at, and some basic parameters about how many times to run the task and how many points to award for completion.

TransparencyCorps, and tasks built to interoperate with it, use a narrow, simple API (documented below) to communicate, and to award users points for completing these tasks.

## Managing a Campaign

The campaign management area for TransparencyCorps is at transparencycorps.org/admin.  A user will need to have been granted admin access by Sunlight Labs before this URL will be accessible.  Once a user has been given access, they should see a link to the Admin area on the header bar, once they are logged in.

Inside the campaign management area, a campaign manager can create, update, and delete campaigns (but only their own, obviously).  Campaign ownership is given to a particular user; they cannot be jointly owned by more than one user account.  Some basic statistics regarding that user's campaigns will be shown in a sidebar inside this area.


## API

The API has two parts - creating a new task, and completing a task.

### A New Task

When the user asks for a new task from a campaign, an iframe is brought up within TransparencyCorps that will load up the campaign's URL for that task.  This is a GET request, and a few parameters will be passed along in the query string:

* task_key - This is a randomly generated unique key that the campaign application must keep throughout the user's interaction with the campaign.  This key will be needed once the campaign is completed, to signal TransparencyCorps that the user should be awarded points.
* username - The Transparency user's username.  A campaign might use this to welcome the user by name.
* points - The number of points that the user has accumulated towards this particular campaign.  A campaign might use this to give harder tasks to more experienced users.

An example URL might be:

http://your-site.com/campaign?task_key=03bd230045e5bcd12e46e2e7c08dbdd4&username=freddy&points=150

Of course, campaigns should bear in mind that this URL can be spoofed, and so each of these parameters could be fake.  In the future, we may introduce a mechanism to guarantee that each of these parameters comes directly from TransparencyCorps.  For the time being, we have chosen simplicity over complete security, with the assumption that campaigns are comfortable with non-TransparencyCorps users participating in the work.  

If for some reason a campaign is given an invalid task key, there won't be any harm done in sending this task key to TransparencyCorps when the task is complete; but, no one will be getting any points.

### Completing a Task

When a user completes a task on a campaign, that campaign should perform a POST to:

http://transparencycorps.org/tasks/complete

The only parameter to send is "task_key", with the value being the task_key that was originally given as a parameter when the user first created their task.

## Developing Locally

To set up this app to run locally:

* copy config/initializers/mailer.rb.example to config/initializers/mailer.rb and fill in your mailer settings
* copy config/database.yml.example to config/database.yml and fill in your database settings
* run "rake db:schema:load" to initialize the database
* run "rake db:fixtures:load" to get a starting admin user account, with username/password: user1/test