# -*- coding: utf-8 -*-
Sequel.migration do
  up do
    timestamp = Time.now
    self[:challenges].insert(
                        :uuid       => "lets-get-this-quiz-going",
                        :html       => "<p>Denne er litt verre. Du må kanskje finne kilden for å finne svaret...</p>",
                        :answer     => "Mangekampturen2016",
                        :next       => "insert manually",
                        :created_at => timestamp,
                        :updated_at => timestamp
     )
  end
end
