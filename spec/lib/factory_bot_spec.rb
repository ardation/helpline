# frozen_string_literal: true

RSpec.describe FactoryBot do
  it 'lints factories successfully' do
    described_class.lint
  end
end
