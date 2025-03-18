require 'rails_helper'

RSpec.describe 'Seller Products', type: :request do
  describe 'GET /index' do
    context 'list all products of the seller' do
      it 'successfully' do
        create(:product, name: 'Different Product', description: 'Product from different seller')
        seller = create(:user, role: :seller, email_address: 'seller@email.com', cpf: '34510967063')
        products = create_list(:product, 2, user: seller)


        post session_url, params: { login: seller.email_address, password: seller.password }
        get seller_products_path

        expect(response).to have_http_status(:success)
        expect(response.body).to include(products.first.name)
        expect(response.body).to include(products.second.name)
        expect(response.body).to include("#{seller.name} Products")
        expect(response.body).to_not include('Different Product')
      end
    end
  end

  describe 'GET /show' do
    context 'show seller product details' do
      it 'successfully' do
        seller = create(:user, role: :seller)
        product = create(:product, user: seller)

        post session_url, params: { login: seller.email_address, password: seller.password }
        get seller_product_path(product)

        expect(response).to have_http_status(:success)
        expect(response.body).to include(product.name)
        expect(response.body).to include(product.description)
        expect(response.body).to include("Edit this product")
      end
    end

    context 'when product is not from seller' do
      it 'return to seller product index' do
        seller  = create(:user, role: :seller, email_address: 'seller@email.com', cpf: '34510967063')
        product = create(:product)

        post session_url, params: { login: seller.email_address, password: seller.password }
        get seller_product_path(product)

        expect(response).to redirect_to(seller_products_path)
      end
    end
  end

  describe 'POST /create' do
    context 'create a new product for seller' do
      it 'successfully' do
        seller = create(:user, :seller)

        params = {
          product: {
            name: "First Seller Product",
            description: "Description first seller product",
            quantity: 10,
            price: 5,
            active: true,
            images: [
              fixture_file_upload(
                Rails.root.join("spec/support/images/dog.jpg"),
                'image/jpeg'
              )
            ]
          }
        }

        post session_url, params: { login: seller.email_address, password: seller.password }

        expect {
          post seller_products_path, params: params
        }.to change(Product, :count).by(1)
         .and change(ActiveStorage::Attachment, :count).by(1)

        product = Product.last
        expect(response).to have_http_status(:redirect)
        expect(response).to redirect_to(seller_product_path(product))
        expect(product.name).to eq("First Seller Product")

        follow_redirect!
        expect(response.body).to include("Product was successfully created.")
      end

      it 'return to new and do not create product on failure' do
        seller = create(:user, :seller)

        post session_url, params: { login: seller.email_address, password: seller.password }

        expect {
          post seller_products_path, params: { product: { quantity: 'ten' } }
        }.to_not change(Product, :count)

        expect(response).to have_http_status(:unprocessable_entity)
        expect(response).to render_template(:new)
        expect(response.body).to include("error prohibited this product from being saved")
      end
    end
  end

  describe 'PATCH /update' do
    context 'update seller product information' do
      it 'successfully' do
        seller = create(:user, role: :seller)
        product = create(:product, user: seller)

        post session_url, params: { login: seller.email_address, password: seller.password }
        patch seller_product_path(product), params: { product: { name: 'Updated Seller Product' } }

        expect(response).to redirect_to(seller_product_path(product))
        expect(product.reload.name).to eq('Updated Seller Product')
      end
    end

    context 'when product is not from seller' do
      it 'return to seller product index and not update product' do
        seller  = create(:user, role: :seller, email_address: 'seller@email.com', cpf: '34510967063')
        product = create(:product, user: seller)
        product = create(:product)

        post session_url, params: { login: seller.email_address, password: seller.password }
        patch seller_product_path(product), params: { product: { name: 'Updated Seller Product' } }

        expect(response).to redirect_to(seller_products_path)
        expect(product.reload.name).to_not eq('Updated Seller Product')
      end
    end
  end

  describe 'DELETE /destroy' do
    context 'delete a product from seller' do
      it 'successfully' do
        seller = create(:user, role: :seller)
        product = create(:product, user: seller)

        post session_url, params: { login: seller.email_address, password: seller.password }

        expect { delete seller_product_path(product) }.to change(Product, :count).by(-1)
        expect(response).to redirect_to(seller_products_path)
      end
    end

    context 'when product is not from seller' do
      it 'return to seller product index and not delete product' do
        seller  = create(:user, role: :seller, email_address: 'seller@email.com', cpf: '34510967063')
        product = create(:product, user: seller)
        product = create(:product)

        post session_url, params: { login: seller.email_address, password: seller.password }

        expect { delete seller_product_path(product) }.to_not change(Product, :count)
        expect(response).to redirect_to(seller_products_path)
      end
    end
  end
end
