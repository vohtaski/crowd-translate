###################################################################################################
# ==========================
# = translation            =
# ==========================
map.with_options(:controller => 'translation', :conditions => {:method => :get}) do |m|
  m.translation_index               '/translation',                           :action => 'index'  
  m.translation_search               '/translation/search/:lang',                           :action => 'search'  
  m.translation_list               '/translation/:lang/:filter',                :action => 'list'  
  m.translation_stats             '/translation/stats',                :action => 'stats'  
  m.translation_user             '/translation_user/:id',                :action => 'user_stats'  
end
map.with_options(:controller => 'translation', :conditions => {:method => :put}) do |m|
  m.update_translation              '/translation/update/:id',                :action => 'update'  
  m.toggle_notifications              '/translation/toggle_notifications',      :action => 'toggle_notifications'  
  m.update_user              '/translation/update_user/:id/:right',      :action => 'update_user'  
end

###################################################################################################
