require 'rails_helper'

RSpec.describe Schedule, type: :model do

  it { is_expected.to validate_presence_of :day }
  it { is_expected.to validate_presence_of :opening }
  it { is_expected.to validate_presence_of :closing }
  it { is_expected.to validate_presence_of :restaurant }

  it {is_expected.to belong_to :restaurant}
end
