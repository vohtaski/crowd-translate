class TranslateNotification < ActiveRecord::Base
    belongs_to :user
    
    def self.get(lang,user_id)
        notification = TranslateNotification.find(:first, 
            :conditions => "language = '#{lang}' and user_id = #{user_id}")
        
        if !notification
            notification = TranslateNotification.create(:language => lang, 
                :user_id => user_id, :enabled => false)
        end
        
        return notification
    end
end
