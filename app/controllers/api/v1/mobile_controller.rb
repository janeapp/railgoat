# frozen_string_literal: true
class Api::V1::MobileController < ApplicationController
  skip_before_action :authenticated
  before_action :mobile_request?

  respond_to :json

  ALLOWED_MODELS = %w[User Post Comment].freeze

  def show
    if (model = allowed_model(params[:class]))
      respond_with model.find(params[:id]).to_json
    end
  end

  def index
    if (model = allowed_model(params[:class]))
      respond_with model.all.to_json
    else
      respond_with nil.to_json
    end
  end

  private

  def allowed_model(name)
    class_name = name.to_s.classify
    ALLOWED_MODELS.include?(class_name) ? class_name.constantize : nil
  end

  def mobile_request?
    if session[:mobile_param]
      session[:mobile_param] == "1"
    else
      request.user_agent =~ /ios|android/i
    end
  end
end
