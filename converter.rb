require 'sqlite3'
require 'nokogiri'

VOCAB_DIR = './dict/'.freeze

# Open the database
db = SQLite3::Database.new 'data.db'

db.execute('DROP TABLE vocabulary')

# Create a table
db.execute <<-SQL
  CREATE TABLE IF NOT EXISTS vocabulary (
    id INTEGER PRIMARY KEY,
    chapter INTEGER,
    type VARCHAR(10),
    latin VARCHAR(20),
    english VARCHAR(70),
    gender VARCHAR(5),
    conjugation int
  );
SQL

(1..40).each do |chapter|
  puts chapter
  content = File.open(VOCAB_DIR + chapter.to_s) { |f| Nokogiri::XML(f) }
  entries = content.xpath('//entry')
  entries.each do |e|
    entry_type = e.at_xpath('type').content
    latin = e.at_xpath('latin').content
    english = e.at_xpath('english').content
    gender = e.at_xpath('gender')
    conjugation = e.at_xpath('conjugation')

    gender = gender.nil? ? nil : gender.content
    conjugation = conjugation.nil? ? nil : conjugation.content

    db.execute('INSERT INTO vocabulary (chapter, type, latin, english, gender, conjugation) VALUES (?, ?, ?, ?, ?, ?)', [chapter, entry_type, latin, english, gender, conjugation])
  end
end
