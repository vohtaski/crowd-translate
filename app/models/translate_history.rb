# status can be reviewed, needs_review, untranslated or improvement
class TranslateHistory < ActiveRecord::Base
    belongs_to :translation, :class_name => "TranslateTranslation",:foreign_key => "translation_id"

    # sends back all reviewed translations by users
    def self.all_submittors
        # needs_review_user_ids = TranslateHistory.find(:all, 
        #     :conditions => "status = 'reviewed'",
        #     :select => "h.submitter_id, h.status, u.right, count(h.submitter_id) as number",
        #     :joins => "as h left join translate_users as u on h.submitter_id = u.user_id",
        #     :group => "status, submitter_id",
        #     :order => "submitter_id DESC")
        reviewed = TranslateTranslation.find(:all, 
            :conditions => "status = 'reviewed' or status = 'needs_review'",
            :select => "h.submitter_id, h.status, u.right, count(h.submitter_id) as number",
            :joins => "as h left join translate_users as u on h.submitter_id = u.user_id",
            :group => "status, submitter_id",
            :order => "submitter_id DESC")
            
    end
    
    # sends back histories of untranslated items for non-reviewers
    def self.users_needs_review
        needs_review_user_ids = TranslateHistory.find(:all, 
            :conditions => "(h.status = 'needs_review' or h.status = 'improvement')
                and u.right != 'reviewer' and u.right != 'admin'",
            :select => "h.submitter_id, h.lang, h.status, count(h.submitter_id) as number",
            :joins => "as h left join translate_users as u on h.submitter_id = u.user_id",
            :group => "lang, status, submitter_id",
            :order => "submitter_id DESC")
    end
    
    def self.gets_user_stats(user_id)
      TranslateHistory.find(:all, 
          :conditions => "(h.status = 'needs_review' or h.status = 'improvement') 
              and h.submitter_id = #{user_id}",
          :select => "h.lang, h.status, h.content, s.value",
          :joins => "as h inner join translate_strings as s on h.string_id = s.id")
    end
end
