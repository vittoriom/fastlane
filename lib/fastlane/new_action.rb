module Fastlane
  # Guides the new user through creating a new action
  module NewAction
    def self.run
      name = self.fetch_name
      self.generate_action(name)
    end

    def self.fetch_name
      puts "Must be lower case, and use a'_' between words. Do not use a '.'".green
      puts "examples: 'testflight', 'upload_to_s3'".green
      name = ask("Name of your action: ")
      while not name_valid?name
        puts "Name invalid!"
        name = ask("Name of your action: ")
      end
      name
    end

    def self.generate_action(name)
      template = File.read("#{Helper.gem_path}/lib/assets/custom_action_template.rb")
      template.gsub!('[[NAME]]', name)
      template.gsub!('[[NAME_UP]]', name.upcase)

      actions_path = File.join(FastlaneFolder.path, "actions")
      FileUtils.mkdir_p(actions_path) unless File.directory?actions_path

      path = File.join(actions_path, "#{name}.rb")
      File.write(path, template)
      Helper.log.info "Created new action file '#{path}'. Edit it to implement your custom action.".green
    end

    private
      def self.name_valid?(name)
        name == name.downcase and name.length > 0 and not name.include?"."
      end
  end
end