class ApplicationController < ActionController::Base
  protect_from_forgery
  respond_to :json, :html

  # before_filter :adult_check
  # skip_before_filter :adult_check
  
  # def adult_check
  #   unless session[:adult]? || cookies[:adult]?
  #     redirect_to age_check_path
  #   end
  # end


end
