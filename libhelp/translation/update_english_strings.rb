module Translation
  
  class UpdateEnglishStrings
    
    # Goes through the english translations TranslateTranslation
    # finds related string in TranslateString 
    # replaces string.value with reviewed translation from TranslateTranslation
    def self.run
      # find all reviewed english translations
      translations = TranslateTranslation.find(:all,
          :conditions => "status = 'reviewed' and lang = 'en'",
          :include => :string)
      
      number = 0
      translations.each do |tr|
        str = tr.string
        if tr.content != str.value
          number += 1
          str.value = tr.content
          str.save
        end
      end
      
      puts "--- Updated english strings: "+number.to_s
    end
    
  end

end
