# frozen_string_literal: true

Rails.application.routes.draw do
  constraints subdomain: 'api' do
    post '/' => 'graphql#execute'
  end

  constraints subdomain: 'admin' do
    devise_for :users, ActiveAdmin::Devise.config
    ActiveAdmin.routes(self)
  end
end
