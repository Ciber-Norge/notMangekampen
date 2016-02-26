Sequel.migration do
  up do
    create_table(:challenges) do
      primary_key :id
      String      :uuid,   size => 32, :null => false
      String      :html,               :null => false
      String      :answer,             :null => false
      String      :next,               :null => false
      Datetime    :created_at,         :null => false
      Datetime    :updated_at,         :null => false
    end

    timestamp = Time.now

    self[:users].insert(
                        :uuid => "start",
                        :html => "",
                        :answer
      )
  end

  down do
    drop_table(:challenges)
  end
end
