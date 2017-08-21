require_relative("../db/sql_runner")

class Film

  attr_reader :id
  attr_accessor :title, :cost

  def initialize( options )
    @id = options["id"].to_i
    @title = options["title"]
    @cost = options["cost"].to_i
  end

  def save()
    sql = "
      INSERT INTO films
      (title, cost)
      values
      ($1, $2)
      RETURNING id
    "
    customer = SqlRunner.run( sql, [@title, @cost] ).first
    @id = customer["id"].to_i
  end

  def self.map_items(rows)
    return rows.map { |row| Film.new(row) }
  end

  def self.all()
    sql = "SELECT * FROM films;"
    customers = SqlRunner.run(sql, [])
    result = Film.map_items(customers)
    return result
  end

  def self.delete_all()
    sql = "DELETE FROM films;"
    SqlRunner.run(sql, [])
  end

  def delete()
    sql = "
      DELETE FROM films
      WHERE id = $1;
    "
    SqlRunner.run(sql, [@id])
  end

  def update()
    sql = "
      UPDATE films SET
      (title, cost) = ($1, $2)
      WHERE id = $3;
    "
    SqlRunner.run(sql, [@title, @cost, @id])
  end

  def self.find_by_id(id)
    sql = "SELECT * FROM films WHERE id = $1;"
    results = SqlRunner.run(sql, [@id])
    film_hash = results[0]
    return Film.new(film_hash)
  end

  def customers_watched()
    sql = "
      SELECT customers.* FROM customers
      INNER JOIN tickets ON customers.id =
      tickets.customer_id
      WHERE film_id = $1;
    "
    results = SqlRunner.run(sql, [@id])
    return Customer.map_items(results)
  end

end
