# Deprecated deploy script for old rails
# 
# desc "Manage languages: generate new strings, create language files, etc."
# task :after_update_code, :roles => :app do 
#   
#   # add this line to the end of after_update_code
#   # generate language files {en,ru,..}.yml, {en,ru,..}.js
#   run "cd #{release_path}; script/translation/ondeploy production"
# end

# New script for newer version of rails
# 

desc "Manage languages: generate new strings, create language files, etc."
task :manage_languages, :roles => :app do   
  # generate language files {en,ru,..}.yml, {en,ru,..}.js
  run "cd #{release_path}; script/translation/ondeploy production"
end

# change if you want to do something else after deploy:update_code
after("deploy:update_code", "deploy:manage_languages")


# uses google translate to update the untranslated strings
desc "Translating language strings with google_translate"
task :google_translate, :roles => :web do
  desc "Apply google_translate to untranslated strings"
  
  path = current_path
  
  run "cd #{path}; script/translation/google_translate production"    
end