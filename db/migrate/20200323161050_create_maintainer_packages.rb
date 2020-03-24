class CreateMaintainerPackages < ActiveRecord::Migration[6.0]
  def change
    create_table :maintainer_packages do |t|
      t.integer :maintainer_id
      t.integer :package_id

      t.timestamps
    end
  end
end
