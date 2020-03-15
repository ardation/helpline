# frozen_string_literal: true

ActiveAdmin.register Organization do
  filter :categories
  filter :country_code
  filter :human_support_types
  filter :issues
  filter :name

  controller do
    def find_resource
      scoped_collection.friendly.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      scoped_collection.find(params[:id])
    end
  end
end
