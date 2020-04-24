# frozen_string_literal: true

require 'sidekiq/web'

Rails.application.routes.draw do
  constraints subdomain: 'api' do
    post '/' => 'graphql#execute'
  end

  constraints subdomain: 'admin' do
    devise_for :users, ActiveAdmin::Devise.config
    ActiveAdmin.routes(self)

    authenticate :user do
      mount Sidekiq::Web => '/sidekiq'
    end
  end
end
