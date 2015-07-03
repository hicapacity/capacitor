class ProfilesController < ApplicationController
  def show
    # include MD5 gem, should be part of standard ruby install
    # require 'digest/md5'
    @profile = current_user
    # get the email from URL-parameters or what have you and make lowercase
    email_address = current_user.email.downcase

    # create the md5 hash
    hash = Digest::MD5.hexdigest(email_address)

    # compile URL which can be used in <img src="RIGHT_HERE"...
    @gravatar_src = "http://www.gravatar.com/avatar/#{hash}?d=retro"
  end

  def edit
    @profile = current_user
  end

  def update
    @profile = current_user

    if @profile.update(profile_params)
      #@profile.save
      redirect_to (profile_path)
    else
      render 'edit'
    end
  end

  private
    def profile_params
      params.require(:user).permit(:first_name, :last_name, :blurb, :hobbies, :projects, :contact)
    end

end
