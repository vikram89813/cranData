class MaintainerPackage < ApplicationRecord
  belongs_to :package
  belongs_to :maintainer
end
