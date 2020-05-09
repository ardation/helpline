# frozen_string_literal: true

ActiveAdmin.register Organization::Review, as: 'Review' do
  menu parent: 'Organizations'
  actions :all, except: %i[new edit update]
  filter :organization, collection: -> { Organization.order(:name) }

  scope :unpublished, default: true
  scope :published

  batch_action :destroy, false

  batch_action :toggle_published do |ids|
    # rubocop:disable Rails/SkipsModelValidations
    Organization::Review.where(id: ids).update_all('published = NOT published')
    # rubocop:enable Rails/SkipsModelValidations
    flash[:notice] = 'Toggled published state on selected reviews!'
    redirect_to collection_path
  end

  index do
    selectable_column
    column :organization
    column :rating
    column :response_time
    column :recaptcha_score
    column(:content) { |review| status_tag(review.content.present?) }
    actions
  end

  show do
    attributes_table do
      row :id
      row :organization
      row :content
      row :rating
      row :response_time
      row :recaptcha_score
    end
  end
end
