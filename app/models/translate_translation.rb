class TranslateTranslation < ActiveRecord::Base
    has_many :histories, :class_name => "TranslateHistory", :foreign_key => "translation_id",
        :dependent => :destroy
    belongs_to :string, :class_name => "TranslateString", :foreign_key => "string_id"
    belongs_to :submitter, :class_name => "User", :foreign_key => "submitter_id"
    has_one :improvement, :class_name => "TranslateImprovement", :foreign_key => "translation_id",
        :dependent => :destroy
    
    def self.get_list(status,lang)
      if (status != 'improvement') # normal things
        filter_clause = (status == 'all') ? "" : "and t.status = '"+status+"'"
        
        return TranslateTranslation.find(:all, #:conditions => "t.lang = '#{lang}'"+filter_clause,
            :joins => "as t inner join translate_strings as s on t.string_id = s.id and t.lang = '#{lang}'"+filter_clause,
            :select => "t.id as id, t.content as translation, t.status as status, s.value as term, 
                        t.votes as votes, t.updated_at as updated_at",
            :order => "t.id ASC")           
      else 
        # get improvements
        return TranslateTranslation.find(:all, #:conditions => "t.lang = '#{lang}'"+filter_clause,
            :joins => "as t inner join translate_strings as s on 
                t.string_id = s.id and t.lang = '#{lang}' and t.status = 'reviewed'"+
                " inner join translate_improvements as i on t.id = i.translation_id",
            :select => "t.id as id, t.content as translation, t.status as status, s.value as term, 
                        t.votes as votes, t.updated_at as updated_at",
            :order => "t.id ASC")           
        
      end 
    end

    # def self.get_needs_review(lang)
    #     rows = TranslateTranslation.find(:all, #:conditions => "t.lang = '#{lang}'"+filter_clause,
    #         :joins => "as t inner join translate_strings as e on t.string_id = e.id 
    #             and t.status = 'needs_review' and t.lang = '#{lang}'",
    #         :select => "t.id as id, t.content as translation, t.status as status, e.value as term, 
    #                     t.votes as votes, t.updated_at as updated_at",
    #         :order => "t.id ASC")            
    # end
    # 
    # def self.get_improvements(lang)
    #   rows = TranslateTranslation.find(:all, #:conditions => "t.lang = '#{lang}'"+filter_clause,
    #       :joins => "as t inner join translate_strings as e on t.string_id = e.id 
    #           and t.status = 'needs_review' and t.lang = '#{lang}'",
    #       :select => "t.id as id, t.content as translation, t.status as status, e.value as term, 
    #                   t.votes as votes, t.updated_at as updated_at",
    #       :order => "t.id ASC")            
    #   
    # end

    # Deprecated in favor of TranslateStatistic.get(lang)
    def self.get_stats(lang)
        untranslated = TranslateTranslation.find(:first, 
            :conditions => "lang = '#{lang}' and status = 'untranslated'",
            :select => "count(id) as number").number.to_i
            
        reviewed_array = TranslateTranslation.find(:all, 
            :conditions => "lang = '#{lang}' and status = 'reviewed'",
            :select => "id")
        reviewed = reviewed_array.size.to_i
        
        needs_review = TranslateTranslation.find(:first, 
            :conditions => "lang = '#{lang}' and status = 'needs_review'",
            :select => "count(id) as number").number.to_i
            
        reviewed_ids = reviewed_array.map { |item| "'"+item.id.to_s+"'" }.join(",")
        conditions = (reviewed_ids != "") ? "translation_id in (#{reviewed_ids})" : "translation_id = 0"
        improvement = TranslateImprovement.find(:first, 
            :conditions => conditions,
            :select => "count(id) as number").number.to_i
            
        all = untranslated + reviewed + needs_review
        return {:untranslated => untranslated, :reviewed => reviewed, 
            :needs_review => needs_review, :all => all, :improvement => improvement}
    end
    
    # looks through string.value and translation.content
    # item.name.to_s.downcase.include?(search_pattern.to_s.downcase)
    def self.search_results(query,lang)
      # default patterns for mysql
      # TODO: change to make search more robust to regexp and RLIKE 
        query = query.strip.gsub(/\s+/," ").gsub(" ","%")
        query = "%"+query+"%"
        return TranslateTranslation.find(:all, 
            :conditions => "t.content LIKE '#{query}' or s.value LIKE '#{query}'",
            :joins => "as t inner join translate_strings as s on t.string_id = s.id and t.lang = '#{lang}'",
            :select => "t.id as id, t.content as translation, t.status as status, s.value as term, 
                        t.votes as votes, t.updated_at as updated_at",
            :order => "t.id ASC")           
    end
    
    
end
