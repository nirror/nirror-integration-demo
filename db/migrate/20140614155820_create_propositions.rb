class CreatePropositions < ActiveRecord::Migration
  def change
    create_table :propositions do |t|
      t.string :name
      t.string :nirror_site_id
      t.references :user, index: true
      t.timestamps
    end
  end
end
