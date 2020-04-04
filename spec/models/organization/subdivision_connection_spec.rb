# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Organization::SubdivisionConnection, type: :model do
  subject { build(:organization_subdivision_connection) }

  it { is_expected.to belong_to(:organization) }
  it { is_expected.to belong_to(:subdivision) }
  it { is_expected.to validate_uniqueness_of(:organization_id).scoped_to(:subdivision_id).case_insensitive }
end
