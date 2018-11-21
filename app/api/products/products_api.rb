module Products
	class ProductsAPI < Grape::API

		format :json

		desc "Product List", {
			:notes => <<-NOTE
			Get All Products
			__________________
			NOTE
		} 

		get do 
			Product.all
		end

		desc "Product By Id", {
			:notes => <<-NOTE
			Get Product By Id
			___________________
			NOTE
		}

		params do 
			requires :id, type: Integer, desc: "Product id"
		end

		get ':id' do
			begin
				product = Product.find(params[:id])
			rescue ActiveRecord::RecordNotFound
				error!({ status: :not_found}, 404)
			end
		end

		desc "Delete Product By Id", {
			:notes => <<-NOTE
			Delete Product by id
			____________________
			NOTE
		}

		params do 
			requires :id, type: Integer, desc: "Product id"
		end

		delete ':id' do
			begin
				product = Product.find(params[:id])
				{ status: :success} if product.delete
			rescue ActiveRecord::RecordNotFound
				error!({ status: :error, message: :not_found}, 404)
			end
		end

		desc "Update Product By Id", {
			:notes => <<-NOTE
			Update Product by id
			__________________________
			NOTE
		}

		params do 
			requires :id, type: Integer, desc: "Product id"
			requires :name, type: String, desc: "Product Name"
			requires :price, type: BigDecimal, desc: "Product Price"
			optional :old_price, type: BigDecimal, desc: "Product Old Price"
			requires :short_description, type: String, desc: "Product Short Description"
			optional :full_description, type: String, desc: "Product Full Description"
		end

		put ':id' do
			begin
				product = Product.find(params[:id])
				if product.update({
					name: params[:name],
					price: params[:price],
					old_price: params[:old_price],
					short_description: params[:short_description] 
				})
					{status: :success}
				else
					error!({status: :error, message: :product.errors.full_messages.first}) if product.errors.any?
				end
			rescue ActiveRecord::RecordNotFound
				error!({ status: :error, message: :not_found},404) 
			end
		end

		desc "Create Product", {
			:notes => <<-NOTE
			Create Product
			__________________________
			NOTE
		}

		params do 
			requires :name, type: String, desc: "Product Name"
			requires :price, type: BigDecimal, desc: "Product Price"
			optional :old_price, type: BigDecimal, desc: "Product Old Price"
			requires :short_description, type: String, desc: "Product Short Description"
		end

		post do 
			begin
				product = Product.create({
					name: params[:name],
					price: params[:price],
					old_price: params[:old_price],
					short_description: params[:short_description],
				})
				if product.save 
					{status: :success}
				else
					error!({status: :error, message: product.errors.full_messages.frist}) if product.errors.any?
				end
			rescue ActiveRecord::RecordNotFound 
				error!({status: :error, message: :not_found},404)
			end
		end
	end

end