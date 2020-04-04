# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Organization, type: :model do
  subject { build(:organization) }

  it { is_expected.to belong_to(:country).required }
  it { is_expected.to have_many(:opening_hours).dependent(:destroy) }
  it { is_expected.to have_many(:subdivision_connections).dependent(:destroy) }
  it { is_expected.to have_many(:subdivisions).through(:subdivision_connections) }
  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_presence_of(:timezone) }
  it { is_expected.to validate_uniqueness_of(:name).scoped_to(:country_id) }
  it { is_expected.to allow_values(nil, '', 'http://foo.com', 'http://bar.com').for(:url) }
  it { is_expected.not_to allow_values('foo', 'buz').for(:url) }
  it { is_expected.to allow_values(nil, '', 'http://foo.com', 'http://bar.com').for(:chat_url) }
  it { is_expected.not_to allow_values('foo', 'buz').for(:chat_url) }
  it { is_expected.to allow_values(*ActiveSupport::TimeZone.all.map(&:name)).for(:timezone) }
  it { is_expected.not_to allow_values('test', 'place').for(:timezone) }
  it { is_expected.to accept_nested_attributes_for(:opening_hours).allow_destroy(true) }
end
