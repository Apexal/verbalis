require 'json'
require 'sqlite3'

# Open the database
db = SQLite3::Database.new 'data.db'
db.results_as_hash = true

export = []

db.query('SELECT * FROM vocabulary WHERE chapter < 10').each do |entry|
  export << entry
end

File.write('data.json', export.to_json)
