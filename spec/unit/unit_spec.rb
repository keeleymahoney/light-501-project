# location: spec/unit/unit_spec.rb
require 'rails_helper'

RSpec.describe Event, type: :model do
  subject do
    described_class.new(name: 'Meeting', location: 'Conference Room',
    date: DateTime.now,
    description: 'Team meeting')
    
  end

  it 'is valid with valid attributes' do
    expect(subject).to be_valid
  end

  # Name validation
  it 'is not valid without a name' do
    subject.name = nil
    expect(subject).not_to be_valid
  end

  # Location validation
  it 'is not valid without a location' do
    subject.location = nil
    expect(subject).not_to be_valid
  end

  # Date validation
  it 'is not valid without a date' do
    subject.date = nil
    expect(subject).not_to be_valid
  end

  # Description validation
  it 'is not valid without a description' do
    subject.description = nil
    expect(subject).not_to be_valid
  end


end