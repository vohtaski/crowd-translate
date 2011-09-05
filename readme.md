Crowd translation
=================
This is to add collaborative language translation functionality to your site!
If you use several languages, you can ask your users to help you to translate
your web application into other languages. This service helps you to manage the
process. Read more at this blog: http://vohtaski.blogspot.com

How to integrate
===============
It works with Rails 2.3.9. Was not tested with Rails 3.0

General
-------
You have to copy files from this project into your application.
All the manual changes are described below.

Database schema
---------
Add migration files from db/migrate to db/migrate in your project. 
Change the migration number to the newest version for your rails project and run it.

1. create_translations.rb
2. init_translations.rb - change this file to add admins (important!) and reviewers for your site

Controller files
-------------------------
Implement (if not done) the next two functions in translation_controller.rb

    before_filter :login_required
    before_filter :guest_not_allowed, :except => [:list,:search]

Model files
------
1. You have to have User model that manages people
2. Add content of misc/to_user.rb into user.rb

Route.rb file
------
Add new routes from misc/to_routes.rb

Install required gems
---------------------
1. Install gem will_paginate
2. Add require "will_paginate" into config/environment.rb 

Add language files to db locally
--------------------------------
* Change default owner for language strings in file libhelp/translation/update_db.rb
look for line "submitter_id = 4". Change id to your admin id.

* $ script/translation/update\_db - will create db entries based on lang\_server.yml

* On the server deploy script manage(deploy/production.rb) will do all this.
See as well file script/translation/ondeploy


Start the site
--------
After your rails project is started,
you should find translation service at http://yoursite/translation.

See further two sections on tuning up the things.

Settings
========
Languages settings
------------------
You can specify languages that your site uses
in language.rb function self.get\_website\_languages.

These languages are used for language files generation.
If your site uses german, english and french for example, you should specify
only those languages.

Google translate
----------------
You have to get the key from google translate and change line

    key = "yourkey" 
    
in google_translate.rb file, if you plan to use auto translation
for language strings.

"Yoursite" and "yoursite" change
===============
Replace everywhere string "Yoursite"/"yoursite" with actual site name/domain name you are using.


Misc integration
================
Not necessary but might be useful

Email notification
------------------
Add new email sending function from misc/to\_user\_notifier.rb into user\_notifier.rb

Deployment scripts
--------------
If you want to add deploy scripts to populate translation databases
and generate language files, a (config/deploy/production.rb)
misc/to\_deploy\_production.rb. See libhelp/readme.md for details.

Language files
==============
All language files for english are saved in config/locales/templates/lang\_server.yml.
This file is used to generate entries in database translation table. Once
string are translated into different languages, this file is used to generate
language yml files. File lang\_client.yml is used to generate javascript files
for the client. See libhelp/translation/generate\_js.rb for details.

Licence
=======
MIT


