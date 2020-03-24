class CreateAuthorPackages < ActiveRecord::Migration[6.0]
  def change
    create_table :author_packages do |t|
      t.integer :author_id
      t.integer :package_id

      t.timestamps
    end
  end
end
