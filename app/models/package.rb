class Package < ApplicationRecord

  has_many :author_packages
  has_many :maintainer_packages

  has_many :authors, through: :author_packages
  has_many :maintainers, through: :maintainer_packages

end
