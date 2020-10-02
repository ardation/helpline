# frozen_string_literal: true

ActiveAdmin.register Influencer do
  permit_params :name, :slug, :message

  filter :name
  filter :slug

  index do
    selectable_column
    column :name
    column :slug
    actions
  end

  show do
    attributes_table do
      row :name
      row :slug
      row :message
    end
  end

  form do |f|
    f.semantic_errors
    f.inputs do
      f.input :name
      f.input :slug
      f.input :message
    end
    f.actions
  end
end
