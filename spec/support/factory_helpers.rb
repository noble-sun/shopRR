module FactoryHelpers
  def self.generate_cpf
    cpf = rand(111111111..999999999).to_s
    self.generate_verification_digit(cpf:)
  end

  private

  def self.generate_verification_digit(cpf:)
    return cpf if cpf.length == 11

    remainder =
      cpf.reverse.split(//).map.with_index(2) do |char, index|
        char.to_i * index
      end.sum % 11

    verification_digit = 0
    unless remainder.equal?(0) || remainder.equal?(1)
      verification_digit = 11 - remainder
    end

    cpf += verification_digit.to_s

    generate_verification_digit(cpf:)
  end
end
