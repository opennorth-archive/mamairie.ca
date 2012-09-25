require 'spec_helper'

describe Address do
  [:name, :address].each do |attribute|
    should validate_presence_of :attribute
  end
end
