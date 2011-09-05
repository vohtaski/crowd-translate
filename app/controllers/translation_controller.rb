class TranslationController < ApplicationController
    layout "translation"
    
    before_filter :login_required
    before_filter :guest_not_allowed, :except => [:list,:search]
    before_filter :is_translation_reviewer?, :only => [:review, :accept, :decline]
    before_filter :is_translation_admin?, :only => [:update_user]
    before_filter :not_translation_blocked?, :except => [:list]
    
    def index
        @langs = get_languages
        
          respond_to do |format|
            format.html
          end
        rescue Exception => err
          display_error(err)              
    end
    
  def list
      @filter = params[:filter]
      
      @selected_lang = params[:lang]
      @langs = get_languages
      @selected_lang_full = get_current_lang      
      
      @notification = TranslateNotification.get(@selected_lang,current_user.id)
      
      @stats = TranslateStatistic.get(@selected_lang)
      
      @translation_rows = TranslateTranslation.get_list(@filter,@selected_lang).paginate :page => params[:page], :per_page => 50
      
        respond_to do |format|
          format.html
        end
      rescue Exception => err
        display_error(err)      
  end
  
  def search
    @selected_lang = params[:lang]
    @langs = get_languages
    @selected_lang_full = get_current_lang
    
      @lang = params[:lang]
      @query = params[:search]
      
      @translation_rows = TranslateTranslation.search_results(@query,@lang).paginate :page => params[:page], :per_page => 50
      
        respond_to do |format|
          format.html
        end
      rescue Exception => err
        display_error(err)      
  end
  
  
  def stats    
    @langs = get_languages
        
    @data = TranslateStatistic.find(:all)
    @langs_hash = get_languages_hash
    
    @users_needs_review = TranslateHistory.users_needs_review
    
    @all_submittors = TranslateHistory.all_submittors
    
    respond_to do |format|
      format.html
    end
  rescue Exception => err
    display_error(err)      
  end

  def update_user    
    TranslateUser.update_user(params[:id], params[:right])
    
    respond_to do |format|
      format.json{render(:layout => false , :json => output.to_json)}
    end
  rescue Exception => err
    display_error(err)      
  end


  def user_stats 
    @langs = get_languages
    @user_id = params[:id]  
    @stats = TranslateHistory.gets_user_stats(@user_id)
        
    respond_to do |format|
      format.html
    end
  rescue Exception => err
    display_error(err)      
  end

  
  def toggle_notifications
      @lang = params[:lang]
      
      notification = TranslateNotification.get(@lang,current_user.id)
      notification.enabled = params[:enabled]
      notification.save
      
        respond_to do |format|
          format.json
        end
      rescue Exception => err
        display_error(err)      
  end
  

  def update
      # find new content and translation
      # remove html tags
      @new_content = params[:content].gsub(/<\/?[^>]*>/, "").strip
      
      @translation = TranslateTranslation.find(params[:id])
      # debugger
      if (params[:updated_at].to_time < @translation.updated_at.to_s(:db).to_time)
          # somebody updated this item before you, you do not know about this change
        @success = false
      else
          # everything is ok, no change conflicts
        @success = true
      end
      
      @status_before = @translation.status
      
      if @success == true #and @new_content != @translation.content.to_s
          @reviewed_improvement = false
          case @translation.status
          when 'untranslated'
              was_untranslated
          when 'needs_review'
              was_needs_review
          when 'reviewed'
              was_reviewed
          end
                    
          output = {:status_before => @status_before, 
              :status_after => @status_after, 
              :reviewed_improvement => @reviewed_improvement,
              :updated_at => @translation.updated_at.to_s(:db),
              :new_content => @new_content,
              :old_content => @old_content}
      else
          output = ""    
      end
      
      
      respond_to do |format|
          if @success
              format.json{render(:layout => false , :json => output.to_json)}
          else
            exception = "!!!Attention!!! \nNew translation was added for this element few seconds ago. \n\nPlease copy your change to clipboard, refresh the current page and paste your translation again."
            format.json{render(:layout => false , :json => {:exception => exception}.to_json)}
          end
      end
  rescue Exception => err
    display_error(err)      
  end

  # def vote
  #     @translation = TranslateTranslation.find(params[:id])
  #     
  #     if (params[:updated_at].to_time < @translation.updated_at.to_s(:db).to_time)
  #         # somebody updated this item before you, you do not know about this change
  #       @success = false
  #     else
  #         # everything is ok, no change conflicts
  #       @success = true        
  #     end
  #     
  #     
  #     respond_to do |format|
  #         if @success
  #             format.json{render(:layout => false , :json => output.to_json)}
  #         else
  #             exception = "!!!Attention!!! \nNew translation was added for this element few seconds ago. \n\nPlease refresh the current page and vote for this translation."
  #             format.json{render(:layout => false , :json => {:exception => exception}.to_json)}
  #         end
  #     end
  # rescue Exception => err
  #   display_error(err)      
  # end
  
  private
  
  def was_untranslated
      if current_user.is_translation_reviewer?
          # turn translation into reviewed
          update_translation('reviewed')
      else
          update_translation('needs_review')
      end
      # update statistics
      TranslateStatistic.increment(@translation.lang,@status_after)
      TranslateStatistic.decrement(@translation.lang,@status_before)
  end

  def was_needs_review
      if current_user.is_translation_reviewer?
          # turn translation into reviewed unless it's empty
          if @new_content == ""
              revert_translation
          else
              update_translation('reviewed')            
          end
      else
          # leave translation as needs_review
          update_translation('needs_review')
      end
      # update statistics
      TranslateStatistic.increment(@translation.lang,@status_after)
      TranslateStatistic.decrement(@translation.lang,@status_before)
  end

  def was_reviewed
    if current_user.is_translation_reviewer?
        # update translation and add history
        update_translation('reviewed')
        improvement = @translation.improvement
        if improvement
            improvement.delete
            # update statistics
            TranslateStatistic.decrement(@translation.lang,'improvement')
        end
    else
        # add a new translate_improvement
        improvement = @translation.improvement
        if !improvement
              improvement = TranslateImprovement.create!(:translation_id => @translation.id, 
                  :content => @new_content, :submitter_id => current_user.id)  
              TranslateStatistic.increment(@translation.lang,'improvement')              
        end
        improvement.update_attributes(:content => @new_content, :submitter_id => current_user.id)
        TranslateHistory.create!(:translation_id => @translation.id, :content => @new_content,
            :status => 'improvement', :lang => @translation.lang, 
            :string_id => @translation.string_id, :submitter_id => current_user.id)

        @old_content = @translation.content
        @reviewed_improvement = true
        @status_after = @translation.status
    end
  end

  def revert_translation
      @translation.update_attributes(:content => @new_content, :status => 'untranslated',:submitter_id => current_user.id)
      TranslateHistory.create!(:translation_id => @translation.id, :content => @new_content, 
          :status => 'untranslated', :lang => @translation.lang, 
          :string_id => @translation.string_id, :submitter_id => current_user.id)
      @status_after = @translation.status
  end
  

  def update_translation(status)
      @translation.update_attributes(:content => @new_content, :status => status,:submitter_id => current_user.id)
      TranslateHistory.create!(:translation_id => @translation.id, :content => @new_content, 
          :status => status, :lang => @translation.lang, 
          :string_id => @translation.string_id, :submitter_id => current_user.id)
          
      @status_after = @translation.status
  end
  
  def is_translation_reviewer?
    if !current_user.is_translation_reviewer?
        raise "You are not translation reviewer. Access denied!"
    end
  end

  def is_translation_admin?
    if !current_user.is_translation_admin?
        raise "You are not translation admin. Access denied!"
    end
  end

  def not_translation_blocked?
    if current_user.is_translation_blocked?
        raise "You are blocked from translation editing. Access denied!"
    end
  end
  
  def get_current_lang
    @langs.each do |lang|
        if lang.first == @selected_lang
            return lang.second
        end
    end
  end
  
  def get_languages
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
  
  def get_languages_hash
    langs = get_languages
    output = {}
    langs.each do |item|
      output[item.first] = item.second
    end
    return output
  end

end
