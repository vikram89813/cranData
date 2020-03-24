class Maintainer < ApplicationRecord

  has_many :maintainer_packages
  has_many :packages, through: :maintainer_packages

end
