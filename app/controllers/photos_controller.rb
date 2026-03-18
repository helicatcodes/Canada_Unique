class PhotosController < ApplicationController
  skip_before_action :authenticate_user!, only: [ :home ]

  # do i need a home method?
  def home
  end

  def in_canada


  end
end


# TO DO
#   add photo upload
#   add view of a photo
#   add shared feed of media posts
