class PackageController < ApplicationController

  def search
    package = Package.where(name: params[:name])

    if package.present?
      render json: {
          a: "asdf"
      }, status: :ok
    else
    end
  end

end
