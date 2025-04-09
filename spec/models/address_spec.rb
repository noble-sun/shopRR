require 'rails_helper'

RSpec.describe Address, type: :model do
  context 'validations' do
    context 'should be valid' do
      it 'when all attributes are present' do
        address = build(:address, user: create(:user))
        expect(address).to be_valid
      end
    end

    context 'should not be valid' do
      context 'when street is not present' do
        it 'return false' do
          address = build(:address, user: create(:user), street: nil)
          expect(address).to be_invalid
        end
      end

      context 'when number is not present' do
        it 'return false' do
          address = build(:address, user: create(:user), number: nil)
          expect(address).to be_invalid
        end
      end

      context 'when neighborhood is not present' do
        it 'return false' do
          address = build(:address, user: create(:user), neighborhood: nil)
          expect(address).to be_invalid
        end
      end

      context 'when city is not present' do
        it 'return false' do
          address = build(:address, user: create(:user), city: nil)
          expect(address).to be_invalid
        end
      end

      context 'when state is not present' do
        it 'return false' do
          address = build(:address, user: create(:user), state: nil)
          expect(address).to be_invalid
        end
      end

      context 'when zipcode is not present' do
        it 'return false' do
          address = build(:address, user: create(:user), zipcode: nil)
          expect(address).to be_invalid
        end
      end

      context 'when country is not present' do
        it 'return false' do
          address = build(:address, user: create(:user), country: nil)
          expect(address).to be_invalid
        end
      end
    end
  end

  describe 'before_save' do
    context 'set_primary_address_uniqueness_per_user' do
      context 'when creating a new address' do
        context 'when there is another address for the user set as primary' do
          context 'when new address is set as primary' do
            it 'updates the other address as non-primary' do
              user = create(:user)
              old_primary_address = create(:address, user:, primary_address: true)
              new_address = build(:address, user:, primary_address: true)

              new_address.save

              expect(new_address.primary_address).to be_truthy
              expect(old_primary_address.reload.primary_address).to be_falsy
            end
          end

          context 'when new address is set as non-primary' do
            it 'do not update the other address' do
              user = create(:user)
              primary_address = create(:address, user:, primary_address: true)
              new_address = build(:address, user:, primary_address: false)

              new_address.save

              expect(new_address.primary_address).to be_falsy
              expect(primary_address.reload.primary_address).to be_truthy
            end
          end
        end

        context 'when there is another address set as primary for another user' do
          context 'when new address is set as primary' do
            it 'does not update address of another user' do
              different_user = create(:user)
              different_user_address = create(:address, user: different_user, primary_address: true)
              user = create(:user)
              new_address = build(:address, user:, primary_address: true)

              new_address.save

              expect(new_address.primary_address).to be_truthy
              expect(different_user_address.primary_address).to be_truthy
            end
          end
        end
      end

      context 'when updating an address' do
        context 'when there is another address for the user set as primary' do
          context 'when updated address is set as primary' do
            it 'updates the other address as non-primary' do
              user = create(:user)
              primary_address = create(:address, user:, primary_address: true)
              address = create(:address, user:, primary_address: false)

              address.update(primary_address: true)

              expect(address.primary_address).to be_truthy
              expect(primary_address.reload.primary_address).to be_falsy
            end
          end

          context 'when updated address is set as non-primary' do
            it 'do not update the other address' do
              user = create(:user)
              primary_address = create(:address, user:, primary_address: true)
              address = create(:address, user:, primary_address: false)

              address.update(primary_address: false, street: "New Street")

              expect(address.primary_address).to be_falsy
              expect(primary_address.reload.primary_address).to be_truthy
            end
          end
        end

        context 'when there is another address set as primary for another user' do
          context 'when updated address is set as primary' do
            it 'does not update address of another user' do
              different_user = create(:user)
              different_user_address = create(:address, user: different_user, primary_address: true)
              user = create(:user)
              new_address = create(:address, user:, primary_address: false)

              new_address.update(primary_address: true)

              expect(new_address.primary_address).to be_truthy
              expect(different_user_address.primary_address).to be_truthy
            end
          end
        end
      end
    end
  end
end
