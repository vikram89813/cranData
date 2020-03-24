class PackageController < ApplicationController

  def search
    package = Package.where(name: params[:name]).last

    if package.present?
      authors = package.authors
      maintainer = package.maintainers.last

      author_names = []
      authors.each do |author|
        author_names.push(author.name)
      end

      data = {
          name: package.name,
          version: package.version,
          date: package.date,
          title: package.title,
          description: package.discription,
          maintainer_name: (maintainer.name rescue nil),
          maintainer_email: (maintainer.email rescue nil),
          author_names: author_names
      }

      render json: {
          result: data
      }, status: :ok and return
    else
      render json: {
          error: "Package not found!"
      }, status: :ok and return
    end
  end

end
