module Crudable
  extend ActiveSupport::Concern

  included do
    before_action :fetch_resource, only: [:edit, :update, :destroy]
  end

  def index
    @resources = resource_class.all
  end

  def new
    @resource = resource_class.new
  end

  def create
    @resource = resource_class.new(resource_params)

    if @resource.save
      redirect_to resources_path, flash: {notice: 'Successfully created ' + resource_class.to_s.titleize.downcase}
    else
      flash.now[:alert] = @resource.errors.full_messages.join(" ")
      render :new
    end
  end

  def edit
  end

  def update
    if @resource.update(resource_params)
      redirect_to resources_path, flash: {notice: 'Successfully updated ' + resource_class.to_s.titleize.downcase }
    else
      flash.now[:alert] = @resource.errors.full_messages.join(" ")
      render :edit
    end
  end

  def destroy
    if @resource.destroy
      redirect_to resources_path, flash: {notice: 'Successfully deleted ' + resource_class.to_s.titleize.downcase }
    else
      redirect_to resources_path, flash: {alert: @resource.errors.full_messages.join(" ") }
    end
  end

  private

  def fetch_resource
    @resource = resource_class.find(params[:id])
  end
end