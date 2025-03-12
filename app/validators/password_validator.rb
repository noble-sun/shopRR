class PasswordValidator < ActiveModel::Validator
  def validate(record)
    requirements = {
      /\A(?=.*\d)/ => :mandatory_digit,
      /\A(?=.*[a-z])/ => :mandatory_lowercase,
      /\A(?=.*[A-Z])/ => :mandatory_uppercase,
      /\A(?=.*[[:^alnum:]])/ => :mandatory_symbol
    }

    requirements.each do |regex, message|
      unless record.password.match?(regex)
        record.errors.add(:password, message)
      end
    end
  end
end
