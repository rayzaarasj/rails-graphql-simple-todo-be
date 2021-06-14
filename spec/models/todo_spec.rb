require 'rails_helper'

RSpec.describe Todo, :type => :model do
  subject {
    described_class.new(
      title: "test_title",
      description: "test_description",
      deadline: DateTime.now + 1.day
    )
  }

  it 'is valid with valid attributes' do
    expect(subject).to be_valid
  end

  it 'is not valid without a title' do
    subject.title = nil
    expect(subject).to_not be_valid
  end

  it 'is not valid without a description' do
    subject.description = nil
    expect(subject).to_not be_valid
  end

  it 'is not valid without a deadline' do
    subject.deadline = nil
    expect(subject).to_not be_valid
  end
end