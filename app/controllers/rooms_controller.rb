class RoomsController < ApplicationController
  skip_before_action :verify_authenticity_token if Rails.env.test?
  before_action :authenticate_member

  def index
    @rooms = Room.all
  end

  def new
    @member = Member.find(params[:member_id])
    @room = Room.new
    @room.owner = @member
  end

  def signup
    member = current_member
    room = Room.find(params[:id])

    if room.members.include?(member)
      flash[:notice] = "You are already registered in this room"
    else
      room.members << member
      member.rooms << room
    end

    redirect_to rooms_path
  end

  def show
    @room = Room.find(params[:id])
  end

  def edit
    @room = Room.find(params[:id])
  end

  def create

    @room = Room.new(room_params)
    @room.owner = current_member

    if @room.save
      redirect_to member_rooms_path(@room.owner)
    else
      flash[:alert] = "Sala não foi criada"
      redirect_to new_member_room_path(current_member.id)
    end
  end

  def update
    @room = Room.find(params[:id])

    if @room.update_attributes(room_params)
      redirect_to room_path
    else
      flash[:alert] = "Erro na atualização da sala"
      render 'edit'
    end
  end

  def destroy 
    @room = Room.find(params[:id])
    @room.destroy

    redirect_to member_rooms_path(current_member)    
  end

  private
    def room_params
      params.require(:room).permit(:name, :description, :member_id)
    end

end
