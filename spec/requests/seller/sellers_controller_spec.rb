require 'rails_helper'

RSpec.describe 'Sellers', type: :request do
  describe 'POST /enable' do
    context 'enable a user to become a seller' do
      it 'successfully' do
        user = create(:user)

        post session_url, params: { login: user.email_address, password: user.password }
        post seller_enable_path

        expect(user.reload.seller?).to be_truthy
        expect(response).to redirect_to(seller_products_path)

        follow_redirect!
        expect(response.body).to include("Parabéns! Agora você pode cadastrar seus produtos!")
      end

      it 'return to index page on failure' do
        user = create(:user)

        allow_any_instance_of(User).to receive(:seller!).and_raise(StandardError, "oops")
        allow(Rails.logger).to receive(:info)

        post session_url, params: { login: user.email_address, password: user.password }
        post seller_enable_path

        expect(user.reload.seller?).to be_falsy
        expect(response).to redirect_to(root_path)

        follow_redirect!
        expect(response.body).to include("Não foi possível habilitar a venda de produtos")
        expect(Rails.logger).to have_received(:info).with("oops")
      end
    end
  end
end
