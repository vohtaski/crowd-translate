# send a notification to the user that new untranslated lines appeared 
def new_translation_notification(user,lang_short,lang,number)
  # set locale into language of an item_owner, since the message will be sent to him
  setup_email(user)
  #generate a subject: New comment was added for
  subject      number.to_s+" untranslated strings added for "+lang+" language"
  
  body         :lang_short => lang_short, :user => user, :number => number, :lang => lang    
end

private
  def setup_email(user)
    recipients   "#{user.email}"
    from         $server_email
    sent_on      Time.now
    content_type "text/html"
    charset      "utf-8"
    headers      "Reply-to" => $server_email
  end