# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Organization::OpeningHour, type: :model do
  subject(:opening_hour) { create(:organization_opening_hour) }

  it { is_expected.to belong_to(:organization) }
  it { is_expected.to validate_presence_of(:close) }
  it { is_expected.to validate_presence_of(:open) }
  it { is_expected.to validate_presence_of(:day) }
  it { is_expected.to validate_uniqueness_of(:day).scoped_to(:organization_id).ignoring_case_sensitivity }

  it do
    expect(opening_hour).to define_enum_for(:day).with_values(
      monday: 1, tuesday: 2, wednesday: 3, thursday: 4, friday: 5, saturday: 6, sunday: 7
    )
  end

  describe '#open_before_close' do
    before do
      opening_hour.open = Time.current.end_of_day
      opening_hour.close = Time.current.beginning_of_day
    end

    it { is_expected.not_to be_valid }
  end
end
