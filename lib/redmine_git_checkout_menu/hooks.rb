# plugins/redmine_simple_repository_plugin/lib/redmine_simple_repository_plugin/hooks.rb
module RedmineGitCheckoutMenu
  class Hooks < Redmine::Hook::ViewListener
    render_on :view_repositories_show_contextual, partial: 'repository/repo_url'
    def view_layouts_base_html_head(context = {})
      stylesheet_link_tag('repository_url', plugin: 'redmine_git_checkout_menu')
    end
  end
end
