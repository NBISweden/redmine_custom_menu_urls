require_dependency 'redmine/info'

# Create namespace module for override
module RedmineCustomMenuUrls
  # Make it work in development environment
  unloadable
  
  # TODO: needs a restart of Redmine after custom_menu_urls setting value change
  # Override core Redmine::Info.help_url, when
  # Setting.plugin_redmine_custom_menu_urls['custom_help_url'] contains
  # a value otherwise fall back to core Redmine::Info.help_url value
  module Redmine
    module Info
      class << self
        def projects_url
          begin
            if Setting.plugin_redmine_custom_menu_urls['custom_project_url'].blank?
              return "/projects"
            end
            return Setting.plugin_redmine_custom_menu_urls['custom_project_url']
          rescue
            return "/projects"
          end
        end

        def help_url
          begin
            if Setting.plugin_redmine_custom_menu_urls['custom_help_url'].blank?
              return 'http://www.redmine.org/guide'
            end
            return Setting.plugin_redmine_custom_menu_urls['custom_help_url']
          rescue
            return 'http://www.redmine.org/guide'
          end
        end
      end
    end
  end
end


# Now include the namespace module into Redmine::Info module
unless Redmine::Info.included_modules.include? RedmineCustomMenuUrls::Redmine::Info
    Redmine::Info.send(:include, RedmineCustomMenuUrls::Redmine::Info)
end
