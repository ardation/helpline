# frozen_string_literal: true

ActiveAdmin.register Country::Subdivision, as: 'Subdivision' do
  menu parent: 'Countries'
  actions :all, except: %i[edit update]

  permit_params :code, :country_id

  index do
    selectable_column
    column :code
    column :name
    column :country
    column :created_at
    actions
  end

  filter :country
  filter :code

  form do |f|
    f.inputs do
      f.input :code, hint: 'ISO3166 country subdivision code'
      f.input :country
    end
    f.actions
  end
end
