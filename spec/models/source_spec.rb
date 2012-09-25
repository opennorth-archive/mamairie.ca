require 'spec_helper'

describe Source do
  [:name, :last_modified].each do |attribute|
    should validate_presence_of :attribute
  end
end
