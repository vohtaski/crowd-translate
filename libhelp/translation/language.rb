module Translation
  class Language
    def self.get_languages
        [
        ["af","Afrikaans"],
        ["sq","Albanian"],
        ["ar","Arabic"],
        ["be","Belarusian"],
        ["bg","Bulgarian"],
        ["ca","Catalan"],
        ["zh","Chinese"],
        ["hr","Croatian"],
        ["cs","Czech"],
        ["da","Danish"],
        ["nl","Dutch"],
        ["en","English"],
        ["et","Estonian"],
        ["tl","Filipino"],
        ["fi","Finnish"],
        ["fr","French"],
        ["gl","Galician"],
        ["de","German"],
        ["el","Greek"],
        ["ht","Haitian Creole"],
        ["iw","Hebrew"],
        ["hi","Hindi"],
        ["hu","Hungarian"],
        ["is","Icelandic"],
        ["id","Indonesian"],
        ["ga","Irish"],
        ["it","Italian"],
        ["ja","Japanese"],
        ["lv","Latvian"],
        ["lt","Lithuanian"],
        ["mk","Macedonian"],
        ["ms","Malay"],
        ["mt","Maltese"],
        ["no","Norwegian"],
        ["fa","Persian"],
        ["pl","Polish"],
        ["pt","Portuguese"],
        ["ro","Romanian"],
        ["ru","Russian"],
        ["sr","Serbian"],
        ["sk","Slovak"],
        ["sl","Slovenian"],
        ["es","Spanish"],
        ["sw","Swahili"],
        ["sv","Swedish"],
        ["th","Thai"],
        ["tr","Turkish"],
        ["uk","Ukrainian"],
        ["vi","Vietnamese"],
        ["cy","Welsh"],
        ["yi","Yiddish"],     
        ]

    end

    def self.get_languages_hash
      langs = Language.get_languages
      output = {}
      langs.each do |item|
        output[item.first] = item.second
      end
      return output
    end
    
    # list of languages that are currently used in Yoursite
    def self.get_website_languages
        [
        # ["af","Afrikaans"],
        # ["sq","Albanian"],
        # ["ar","Arabic"],
        # ["be","Belarusian"],
        # ["bg","Bulgarian"],
        # ["ca","Catalan"],
        # ["zh","Chinese"],
        # ["hr","Croatian"],
        # ["cs","Czech"],
        # ["da","Danish"],
        # ["nl","Dutch"],
        ["en","English"],
        # ["et","Estonian"],
        # ["tl","Filipino"],
        # ["fi","Finnish"],
        ["fr","French"],
        # ["gl","Galician"],
        ["de","German"],
        # ["el","Greek"],
        # ["ht","Haitian Creole"],
        # ["iw","Hebrew"],
        # ["hi","Hindi"],
        # ["hu","Hungarian"],
        # ["is","Icelandic"],
        # ["id","Indonesian"],
        # ["ga","Irish"],
        # ["it","Italian"],
        # ["ja","Japanese"],
        # ["lv","Latvian"],
        # ["lt","Lithuanian"],
        # ["mk","Macedonian"],
        # ["ms","Malay"],
        # ["mt","Maltese"],
        # ["no","Norwegian"],
        # ["fa","Persian"],
        # ["pl","Polish"],
        # ["pt","Portuguese"],
        # ["ro","Romanian"],
        ["ru","Russian"],
        # ["sr","Serbian"],
        # ["sk","Slovak"],
        # ["sl","Slovenian"],
        # ["es","Spanish"],
        # ["sw","Swahili"],
        # ["sv","Swedish"],
        # ["th","Thai"],
        # ["tr","Turkish"],
        # ["uk","Ukrainian"],
        # ["vi","Vietnamese"],
        # ["cy","Welsh"],
        # ["yi","Yiddish"],     
        ]

    end
    

  end
  
end