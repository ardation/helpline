# frozen_string_literal: true

ActiveAdmin.register Country do
  permit_params :code, :emergency_number

  index do
    selectable_column
    column :code
    column :name
    column :emergency_number
    column :created_at
    actions
  end

  filter :code
  filter :emergency_number

  form do |f|
    f.inputs do
      f.input :code, hint: 'ISO3166 country code' if f.object.new_record?
      f.input :emergency_number
    end
    f.actions
  end
end
