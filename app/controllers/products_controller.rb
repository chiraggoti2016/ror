class ProductsController < ApplicationController
  # Get method to get all product form database
  def index
    @products = Product.all
  end

  def show
    @product = Product.find(params[:id])
  end

  def new
    @product = Product.new
  end

  def create
    @product = Product.new(product_params)
    if @product.save
      flash[:notice] = 'Product added!!'
      redirect_to root_path
    else
      flash[:error] = 'Fail to save product!'
      render :new
    end
  end

  def edit
    @product = Product.find(params[:id])
  end

  def update
    @product = Product.find(params[:id])
    if @product.update_attributes(product_params)
      flash[:notice] = 'Product updated!!'
      redirect_to root_path
    else
      flash[:error] = 'Fail to edit product!!'
      render :edit
    end
  end

  def destroy
    @product = Product.find(params[:id])
    if @product.delete 
      flash[:notice] = 'Product deleted!!'
      redirect_to root_path
    else
      flash[:error] = 'Fail to delete!!'
      render :destroy
    end
  end

  def product_params
    params.require(:product).permit(:name, :price, :old_price, :short_description, :full_description)
  end
end
