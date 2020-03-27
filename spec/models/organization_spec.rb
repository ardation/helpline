# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Organization, type: :model do
  subject { build(:organization) }

  it { is_expected.to have_many(:opening_hours).dependent(:destroy) }
  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_presence_of(:country_code) }
  it { is_expected.to validate_presence_of(:timezone) }
  it { is_expected.to validate_uniqueness_of(:name).scoped_to(:country_code) }
  it { is_expected.to validate_inclusion_of(:country_code).in_array(ISO3166::Country.all.map(&:alpha2)) }
  it { is_expected.to allow_values(nil, '', 'http://foo.com', 'http://bar.com').for(:url) }
  it { is_expected.not_to allow_values('foo', 'buz').for(:url) }
  it { is_expected.to allow_values(nil, '', 'http://foo.com', 'http://bar.com').for(:chat_url) }
  it { is_expected.not_to allow_values('foo', 'buz').for(:chat_url) }
  it { is_expected.to allow_values(*ActiveSupport::TimeZone.all.map(&:name)).for(:timezone) }
  it { is_expected.not_to allow_values('test', 'place').for(:timezone) }
  it { is_expected.to accept_nested_attributes_for(:opening_hours).allow_destroy(true) }
end
