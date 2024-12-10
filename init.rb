Redmine::Plugin.register :redmine_git_checkout_menu do
  name 'Redmine Simple Repository Plugin'
  author 'Marko Rakamaric'
  description 'This plugin gets the repository URL when on the repository tab'
  version '1.1.0'
  requires_redmine version_or_higher: '6.0.0'
end

