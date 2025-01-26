class TravelsController < ApplicationController
  include UserScopedResources

  before_action :set_travel, only: %i[show edit update destroy]
  before_action :authenticate_user!
    before_action lambda {
    resize_before_save(travel_params[:images], 300, 300)
  }, only: %i[update create]

  def index
    @travels = user_scoped(Travel)
  end

  def show
  end

  def new
    @travel = Travel.new
  end

  def edit
  end

  def create
    @travel = Travel.new(travel_params.except(:images).merge(user: current_user))

    respond_to do |format|
      if @travel.save
        attach_images(@travel)
        format.html { redirect_to @travel, notice: "#{@travel.name} was successfully created." }
        format.json { render :show, status: :created, location: @travel }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @travel.errors, status: :unprocessable_entity }
      end
    end
  end
  def update
    respond_to do |format|
      if @travel.update(travel_params.except(:images))
        attach_images(@travel)
        format.html { redirect_to @travel, notice: "#{@travel.name} was successfully updated." }
        format.json { render :show, status: :ok, location: @travel }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @travel.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @travel.destroy!

    respond_to do |format|
      format.html { redirect_to travels_path, status: :see_other, notice: "#{@travel.name} was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  def set_travel
    @travel = user_scoped(Travel).find(params[:id])
  end

  def travel_params
    params.require(:travel).permit(:name, :start_date, :end_date, :favorite, images: [])
  end

  def attach_images(travel)
    if params[:travel][:images].present?
      params[:travel][:images].each do |image|
        travel.images.attach(image)
      end
    end
  end

  def resize_before_save(image_params, width, height)
    return unless image_params.present?
    image_params.each do |image_param|
      begin
      ImageProcessing::MiniMagick
        .source(image_param)
        .resize_to_fit(width, height)
        .call(destination: image_param.tempfile.path)
      rescue StandardError => e
        Rails.logger.error "Image resizing failed: #{e.message}"
      end
    end
  end
end
