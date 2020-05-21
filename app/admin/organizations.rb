# frozen_string_literal: true

ActiveAdmin.register Organization do
  permit_params :name, :country_id, :remote_id, :phone_word, :phone_number, :sms_word, :sms_number, :chat_url,
                :url, :notes, :timezone, :always_open, :featured, :verified,
                :category_list, :human_support_type_list, :topic_list,
                opening_hours_attributes: %i[id day open close _destroy], subdivision_ids: []

  filter :name
  filter :country

  menu priority: 1

  scope :all, default: true
  scope(:featured) { |scope| scope.filter_by_featured(true) }
  scope(:verified) { |scope| scope.filter_by_verified(true) }

  action_item :import_csv, only: :index do
    link_to 'Import from CSV', action: 'upload_csv'
  end

  collection_action :upload_csv do
    render 'admin/organizations/upload_csv'
  end

  collection_action :import_csv, method: :post do
    current_user.organization_imports.create(content: params[:csv][:file].read)
    flash[:notice] = 'CSV importing in background! Find A Helpline will email you when the import has been completed.'
    redirect_to action: :index
  end

  index do
    selectable_column
    column :id, sortable: :slug do |organization|
      link_to organization.slug.truncate(20), organization_path(organization)
    end
    column :name
    column :country
    column 'Remote ID', sortable: :remote_id do |organization|
      link_to organization.remote_id, organization_path(organization)
    end
    toggle_bool_column :featured
    toggle_bool_column :verified
    actions
  end

  show do
    attributes_table do
      row :name
      row :timezone
      row :country
      row :subdivisions
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
      row :topics
      row :notes
      row :always_open
      row 'Remote ID', &:remote_id
    end
  end

  sidebar :opening_hours, only: :show, if: -> { !organization.always_open } do
    table_for organization.opening_hours do
      column(:day) { |opening_hour| opening_hour.day.titleize }
      column(:open) { |opening_hour| opening_hour.open.strftime('%H:%M %p') }
      column(:close) { |opening_hour| opening_hour.close.strftime('%H:%M %p') }
    end
  end

  form do |f|
    semantic_errors
    columns do
      column do
        inputs 'Primary Details' do
          input :name
          input :timezone, as: :time_zone, input_html: { 'data-width' => '100%' }
          input :country, input_html: { 'data-width' => '100%' }
          input :subdivisions,
                input_html: { 'data-width' => '100%' },
                collection: option_groups_from_collection_for_select(
                  Country.all, :subdivisions, :name, :id, :name, f.object.subdivision_ids
                ),
                hint: "Subdivisions must be in organization's country"
          input :category_list,
                as: :tags,
                collection: Organization.category_counts.order(:name).pluck(:name),
                input_html: { 'data-width' => '100%' },
                label: 'Categories'
          input :human_support_type_list,
                as: :tags,
                collection: Organization.human_support_type_counts.order(:name).pluck(:name),
                input_html: { 'data-width' => '100%' },
                label: 'Human Support Types'
          input :topic_list,
                as: :tags,
                collection: Organization.topic_counts.order(:name).pluck(:name),
                input_html: { 'data-width' => '100%' },
                label: 'Topics'
          input :notes,
                input_html: { rows: 5 }
          input :always_open
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
          input :remote_id, label: 'Remote ID'
        end
      end
    end
    f.has_many :opening_hours, allow_destroy: true do |t|
      t.input :day, input_html: { 'data-width' => '100%' }
      t.input :open
      t.input :close
    end
    actions
  end

  after_build do |organization|
    if action_name == 'new'
      Organization::OpeningHour.days.each do |day, _index|
        organization.opening_hours.build(day: day, open: Time.current.beginning_of_day, close: Time.current.end_of_day)
      end
    end
  end

  controller do
    include ActionView::Helpers::TextHelper

    def find_resource
      scoped_collection.friendly.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      scoped_collection.find(params[:id])
    end
  end
end
