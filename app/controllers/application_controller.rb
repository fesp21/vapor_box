class ApplicationController < ActionController::Base
  protect_from_forgery
  respond_to :json, :html

  
  def adult_check
    if session[:adult]=='yes' || cookies[:adult]=='yes'
      return true
    else
      redirect_to age_check_path
    end
  end

  def age_verify
    begin
    @date = (params[:birthdate]+'/'+params[:birthmonth] +'/'+params[:birthyear]).to_date
    if (@date + 18.years) < Date.today
      session[:adult] = 'yes'
      if params[:remember_me] == 'yes'
        cookies[:adult] =  { value: "yes", expires: 30.day.from_now }
      end
    else
      session[:adult] = 'no'
      cookies[:adult] =  { value: "no", expires: 30.day.from_now }
    end

    redirect_to root_path
    rescue ArgumentError
      redirect_to root_path
    end
  end



end
