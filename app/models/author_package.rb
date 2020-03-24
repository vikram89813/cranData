class AuthorPackage < ApplicationRecord
  belongs_to :package
  belongs_to :author
end
