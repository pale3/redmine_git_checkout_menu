Rails.application.routes.draw do
  get 'projects/:id/custom_repository_download', to: 'redmine_git_checkout_menu/repository#download', as: 'custom_repository_download'
end
