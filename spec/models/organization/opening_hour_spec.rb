# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Organization::OpeningHour, type: :model do
  subject(:opening_hour) { build(:organization_opening_hour) }

  it { is_expected.to belong_to(:organization) }
  it { is_expected.to validate_presence_of(:close) }
  it { is_expected.to validate_presence_of(:open) }
  it { is_expected.to allow_values(1, 2, 3, 4, 5, 6, 7).for(:day) }
  it { is_expected.not_to allow_values(0, 8).for(:day) }
  it { is_expected.to allow_values(*ActiveSupport::TimeZone.all.map(&:name)).for(:timezone) }
  it { is_expected.not_to allow_values('test', 'place').for(:timezone) }

  describe '#open_before_close' do
    before do
      opening_hour.open = Time.current.end_of_day
      opening_hour.close = Time.current.beginning_of_day
    end

    it { is_expected.not_to be_valid }
  end
end
