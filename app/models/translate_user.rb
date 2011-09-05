# right can be reviewer, admin, blocked
class TranslateUser < ActiveRecord::Base
    def self.update_user(user_id, right)
      
      user = TranslateUser.find(:first, 
          :conditions => "user_id = #{user_id}")
      
      if !user
        user = TranslateUser.create(:user_id => user_id, :right => right)
      else
        user.update_attributes :right => right
      end
      
    end
end
