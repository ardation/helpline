# frozen_string_literal: true

ActiveAdmin.register Organization do
  permit_params :name, :country_code, :region, :category_list, :human_support_type_list, :issue_list,
                :phone_word, :phone_number, :sms_word, :sms_number, :chat_url, :url

  filter :name
  filter :country_code,
         as: :select,
         collection: ISO3166::Country.all.map { |c| [c.name, c.alpha2] }.sort { |a, b| a[0] <=> b[0] },
         label: 'Country'
  filter :categories, collection: Organization.category_counts.order(:name)
  filter :human_support_types, collection: Organization.human_support_type_counts.order(:name)
  filter :issues, collection: Organization.issue_counts.order(:name)

  index do
    selectable_column
    column :id, sortable: :slug do |organization|
      link_to organization.slug, organization_path(organization)
    end
    column :name
    column :country, sortable: :country_code do |organization|
      ISO3166::Country.all.find { |c| c.alpha2 == organization.country_code }&.name
    end
    column :region
    actions
  end

  show do
    attributes_table do
      row :name
      row :country do |organization|
        ISO3166::Country.all.find { |c| c.alpha2 == organization.country_code }&.name
      end
      row :phone_word
      row :phone_number
      row :sms_word
      row :sms_number
      row(:url) { |organization| link_to organization.url, organization.url, target: '_blank', rel: 'noopener' }
      row(:chat_url) do |organization|
        link_to organization.chat_url, organization.chat_url, target: '_blank', rel: 'noopener'
      end
      row :categories
      row :human_support_types
      row :issues
    end
  end

  form do |_f|
    semantic_errors
    columns do
      column do
        inputs 'Primary Details' do
          input :name
          input :country_code,
                as: :select,
                collection: ISO3166::Country.all.map { |c| [c.name, c.alpha2] },
                label: 'Country',
                input_html: { 'data-width' => '100%' }
          input :region
          input :category_list,
                as: :tags,
                collection: Organization.category_counts.order(:name).pluck(:name),
                input_html: { 'data-width' => '100%' }
          input :human_support_type_list,
                as: :tags,
                collection: Organization.human_support_type_counts.order(:name).pluck(:name),
                input_html: { 'data-width' => '100%' }
          input :issue_list,
                as: :tags,
                collection: Organization.issue_counts.order(:name).pluck(:name),
                input_html: { 'data-width' => '100%' }
        end
      end
      column do
        inputs 'Contact Details' do
          input :phone_word
          input :phone_number
          input :sms_word
          input :sms_number
          input :chat_url
          input :url
        end
      end
    end
    actions
  end

  controller do
    def find_resource
      scoped_collection.friendly.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      scoped_collection.find(params[:id])
    end
  end
end
