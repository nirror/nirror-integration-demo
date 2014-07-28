class CreateVisits < ActiveRecord::Migration
  def change
    create_table :visits do |t|
      t.string :nirror_hash_path
      t.references :proposition, index: true
      t.timestamps
    end
  end
end
