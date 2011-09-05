LibHelp
=======
lib help contains the code that is not part of rails
but rather some helpful code that is run from time to time:
translation scripts, files creation, etc.

Translation scripts
=======

Howto
-----
lang_server.yml (config/locales/templates/lang_server.yml) contains all english strings
lang_client.yml (config/locales/templates/lang_client.yml) contains english strings for client

generate script generates 

* js language files for client based on lang_client.yml
* js language files for node-server based on lang_server.yml
* yml language files for rails-server are based on lang_server.yml


Main scripts
----------------
* update_db - takes language strings from lang_server.yml and adds new lines to database (both TranslateStrings and TranslateTranslations) (see for more the script description)
* generate_yml - takes translations from database and generates (en,ru,fr,...).yml files
* generate_js - generates js language files from yml files:
  - for node-server based on lang_server.yml
  - for client based on lang_client.yml
* google_translate - tries to update the untranslated strings with automatic google translations to help manual translators

* generate_local - generates en.yml and en.js based on lang_server.yml

Helper scripts
--------------------
* set_statistics - Builds TranslateStatistics table from scratch and sets all statistics to zero
* populate_translations - takes files (ru.yml, fr.yml) with existing translations from

Manual
======

