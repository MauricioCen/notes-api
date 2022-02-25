# frozen_string_literal: true

class AddUserToNotes < ActiveRecord::Migration[7.0]
  def change
    add_column :notes, :user_id, :integer
  end
end
