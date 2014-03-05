class ReservationsController < ApplicationController
  def index
    @space = Space.find(params[:space_id])
    @reservations = @space.reservations
  end

  def create
    if params["payment_info"]["amount"].to_i > 0
      secret_key = get_secret_key(params["reservation_data"]["space_id"])
      response = make_payment(params["payment_info"], secret_key)

      if response.paid
        resp = create_reservations(params["reservation_data"])
        resp["payment"] = response
        resp["totalCharge"] = resp["payment"]["amount"]
        render json: resp.to_json

      else
        render json: {status: 'error', error: 'problem with charge'}.to_json
      end

    else
      reservation_info = create_reservations(params["reservation_data"])
      reservation_info[:total_price] = 0
      render json: reservation_info.to_json
    end
  end

  # def show
  # end

  def destroy
  end

  def confirmation
    @total_charge = "$" + (params["amount"].to_i / 100).to_s + ".00"

    reservation_ids = params["ids"].split(",").map(&:to_i)
    @reservations = []
    reservation_ids.each do |id|
      @reservations  << Reservation.find(id)
    end
    @reservations.sort! {|x,y| x.start_time <=> y.start_time}
    @space = @reservations.first.space

    # UserMailer.confirmation_email(current_user, @reservations, @total_charge).deliver

  end
end

def get_secret_key(space_id)
  Space.find(space_id).creator.secret_key
end

def make_payment(payment_info, payee_secret_key)
  token = payment_info["token_key"] # obtained with checkout.js
  amount = payment_info["amount"]
  description = payment_info["description"]
  Stripe.api_key = payee_secret_key

  # space = Space.find(payment_info["reservation_data"]["space_id"])
  # Stripe.api_key = space.creator.secret_key

  Stripe::Charge.create(
    :amount => amount,
    :currency => "usd",
    :card => token,
    :description => description
  )
end

def unavailable_timerange_check(reservation)
  reservation.space.availabilities.none? do |availability|
    reservation.start_time.between?(availability.start_time, availability.end_time) &&
    reservation.end_time.between?(availability.start_time, availability.end_time)
  end
end


