class TranslateStatistic < ActiveRecord::Base
  # returns total sum of all strings for language
  def all
    return (self.untranslated + self.needs_review + self.reviewed)
  end
  
  def self.increment(lang,column)
    stat_line = TranslateStatistic.find(:first, :conditions => "lang = '#{lang}'")
    
    case column
    when 'untranslated'
      stat_line.untranslated += 1
    when 'reviewed'
      stat_line.reviewed += 1
    when 'needs_review'
      stat_line.needs_review += 1
    when 'improvement'
      stat_line.improvement += 1
    end
    
    stat_line.save
  end

  def self.decrement(lang,column)
    stat_line = TranslateStatistic.find(:first, :conditions => "lang = '#{lang}'")
    
    case column
    when 'untranslated'
      stat_line.untranslated -= 1
    when 'reviewed'
      stat_line.reviewed -= 1
    when 'needs_review'
      stat_line.needs_review -= 1
    when 'improvement'
      stat_line.improvement -= 1
    end
    
    stat_line.save
  end
  
  def self.get(lang)
    stats = TranslateStatistic.find(:first, :conditions => "lang = '#{lang}'")
  end

end
