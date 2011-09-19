require 'net/https'
require 'json'
require "uri"

module Translation
  
  class GoogleTranslate
    
    # tries to update the untranslated strings with
    # automatic google translations to help manual translators
    # Courtesy limit: 100,000 characters/day
    def self.run
      key = "yourkey"
      
      # go through all languages
      langs = GoogleTranslate.get_languages
      symbols_count = 100000
      # symbols_count = 100
      langs.each do |lang|
        translations = TranslateTranslation.find(:all, 
            :conditions => "content = '' and status = 'untranslated' and lang = '#{lang}'")
        translations.each do |tr|
          str = tr.string
          str_to_translate = str.value
          # remove the size of line to translate
          symbols_count -= str_to_translate.size
          exit if symbols_count < 0

          # google translate from en to lang
          str_translated = GoogleTranslate.get_from_google(str_to_translate,lang,key)
          str_translated = "..." if str_translated.to_s == ""
          str_translated = "" if str_translated.to_s == "error"
          
          puts lang+": to translate: "+str_to_translate
          puts lang+": translated: "+str_translated
          # update translation
          # replace buggy %_{ to _%{ and {Item} to item
          tr.content = str_translated.gsub("% {"," %{").gsub(/\{(\w+)\}/) {|s| "{"+$1.downcase+"}"}
          tr.save
        end
      end
    end
    
    def self.get_languages
        [
          # first priority
          # order of language for which to run translations
          "ru", "fr", "de", "nl", "it", "es", "zh", "ja", "pt", "ar", 
        
          "sq", "be",
          "bg",        "ca",                "hr",
          "cs",        "da",                
          "et",        "tl",        "fi",        
          "gl",               "el",        "ht",
          "iw",        "hi",        "hu",        "is",
          "id",        "ga",                
          "lv",        "lt",        "mk",        "ms",
          "mt",        "no",        "fa",        "pl",
                 "ro",                "sr",
          "sk",        "sl",                "sw",
          "sv",        "th",        "tr",        "uk",
          "vi",        "cy",        "yi",    "af", 
        ]

    end
  
    def self.get_from_google(query,lang,key)
      # API key for yoursite
      url = "https://www.googleapis.com/language/translate/v2?"
      # yoursite@gmail.com key
      url += "key="+key
      # evgeny.bogdanov@gmail.com key
      # url += "key=AIzaSyA7ajolerKUclMhekaTxDmfsY59zqTBb4Q"
      url += "&source=en&target=#{lang}"
      url += "&q="+CGI.escape(query)
    
      uri = URI.parse(url)
    
      http_session = Net::HTTP.new(uri.host, uri.port)
      http_session.use_ssl = true
      http_session.start do |http| 
        response = http.get(url)
        if(response.code != "200")
          puts "error"
          return "error"
        else
          return JSON.parse(response.body)["data"]["translations"][0]["translatedText"]            
        end
      end
    end
    
  end

end
