Redmine::Plugin.register :redmine_git_checkout_menu do
  name 'Redmine Simple Repository Plugin'
  author 'Marko Rakamaric'
  description 'This plugin gets/show the repository URL when on the repository tab'
  url "https://github.com/pale3/redmine_git_checkout_menu"
  version '1.1.0'
  requires_redmine version_or_higher: '6.0.0'
end

