require 'rails_helper'

RSpec.describe 'ProductReviews', type: :request do
  describe 'POST /review' do
    context 'review a product' do
      context 'when a customer has an order with this product' do
        it 'sucessfully' do
          user = create(:user)
          address = create(:address, user:)
          product = create(:product)
          order = create(:order, address:, user:)
          cart = create(:cart, order:, user:)
          cart_item = create(:cart_item, cart:, product:)


          post session_url, params: { login: user.email_address, password: user.password }
          post product_product_reviews_path(product), params: { product_review: { score: 9 } }

          expect(response).to have_http_status(:redirect)
          expect(response).to redirect_to(product_path(product))
          expect(product.product_reviews.count).to eq(1)
          expect(product.product_reviews.last.score).to eq(9)

          follow_redirect!
          expect(response.body).to include("Obrigado pela avaliação!")
        end

        context 'wiht a comment' do
          it 'successfully' do
            user = create(:user)
            address = create(:address, user:)
            product = create(:product)
            order = create(:order, address:, user:)
            cart = create(:cart, order:, user:)
            cart_item = create(:cart_item, cart:, product:)

            params = {
              product_review: {
                score: 10,
                comments_attributes: [
                  { body: 'Best thing i ever bought!' }
                ]
              }
            }

            post session_url, params: { login: user.email_address, password: user.password }
            expect {
            post product_product_reviews_path(product), params: params
            }.to change(ProductReview, :count).by(1)
              .and change(Comment, :count).by(1)

            expect(response).to have_http_status(:redirect)
            expect(response).to redirect_to(product_path(product))
            expect(product.product_reviews.last.score).to eq(10)
            expect(product.product_reviews.last.comments.last.body).to eq("Best thing i ever bought!")

            follow_redirect!
            expect(response.body).to include("Obrigado pela avaliação!")
          end
        end

        context 'when score is not within range' do
          it 'return to product page when score is less than 1' do
            user = create(:user)
            address = create(:address, user:)
            product = create(:product)
            order = create(:order, address:, user:)
            cart = create(:cart, order:, user:)
            cart_item = create(:cart_item, cart:, product:)

            post session_url, params: { login: user.email_address, password: user.password }

            expect {
              post product_product_reviews_path(product), params: { product_review: { score: 0 } }
            }.to_not change(ProductReview, :count)

            expect(response).to have_http_status(:redirect)
            expect(response).to redirect_to(product_path(product))

            follow_redirect!
            expect(response.body).to include("A avaliação deve estar entre 1 e 10")
          end

          it 'return to product page when score is more than 10' do
            user = create(:user)
            address = create(:address, user:)
            product = create(:product)
            order = create(:order, address:, user:)
            cart = create(:cart, order:, user:)
            cart_item = create(:cart_item, cart:, product:)

            post session_url, params: { login: user.email_address, password: user.password }

            expect {
              post product_product_reviews_path(product), params: { product_review: { score: 11 } }
            }.to_not change(ProductReview, :count)

            expect(response).to have_http_status(:redirect)
            expect(response).to redirect_to(product_path(product))

            follow_redirect!
            expect(response.body).to include("A avaliação deve estar entre 1 e 10")
          end
        end
      end

      context 'when customer did not order the product' do
        it 'do not allow to review product' do
          user = create(:user)
          product = create(:product)

          post session_url, params: { login: user.email_address, password: user.password }

          expect {
            post product_product_reviews_path(product), params: { product_review: { score: 2 } }
          }.to_not change(ProductReview, :count)

          expect(response).to have_http_status(:redirect)
          expect(response).to redirect_to(product_path(product))

          follow_redirect!
          expect(response.body).to include("Não é possível avaliar um produto que não realizou o pedido")
        end
      end

      context 'when product does not exist' do
        it 'return to product index' do
          user = create(:user)

          post session_url, params: { login: user.email_address, password: user.password }

          post product_product_reviews_path(99), params: { product_review: { score: 2 } }

          expect(response).to have_http_status(:redirect)
          expect(response).to redirect_to(products_path)

          follow_redirect!
          expect(response.body).to include("Desculpe, não achamos o produto")
        end
      end
    end

    context 'when product is from seller' do
      it 'does not allow to review their own product' do
        seller = create(:user, :seller)
        product = create(:product, user: seller)

        post session_url, params: { login: seller.email_address, password: seller.password }

        post product_product_reviews_path(product), params: { product_review: { score: 10 } }

        expect(response).to have_http_status(:redirect)
        expect(response).to redirect_to(products_path)

        follow_redirect!
        expect(response.body).to include("Você não pode avaliar o seu próprio produto!")
      end
    end
  end
end
