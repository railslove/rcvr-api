class AddExceptionAreas < ActiveRecord::Migration[6.1]
  def change
    add_column :areas, :test_exception, :string
  end
end
