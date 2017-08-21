require_relative("../db/sql_runner")
require_relative("films.rb")

class Customer

  attr_reader :id
  attr_accessor :name, :funds

  def initialize( options )
    @id = options['id'].to_i
    @name = options['name']
    @funds = options['funds'].to_i
  end

  def save()
    sql = "
      INSERT INTO customers
      (name, funds)
      values
      ($1, $2)
      RETURNING id;
    "
    customer = SqlRunner.run( sql, [@name, @funds] ).first
    @id = customer["id"].to_i
  end

  def self.map_items(rows)
    return rows.map { |row| Customer.new(row) }
  end

  def self.all()
    sql = "SELECT * FROM customers;"
    customers = SqlRunner.run(sql, [])
    result = Customer.map_items(customers)
    return result
  end

  def self.delete_all()
    sql = "DELETE FROM customers;"
    SqlRunner.run(sql, [])
  end

  def delete()
    sql = "
      DELETE FROM customers
      WHERE id = $1;
    "
    SqlRunner.run(sql, [@id])
  end

  def update()
    sql = "
      UPDATE customers SET
      (name, funds) = ($1, $2)
      WHERE id = $3;
    "
    SqlRunner.run(sql, [@name, @funds, @id])
  end

  def self.find_by_id(id)
    sql = "SELECT * FROM customers WHERE id = $1;"
    results = SqlRunner.run(sql, [@id])
    customer_hash = results[0]
    return Customer.new(customer_hash)
  end

  def films_seen()
    sql = "
      SELECT films.* FROM films
      INNER JOIN tickets ON films.id =
      tickets.film_id
      WHERE customer_id = $1;
    "
    results = SqlRunner.run(sql, [@id])
    return Film.map_items(results)
  end

  def buy_ticket(film)
    cost = film.cost
    new_funds = @funds - cost
    sql = "
      UPDATE customers SET
      (funds) = ($1)
      WHERE id = $2;
    "
    SqlRunner.run(sql, [new_funds, @id])
    return Ticket.new({ "customer_id" => @id, "film_id" => film.id }).save
  end

end
