# ==========================
# = Translate Admins
# ========================  
has_one :translate_user
def is_translation_reviewer?
    # return true
    user = self.translate_user
    if (user and (user.right == "admin" or user.right == "reviewer"))
      return true
    else
      return false
    end
end

def is_translation_admin?
    # return true
    user = self.translate_user
    if (user and user.right == "admin")
      return true
    else
      return false
    end
end

def is_translation_blocked?
    # return true
    user = self.translate_user
    if (user and user.right == "blocked")
      return true
    else
      return false
    end
end
