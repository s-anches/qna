class AddAttachmentPolymorphicBelong < ActiveRecord::Migration
  def change

    add_column :attachments, :attachable_id, :integer
    add_column :attachments, :attacheble_type, :string
    add_index :attachments, [:attachable_id, :attacheble_type]

  end
end
