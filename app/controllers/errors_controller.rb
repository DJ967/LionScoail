class ErrorsController < ApplicationController
  before_action :set_error, only: [:destroy]

  def new
    @error = Error.new
  end

  def create
    @error = Error.new(error_params)
    if @error.save
      flash[:notice] = "Error was successfully reported. We will review it and fix this error #{current_user.username}."
      redirect_to root_path
      AllMailer.error_email.deliver_now
    else
      render 'new'
    end
  end

 def index
   if current_user.role == "admin"
   else
     redirect_to root_path, notice: "Your not that user"
   end
   @errors = Error.all
   @errors = Error.by_newest
 end

 def destroy
   @error.destroy
   flash[:notice] = "Error was deleted"
   redirect_to errors_path
  end

 private
  def set_error
    @error = Error.find(params[:id])
  end

  def error_params
    params.require(:error).permit(:error, :description)
  end

end
