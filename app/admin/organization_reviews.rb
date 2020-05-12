# frozen_string_literal: true

ActiveAdmin.register Organization::Review, as: 'Review' do
  menu parent: 'Organizations'
  actions :all, except: %i[new edit update]
  filter :organization, collection: -> { Organization.order(:name) }

  scope :unpublished, default: true
  scope :published

  batch_action :destroy, false

  batch_action :toggle_published do |ids|
    reviews = Organization::Review.where(id: ids)
    # rubocop:disable Rails/SkipsModelValidations
    reviews.update_all('published = NOT published')
    # rubocop:enable Rails/SkipsModelValidations

    Sidekiq::Client.push_bulk(
      'class' => Organization::UpdateReviewStatisticsWorker,
      'args' => reviews.distinct.pluck(:organization_id).map { |id| [id] }
    )

    flash[:notice] = 'Toggled published state on selected reviews!'
    redirect_to collection_path
  end

  index do
    selectable_column
    id_column
    column :organization
    column :rating
    column :response_time
    column :recaptcha_score
    column :content
    column :created_at
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
