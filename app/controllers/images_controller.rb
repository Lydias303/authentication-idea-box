class ImagesController < ApplicationController

  def create
    Image.create(image_params)
    redirect_to admin_path
  end

  def destroy
    @image = Image.find(params[:id])
    @image.destroy
    redirect_to admin_path
  end

  def edit
    @images = Image.find(params[:id])
  end

  def update
    @image = Image.find(params[:id])
    @image.update(image_params)
    redirect_to admin_path
  end

  private

  def image_params
    params.require(:image).permit(:title, :img)
  end
end
