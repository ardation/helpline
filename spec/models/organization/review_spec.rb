# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Organization::Review, type: :model do
  subject(:review) { build(:organization_review) }

  it { is_expected.to belong_to(:organization) }
  it { is_expected.to validate_presence_of(:rating) }
  it { is_expected.to validate_numericality_of(:rating).is_greater_than_or_equal_to(0) }
  it { is_expected.to validate_numericality_of(:rating).is_less_than_or_equal_to(5) }
  it { is_expected.to validate_numericality_of(:rating).only_integer }
  it { is_expected.to validate_presence_of(:response_time) }
  it { is_expected.to validate_numericality_of(:response_time).is_greater_than_or_equal_to(0) }
  it { is_expected.to validate_numericality_of(:response_time).only_integer }
  it { is_expected.to validate_presence_of(:recaptcha_token).on(:create) }
  it { is_expected.to validate_presence_of(:remote_ip).on(:create) }

  describe '.published' do
    let!(:review) { create(:organization_review, published: true) }

    before { create(:organization_review) }

    it 'returns published reviews' do
      expect(described_class.published).to eq [review]
    end
  end

  describe '.unpublished' do
    let!(:review) { create(:organization_review) }

    before { create(:organization_review, published: true) }

    it 'returns unpublished reviews' do
      expect(described_class.unpublished).to eq [review]
    end
  end

  describe '#validate_recaptcha' do
    it 'sets recaptcha_score' do
      review.save
      expect(review.recaptcha_score).to eq 0.5
    end

    context 'when verify_recaptcha fails' do
      before do
        stub_request(
          :get,
          'https://www.recaptcha.net/recaptcha/api/siteverify'\
          "?remoteip=127.0.0.1&response=abc&secret=#{ENV['RECAPTCHA_SECRET_KEY']}"
        ).to_return(body: { success: false }.to_json)
      end

      it 'is not valid' do
        expect(review).not_to be_valid
      end

      it 'returns error message' do
        review.save
        expect(review.errors.messages[:base]).to eq ['reCAPTCHA verification failed, please try again.']
      end
    end
  end
end
