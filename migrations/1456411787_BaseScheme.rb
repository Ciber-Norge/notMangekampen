# -*- coding: utf-8 -*-
Sequel.migration do
  up do
    create_table(:challenges) do
      primary_key :id
      String      :uuid,   :size => 32, :null => false
      String      :html,                :null => false
      String      :answer,              :null => false
      String      :next,                :null => false
      Time        :created_at,          :null => false
      Time        :updated_at,          :null => false
    end

    timestamp = Time.now

    self[:challenges].insert(
                        :uuid       => "start",
                        :html       => "<p>Hva slags tur skal vi på?</p>",
                        :answer     => "mangekampturen",
                        :next       => "",
                        :created_at => timestamp,
                        :updated_at => timestamp
      )
  end

  down do
    drop_table(:challenges)
  end
end
