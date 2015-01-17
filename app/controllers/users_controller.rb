class UsersController < ApplicationController
  before_filter :authorize, only: [:show]


  def show
    @user= User.find(params[:id])
    @idea = @user.ideas.new
    authorize! :read, @user
  end

  def admin
      authorize! :manage, :all
  end
end
