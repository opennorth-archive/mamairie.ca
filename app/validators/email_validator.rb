# http://my.rails-royce.org/2010/07/21/email-validation-in-ruby-on-rails-without-regexp/
class EmailValidator < ActiveModel::EachValidator
  # Domain must be present and have two or more parts.
  def validate_each(record, attribute, value)
    address = Mail::Address.new value
    record.errors[attribute] << (options[:message] || 'is invalid') unless (address.address == value && address.domain && address.__send__(:tree).domain.dot_atom_text.elements.size > 1 rescue false)
  end
end
