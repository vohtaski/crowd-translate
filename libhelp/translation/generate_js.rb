module Translation
  
  class GenerateJs
    
    # Generates js language files from yml file - locales/en.yml
    #   - node-server based on locales/templates/lang_server.yml (locales/en.js)
    #   - client based on locales/templates/lang_client.yml (public/javascripts/langs/en.js)
    #
    # lang_client.yml file is used as a template. only those sentences that are
    # in this file will be added to (ru,en,...).js
    # 
    # Takes array of languages for which files should be generated
    def self.run(langs)
      langs = langs || []
      
      # client files generation
      source = "#{RAILS_HOME}/config/locales/"
      dest = "#{RAILS_HOME}/public/javascripts/langs/"
      template = "#{RAILS_HOME}/config/locales/templates/lang_client.yml"
      var_prefix = "var LocalizedStrings"
      GenerateJs.create_files(var_prefix,source,dest,template,langs)
      
      # node-server files generation
      source = "#{RAILS_HOME}/config/locales/"
      dest = source # files for node are saved together with rails files
      template = "#{RAILS_HOME}/config/locales/templates/lang_server.yml"
      var_prefix = "module.exports"
      GenerateJs.create_files(var_prefix,source,dest,template,langs)    
    end
    
    # Takes language files from source
    # filters out the strings not present in template
    # generate the resulting js output in dest folder
    # var_prefix is a variable to which language data will be assigned
    def self.create_files(var_prefix,source,dest,template,langs)
      js_file = File.expand_path(template)
      js_yml = File.exist?(js_file) ? YAML.load_file(js_file)['en'] : {}

      # build the generic hash
      langs.each do |lang|
        lang_file = File.expand_path(source+"#{lang.first}.yml")
        lang_yml = File.exist?(lang_file) ? YAML.load_file(lang_file)[lang.first] : {}

        file = File.expand_path(dest+"#{lang.first}.js")
        f = File.open(file, "w")

        f.puts var_prefix+" = {"

        js_yml.each_pair do |prefix, lines|
          # prefix = "words", lines = {"english"=>"English", "russian"=>"Russian"}
          if lines.nil? or (lines.instance_of? String)
            f.puts '"'+prefix+'":"'+lang_yml[prefix].gsub('"','\"')+'",'
          else
            lines.each_pair do |suffix, translation|
              # suffix = "english"
              f.puts '"'+prefix+"."+suffix+'":"'+lang_yml[prefix][suffix].gsub('"','\"')+'",'
            end
          end
        end

        f.puts "}"

        f.close
        # dump to file in locale
        # file = File.expand_path("#{RAILS_HOME}/config/locales/test/js/#{lang.first}.js")
        # File.open(file, "w") {|f| YAML.dump(output, f)}
      end
      
    end

  end

end