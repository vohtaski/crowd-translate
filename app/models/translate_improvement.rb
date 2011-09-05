class TranslateImprovement < ActiveRecord::Base
    belongs_to :translation, :class_name => "TranslatTranslation", :foreign_key => "translation_id"
    belongs_to :submitter, :class_name => "User", :foreign_key => "submitter_id"
end
