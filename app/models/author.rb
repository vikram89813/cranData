class Author < ApplicationRecord

  has_many :author_packages
  has_many :packages, through: :author_packages

end
