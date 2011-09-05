class InitTranslations < ActiveRecord::Migration
  def self.up
    # initializes statistics for every language
    InitTranslations.populate
    
    # sets initial admins and reviewers
    TranslateUser.create(:user_id => 3, :right => "admin") #change id to your user
    TranslateUser.create(:user_id => 5, :right => "reviewer")
    TranslateUser.create(:user_id => 19, :right => "reviewer")
  end

  def self.down
    
  end
  
  def self.populate
    langs = InitTranslations.get_languages
    langs.each do |lang|
      TranslateStatistic.create(:lang => lang.first)
    end
  end

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
end
