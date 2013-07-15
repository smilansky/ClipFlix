class AddTimestampsToReviews < ActiveRecord::Migration
  def change
    change_table(:reviews) { |t| t.timestamps }
  end
end
