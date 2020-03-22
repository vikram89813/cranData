class CreatePackages < ActiveRecord::Migration[6.0]
  def change
    create_table :packages do |t|
      t.string :name
      t.string :version
      t.datetime :date
      t.string :title
      t.text :discription

      t.timestamps
    end
  end
end
