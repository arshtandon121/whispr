class CreateReactions < ActiveRecord::Migration[8.0]
  def change
    create_table :reactions do |t|
      t.references :confession, null: false, foreign_key: true
      t.string :reaction_type
      t.string :ip_address

      t.timestamps
    end
  end
end
