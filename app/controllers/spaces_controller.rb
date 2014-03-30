class SpacesController < ApplicationController
  include CalendarHelpers

  def index
    @spaces = Space.scoped.where(active: 1)
    @spaces = @spaces.title(params[:title]) if params[:title].present?
    @spaces = @spaces.rate_less(params[:rate]) if params[:rate].present?
  end

  def new
    redirect_to root_path if !current_user
    @space = Space.new
    1.times{ @space.photos.build }
  end

  def create
    @use_ids = params[:space][:use_ids] ||= []
    @space = Space.new(space_params)
    @space.creator_id = current_user.id
    if @space.save
      insert_uses(@space.id, @use_ids)
      redirect_to space_path(@space.id)
#uncomment this later
      # redirect_to new_space_availability_path(@space)
#may need to look at the error messages being sent
    else
      flash[:notice] = "Space could not be saved! " + @space.errors.full_messages
    end
  end

  def show
    @space = Space.find(params[:id])
    @calendar_info = calendar_info(@space).to_json
    @publishable_key = @space.creator.publishable_key
  end

  def edit
    @space = Space.find(params[:id])
    redirect_to root_path and return unless current_user
    redirect_to user_path(current_user) unless current_user == @space.creator
  end

  def update
    @use_ids = params[:space][:use_ids] ||= []
    space = Space.find(params[:id])
    params[:space][:active] = 1
    if space.update(space_params)
      space.space_uses.clear
      insert_uses(space.id, @use_ids)
      redirect_to manage_path(current_user)
    else
      flash[:notice] = "Space could not be saved! " + @space.errors.full_messages
    end
  end

  def destroy
    space = Space.find(params[:id])
    space.availabilities.clear
    space.active = 0
    space.save
    redirect_to manage_path(current_user)
  end

  private

  def space_params
    params.require(:space).permit(:title, :description, :dimensions,
                                  :ammenities, :rate, :address,
                                  :city, :state, :zipcode, :email,
                                  :phone, :active, photos_attributes: [:space_id,
                                                                      :uploaded_photo,
                                                                      :title,
                                                                      :short_description])
  end

  def insert_uses(space_id, use_ids)
    @use_ids.each do |u|
      SpaceUse.create(space_id: space_id, use_id: u.to_i)
    end
  end

end
