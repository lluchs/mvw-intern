Sequel.migration do
  change do
    create_table :events do
      primary_key :id
      column :title, 'varchar(50)', null: false
      column :start, 'timestamp', null: false
      column :duration, 'interval', null: false
      column :type, 'varchar(30)'
      column :desc, 'text'
    end
  end
end
