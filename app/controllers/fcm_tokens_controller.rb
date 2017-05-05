class FcmTokensController < ApplicationController

  def set_token

    token_fcm = FcmToken.where(user_id:current_user.id)

    if token_fcm.any?
      token_fcm.first.token = params[:fcm_token]

      respond_to do |format|
        if token_fcm.first.save
          format.json {render json: {info: "ok", status: :not_found}.to_json}
        else
          format.json {render json: {info: "not", status: :unprocessable_entity}.to_json}
        end
      end
    else
      fcm_token = FcmToken.new()
      fcm_token.token = params[:fcm_token]
      fcm_token.user_id = current_user.id
      
      respond_to do |format|
        if fcm_token.save
          format.json {render json: {info: "ok", status: :not_found}.to_json}
        else
          format.json {render json: {info: "not", status: :unprocessable_entity}.to_json}
        end
      end
    end
    
  end

end
