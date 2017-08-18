class ReservationsController < ApplicationController
  before_action :authenticate_user!

  def create
    room = Room.find(params[:room_id])

    if current_user == room.user
      falsh[:alert] = "You cannot book your own property!"
    else
      start_date = Date.parse(resercation_params[:start_date])
      end_date = Date.parse(resercation_params[:end_date])
      days = (end_date - start_date).to_i + 1

      @reservation = current_user.reservations.build(resercvation_params)
      @reservation.room = room
      #TODO Is it in need? I refer the price from room. Is it for when room price is changed ?
      @reservation.price = room.price
      @reservation.total = room.price * days
      @reservation.save

      flash[:notice] = "Booked Successfully!"
    end
    redirect_to room
  end

  private
  def reservations_params
    params.require(:reservation).permit(:start_date, :end_date)
  end
end