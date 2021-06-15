# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Category, type: :model do
  subject do
    described_class.new(
      category: 'test_category'
    )
  end

  it 'is valid with valid attributes' do
    expect(subject).to be_valid
  end

  it 'is not valid without valid attributes' do
    subject.category = nil
    expect(subject).to_not be_valid
  end
end
