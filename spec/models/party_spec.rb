require 'spec_helper'

describe Party do
  [:name, :slug].each do |attribute|
    should validate_presence_of attribute
  end
end
