class AddBelongsToAnswer < ActiveRecord::Migration
  def change
    add_belongs_to :answers, :question, index: true, foreign_key: true
  end
end
