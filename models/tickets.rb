require_relative("../db/sql_runner")
require_relative("customers.rb")
require_relative("films.rb")

class Ticket

  attr_reader :id
  attr_accessor :customer_id, :film_id

  def initialize( options )
    @id = options["id"].to_i
    @customer_id = options["customer_id"].to_i
    @film_id = options["film_id"].to_i
  end

  def save()
    sql = "
      INSERT INTO tickets
      (customer_id, film_id)
      values
      ($1, $2)
      RETURNING id
    "
    customer = SqlRunner.run( sql, [@customer_id, @film_id] ).first
    @id = customer["id"].to_i
  end

  def self.map_items(rows)
    return rows.map { |row| Ticket.new(row) }
  end

  def self.all()
    sql = "SELECT * FROM tickets;"
    tickets = SqlRunner.run(sql, [])
    return Ticket.map_items(tickets)
  end

  def self.delete_all()
    sql = "DELETE FROM tickets;"
    SqlRunner.run(sql, [])
  end

  def delete()
    sql = "
      DELETE FROM tickets
      WHERE id = $1;
    "
    SqlRunner.run(sql, [@id])
  end

  def update()
    sql = "
      UPDATE tickets SET
      (customer_id, film_id) = ($1, $2)
      WHERE id = $3;
    "
    SqlRunner.run(sql, [@customer_id, @film_id, @id])
  end

  def self.find_by_id(id)
    sql = "SELECT * FROM tickets WHERE id = $1;"
    results = SqlRunner.run(sql, [@id])
    ticket_hash = results[0]
    return Ticket.new(ticket_hash)
  end

  def customer()
    sql = "
      SELECT * FROM customers
      WHERE id = $1;
    "
    results_array = SqlRunner.run(sql, [@customer_id])
    customer_hash = results_array[0]
    return Customer.new(customer_hash)
  end

  def film()
    sql = "
      SELECT * FROM films
      WHERE id = $1;
    "
    results_array = SqlRunner.run(sql, [@film_id])
    film_hash = results_array[0]
    return Film.new(film_hash)
  end

end
