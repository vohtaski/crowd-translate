module Translation
  
  class GenerateYml
    
    # takes translations from database and generates lang.yml files
    # langs (en.yml, ru.yml, etc.) are taken from TranslationScript.get_languages
    def self.run
      # go through all strings in db and build a structure to be dumped to en.yml file
      # {"en"=>{
      #     "words"=>{"english"=>"English", "russian"=>"Russian"}, 
      #     "date"=>{"january"=>"January", "february"=>"February"}}}

      # build the generic hash
      hash = GenerateYml.get_hash

      langs = Language.get_website_languages
      langs.each do |lang|
        output = {}

        # set data
        str_array = TranslateString.find(:all)
        str_array.each do |str|
          translation = TranslateTranslation.find(:first, 
              :conditions => "lang = '#{lang.first}' and string_id = #{str.id} 
                  and status = 'reviewed'")

          # if translation can't be found, use default english one from TranslateString
          if translation
            translation = translation.content
          else
            translation = str.value
          end

          if str.suffix.to_s != ""
            hash[str.prefix][str.suffix] = translation
          else
            hash[str.prefix] = translation
          end
        end

        output[lang.first] = hash
        # dump to file in locale
        file = File.expand_path("#{RAILS_HOME}/config/locales/#{lang.first}.yml")
        File.open(file, "w") {|f| f.write output.ya2yaml}
      end
    end
  
    def self.get_hash
      str_array = TranslateString.find(:all)
      yml_hash = {}
      str_array.each do |str|
        h = yml_hash[str.prefix] 
        if h
          yml_hash[str.prefix].merge!({str.suffix => ""})
        else
          yml_hash[str.prefix] = {str.suffix => ""}
        end
      end

      return yml_hash
    end
    
  end

end