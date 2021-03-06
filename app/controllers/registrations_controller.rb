class RegistrationsController < Devise::RegistrationsController

  def edit
    @userTimeZone = current_user.time_zone.to_i.freeze
    $timeZoneParam = params
  end

  def destroy
    @user = User.find_by(id: current_user.id)
    @user.groups.each do |group| 
      @group = Group.find_by(id: group.id)
      @group.destroy
    end
   
    @user.destroy

    if @user.destroy
      redirect_to root_url, notice: "Your account has been successfully, terminated."
    end
  end
  private

  def update_resource(resource, params)
    resource.update_without_password(params)
    resource.groups.each do |group|
      group.update(time_zone: params["time_zone"].to_i)
    end
  end

  def sign_up_params
    params.require(:user).permit(:class_number, :first_name, :last_name, :email, :password, :password_confirmation, :conversation_id, :time_zone, :paused_time)
  end

  def account_update_params
    params.require(:user).permit(:class_number, :first_name, :last_name, :email, :time_zone, :paused_time)
  end
  
end