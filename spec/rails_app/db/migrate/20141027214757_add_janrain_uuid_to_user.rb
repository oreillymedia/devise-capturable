class AddJanrainUuidToUser < ActiveRecord::Migration
  def change
    add_column :users, :janrain_uuid, :string
    add_index :users, :janrain_uuid
  end
end
