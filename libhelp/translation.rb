$:.unshift(File.dirname(__FILE__)) unless
$:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

require 'rubygems'
require 'yaml'
$KCODE = 'UTF8' 
require 'ya2yaml'

require 'translation/language'

require 'translation/google_translate'
require 'translation/update_english_strings'
require 'translation/generate_yml'
require 'translation/generate_js'
require 'translation/update_db'
