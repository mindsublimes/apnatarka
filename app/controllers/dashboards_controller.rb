class DashboardsController < ApplicationController
	before_action :find_user
	
	def index
		# order = @user.orders.where("created_at::date = ?", Date.today).where(order_status: "given_to_rider").first
		# rider = order.rider.where(order_status: "accept").first
		# if rider.present?
		# 	gon.pickup_time = rider.pickup_time.strftime("%I:%M")
		# 	gon.delivery_time = rider.delivery_time.strftime("%I:%M")
		# end
		@today_orders = @user.orders.where("created_at::date = ?", Date.today).order('created_at DESC')
		@user_mess = @user&.mess_request&.user_messes
		@country = "Pakistan"
		@states = CS.states(:PK)
		# remaining_time = @today_orders.last.time_diff(@today_orders.last.created_at, Time.now).split(":")
  		# gon.minutes = remaining_time[1]
  		# gon.seconds = remaining_time[2]
	end

	def update
		if @user.update(user_params)
			sign_in :user, @user, bypass: true
      flash[:success] = "Account Updated Successfully"
      redirect_to dashboards_path
    else
      flash[:alert] = "Something Went Wrong Please Try Again"
      redirect_to dashboards_path
    end
	end

	def update_profile
		@user.update_attribute(:avatar, params[:user][:avatar])
    redirect_to dashboards_path
	end

	def get_cities
    @cities = CS.cities(params[:state], :pk)
    render json: @cities
  end

  def today_mess_detail
  	mess_ids = @user&.mess_request&.user_messes&.map{|x| x.mess_item_id}
  	@today_mess = MessItem.where(id: mess_ids).where(day: Date.today.strftime("%A").downcase)
  	respond_to do |format|
      format.js
    end
  end

	private
		def find_user
			@user = current_user
		end

		def user_params
			params.require(:user).permit(:first_name, :email, :phone, :country, :state, :city, :address, :password, :password_confirmation)
		end
end