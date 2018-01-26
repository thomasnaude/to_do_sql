class Task
  attr_reader :id
  attr_accessor :title, :description, :done

  def initialize(attributes)
    @id = attributes[:id] || attributes["id"]
    @title = attributes[:title]|| attributes["title"]
    @description = attributes[:description] || attributes["description"]
    @done = attributes[:done] || attributes["done"] || false
  end

  def save
    if @id.nil?
      DB.execute("INSERT INTO tasks (title, description, done) VALUES (?, ?, ?)", title, description, done_to_sql)
      @id = DB.last_insert_row_id
    else
      DB.execute("UPDATE tasks SET title = ?, description = ?, done = ?", title, description, done_to_sql)
    end
    self
  end

  def self.find(id)
    DB.results_as_hash = true
    results = DB.execute("SELECT * FROM tasks WHERE id = ?", id)
    build_task(results.first)
  end

  def self.all
    DB.results_as_hash = true
    results = DB.execute("SELECT * FROM tasks")
    results.map do |row|
      build_task(row)
    end
  end

  def destroy
    DB.execute("DELETE FROM tasks WHERE id = ?", id)
  end

  def done!
    @done = true
    save
  end
  private

  def done_to_sql
    done == false ? 0 : 1
  end

  def self.build_task(attributes)
    attributes["done"] = attributes["done"] == 1
    Task.new(attributes)
  end
end
