class ChangeCoronatestoptions < ActiveRecord::Migration[6.1]
  def up
    execute "
        ALTER TABLE companies ALTER need_to_show_corona_test SET DEFAULT null;
        ALTER TABLE companies
        ALTER need_to_show_corona_test TYPE INTEGER
        USING
        CASE
        WHEN true THEN 48 ELSE 0
        end;
      "
  end

  def down
    execute "
      ALTER TABLE companies ALTER COLUMN need_to_show_corona_test TYPE BOOL USING need_to_show_corona_test::boolean;
    "
  end
end
