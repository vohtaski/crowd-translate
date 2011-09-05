module Translation
  
  class UpdateDb
    
    # takes file from config/locales/lang_server.yml and adds new lines to database
    # both TranslateStrings and TranslateTranslations
    # it also updates TranslateStatistics table with untranslated lines for all languages
    # for main English language it adds translations as reviewed to TranslateTranslations and
    # updates TranslateStatistics with reviewed
    def self.run
      # get data from en.yml file
      file = File.expand_path("#{RAILS_HOME}/config/locales/templates/lang_server.yml")
      strings = File.exist?(file) ? YAML.load_file(file)["en"] : {}

      # go through all strings and add new (those that are not db yet)
      # YAML.load_file(file)
      # {"en"=>{
      #     "words"=>{"english"=>"English", "russian"=>"Russian"}, 
      #     "date"=>{"january"=>"January", "february"=>"February"}}}
      new_lines_number = 0

      strings.each_pair do |prefix, lines|
        # prefix = "words", lines = {"english"=>"English", "russian"=>"Russian"}
        lines.each_pair do |suffix, translation|
          # suffix = "english"
          t_s = TranslateString.add_string(prefix,suffix,translation)
          if t_s.is_new == true
            # add lines to Translation table for every language
            UpdateDb.add_translation_lines(t_s,translation)
            new_lines_number += 1
          end
        end
      end

      puts "--- New translation strings: "+new_lines_number.to_s

      # Send notifications to users who wants to be notified
      langs_hash = Language.get_languages_hash
      notifications = TranslateNotification.find(:all, :conditions => "enabled = true")
      notifications.each do |notification|
        user = notification.user
        lang_short = notification.language
        lang = langs_hash[lang_short]
        # deliver email if new lines appear
        if new_lines_number > 0
          UserNotifier.deliver_new_translation_notification(user,lang_short,lang,new_lines_number)    
        end
      end
    end
    
    def self.add_translation_lines(str,en_translation)
      langs = Language.get_languages
      langs.each do |lang|
        # treat english language in a special way!!!
        content = ""
        status = "untranslated"
        submitter_id = nil
        if lang.first == "en"
          content = en_translation
          status = "reviewed"
          submitter_id = 3 # change to user.id of your translation admin
        end
        TranslateTranslation.create(:string_id => str.id, :lang => lang.first,
            :content => content, :status => status, :submitter_id => submitter_id)
        # update statistics table
        TranslateStatistic.increment(lang.first,status)

      end
      str.is_new = false
      str.save
    end
    
  end

end
