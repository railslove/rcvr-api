class AddCwaTrackingToTickets < ActiveRecord::Migration[6.1]
  def change
    add_column :tickets, :cwa_checked_in, :integer
  end
end
