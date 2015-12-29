Sequel.migration do
  change do
    alter_table :users do
      add_column :birthday, 'date'
      add_column :password, 'text'
    end
  end
end
