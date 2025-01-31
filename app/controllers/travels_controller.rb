class TravelsController < ApplicationController
  include UserScopedResources

  before_action :set_travel, only: [ :show, :edit, :update, :destroy, :upload_images ]
  before_action :authenticate_user!
  before_action lambda {
    resize_before_save(travel_params[:images], 300, 300)
  }, only: %i[create upload_images]

  def index
    @travels = if params[:scope] == "explore"
                 policy_scope(Travel.where.not(user: current_user))
    else
                 policy_scope(current_user.travels)
    end
    respond_to do |format|
      format.html
      format.turbo_stream
    end
  end

  def show
    authorize @travel
    @images = @travel.images.order(created_at: :desc)
  end

  def new
    @travel = Travel.new
    authorize @travel
  end

  def edit
    authorize @travel
  end

  def create
    @travel = Travel.new(travel_params.except(:images).merge(user: current_user))
    authorize @travel

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
    authorize @travel

    respond_to do |format|
      if @travel.update(travel_params)
        format.html { redirect_to @travel, notice: "#{@travel.name} was successfully updated." }
        format.json { render :show, status: :ok, location: @travel }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @travel.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    authorize @travel
    @travel.destroy!

    respond_to do |format|
      format.html do
        redirect_to travels_path, notice: "#{@travel.name} was successfully destroyed."
      end
      format.turbo_stream do
        @travels = policy_scope(Travel.where(user: current_user))
        render "travels/index"
      end
    end
  end

  def upload_images
    authorize @travel

    if params[:travel][:images].present?
      attach_images(@travel)
      @images = @travel.images.order(created_at: :desc)
      respond_to do |format|
        format.html { redirect_to @travel, notice: "Images were successfully uploaded." }
        format.turbo_stream
      end
    else
      redirect_to @travel, alert: "No images selected for upload."
    end
  end

  private

  def set_travel
    if %w[show edit update destroy upload_images].include?(action_name)
      @travel = Travel.find(params[:id])
    else
      @travel = user_scoped(Travel).find(params[:id])
    end
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
