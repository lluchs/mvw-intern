Sequel.migration do
  change do
    create_table :groups do
      primary_key :id
      column :name, 'varchar(50)', null: false
    end

    create_table :groups_users do
      foreign_key :user_id, :users
      foreign_key :group_id, :groups
      primary_key [:user_id, :group_id]
    end
  end
end
