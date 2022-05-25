require 'redmine'
require 'dispatcher' unless Rails::VERSION::MAJOR >= 3

Redmine::Plugin.register :redmine_custom_menu_urls do
  name 'Redmine Custom Menu URLs plugin'
  description 'A plugin to replace the help and projects top-menu item with one for which an admin can define the URL himself without touching the Redmine core.'
  url 'https://github.com/NBISweden/redmine_custom_menu_urls'
  author 'NBISweden'
  author_url 'https://github.com/NBISweden'
  version '0.0.3'
  
  settings :default => {:custom_help_url => '', :custom_projects_url => ''},
           :partial => 'settings/redmine_custom_menu_urls_settings'

  delete_menu_item :top_menu, :help
  menu :top_menu, :urdr, 'https://urdr.nbis.se'
end

if Rails::VERSION::MAJOR >= 3
  ActiveSupport::Reloader.to_prepare do
    require_dependency 'redmine_custom_menu_urls'
  end
else
  Dispatcher.to_prepare do
    require_dependency 'redmine_custom_menu_urls'
  end
end

# Workaround inability to access Setting.plugin_name['setting'], both directly as well as via overridden
# module containing the call to Setting.*, before completed plugin registration since we use a call to either:
# * Setting.plugin_redmine_custom_menu_urls['custom_help_url'] or (and replaced by)
# * RedmineCustomMenuUrls::Redmine::Info.help_url,
# which both can *only* be accessed *after* completed plugin registration (http://www.redmine.org/issues/7104)
#
# We now use overridden module RedmineCustomMenuUrl::Redmine::Info instead of directly calling 
# Setting.plugin_redmine_custom_menu_urls['custom_help_url']

Redmine::Plugin.find('redmine_custom_menu_urls').menu :top_menu, :help, RedmineCustomMenuUrls::Redmine::Info.help_url, :last => true
