module Translation
  
  class RemoveDeprecatedStrings
    
    # takes all strings from TranslateStrings
    # if it doesn't find such string in file config/locales/lang_server.yml 
    # then the string is considered as deprecated and has to be removed from everywhere
    # 
    # TranslateStatistics table should be updated
    # TranslateTranslations should be cleaned
    # TranslateHistories should be cleaned
    # TranslateImprovements should be cleaned
    def self.run
      # get data from en.yml file
      file = File.expand_path("#{RAILS_HOME}/config/locales/templates/lang_server.yml")
      yml = File.exist?(file) ? YAML.load_file(file)["en"] : {}
      
      # get all translation strings
      deprecated_number = 0
      
      strings = TranslateString.find(:all)
      strings.each do |str| 
        # check if strings exists in yml file, if not then it is deprecated.
        if yml[str.prefix][str.suffix].to_s == ""
          # remove deprecated
          puts "deprecated - "+str.prefix+"."+str.suffix
          deprecated_number += 1
          RemoveDeprecatedStrings.remove_strings_and_rest(str)
          # remove translation and update statistics
        end
      end

      puts "--- Number of deprecated strings: "+deprecated_number.to_s

    end
    
    ###
     # Removes a translation strings and all translation associated
     ## 
    def self.remove_strings_and_rest(str)
      # go through each translation
      str.translations.each do |tr|
        status = tr.status
        lang = tr.lang
        
        # decrement stats
        if tr.improvement # if there is one
          TranslateStatistic.decrement(lang,"improvement")
        end
        TranslateStatistic.decrement(lang,status)
      end
      
      # destroy str and translation (remove on cascade histories and improvements)
      str.destroy
    end
    
  end

end

