class NotificationsController < ApplicationController


	def get_notifications

		user = User.find(params[:user_id])

		if user == nil
      respond_to do |format|
        format.json {render json: {info: "User not found", status: :not_found}.to_json}
      end
		else
			notifications = Notification.where(user: user).limit(20).offset(params[:offset])

			respond_to do |format|
				format.json {render json: {notifications: notifications, status: :ok}.to_json}
			end
		end
	end

	def set_viewed
		notification = Notification.find(params[:notification_id])

		notification.viewed = true

		if notification.save
	    respond_to do |format|
	      format.json {render json: {notification: notification, status: :ok}.to_json}
    	end
		else
      respond_to do |format|
        format.json  {render json: {notification: notification, status: :unprocessable_entity}.to_json}
      end
		end
	end	

	def set_accepted
		notification = Notification.find(params[:notification_id])

		notification.accepted = true

		if notification.save
	    respond_to do |format|
	      format.json {render json: {notification: notification, status: :ok}.to_json}
    	end
		else
      respond_to do |format|
        format.json  {render json: {notification: notification, status: :unprocessable_entity}.to_json}
      end
		end
	end	

end
