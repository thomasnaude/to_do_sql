require 'sqlite3'
require_relative 'task'
db_file_path = File.join(File.dirname(__FILE__), "tasks.db")
DB = SQLite3::Database.new(db_file_path)

# task = Task.new({title: 'titre', description: 'uneDescription'})
# task.save
task = Task.find(3)
task.done!
p task
