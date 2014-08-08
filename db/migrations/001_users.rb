Sequel.migration do
  change do
    create_table :users do
      primary_key :id
      column :name, 'varchar(50)', null: false
      column :email, 'varchar(50)', null: false, unique: true
      column :instrument, 'varchar(30)'
      column :active, 'boolean', default: true
      column :admin, 'boolean', default: false
    end
  end
end
