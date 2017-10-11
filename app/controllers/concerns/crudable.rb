module Crudable
  extend ActiveSupport::Concern

  included do
    before_action :fetch_resource, only: [:edit, :update, :destroy]
  end

  def index
    @resources = self.class::RESOURCE_CLASS.all
  end

  def new
    @resource = self.class::RESOURCE_CLASS.new
  end

  def create
    @resource = self.class::RESOURCE_CLASS.new(resource_params)

    if @resource.save
      redirect_to resources_path, flash: {notice: 'Successfully created ' + self.class::RESOURCE_CLASS.to_s.titleize.downcase}
    else
      flash.now[:alert] = @resource.errors.full_messages.join("<br/>").html_safe
      render :new
    end
  end

  def edit
  end

  def update
    if @resource.update(resource_params)
      redirect_to resources_path, flash: {notice: 'Successfully updated ' + self.class::RESOURCE_CLASS.to_s.titleize.downcase }
    else
      flash.now[:alert] = @resource.errors.full_messages.join("<br/>").html_safe
      render :edit
    end
  end

  def destroy
    if @resource.destroy
      redirect_to resources_path, flash: {notice: 'Successfully deleted ' + self.class::RESOURCE_CLASS.to_s.titleize.downcase }
    else
      redirect_to resources_path, flash: {alert: @resource.errors.full_messages.join("<br/>").html_safe }
    end
  end

  private

  def fetch_resource
    @resource = self.class::RESOURCE_CLASS.find(params[:id])
  end
end