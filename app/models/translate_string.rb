class TranslateString < ActiveRecord::Base
    has_many :translations, :class_name => "TranslateTranslation", :foreign_key => "string_id",
        :dependent => :destroy
    
    # if string already exists, it will be returned
    # otherwise it will be created
    def self.add_string(prefix,suffix,value)
      t_s = TranslateString.find(:first, 
          :conditions => "prefix = '#{prefix}' and suffix = '#{suffix}'")
      if !t_s
        # string does not exist, create one
        t_s = TranslateString.create(:prefix => prefix, :suffix => suffix,
            :value => value, :is_new => true)
      end
      
      return t_s
    end
end
