require("pry")
require_relative("models/customers")
require_relative("models/films")
require_relative("models/tickets")

customer1 = Customer.new({ "name" => "Seamus Mcleod", "funds" => "20" })
customer1.save()
customer2 = Customer.new({ "name" => "Rob Dewar", "funds" => "25" })
customer2.save()
customer3 = Customer.new({ "name" => "Jonny Lockhart", "funds" => "23" })
customer3.save()

film1 = Film.new({ "title" => "The Fast and the Furious", "cost" => "5" })
film1.save()
film2 = Film.new({ "title" => "Moana", "cost" => "7" })
film2.save()
film3 = Film.new({ "title" => "Alien", "cost" => "6" })
film3.save()

# ticket1 = Ticket.new({ "customer_id" => customer1.id, "film_id" => film2.id })
# ticket1.save()
# ticket2 = Ticket.new({ "customer_id" => customer2.id, "film_id" => film3.id })
# ticket2.save()
# ticket3 = Ticket.new({ "customer_id" => customer3.id, "film_id" => film1.id })
# ticket3.save()
# ticket4 = Ticket.new({ "customer_id" => customer1.id, "film_id" => film1.id })
# ticket4.save()

customer1.buy_ticket(film1)
customer2.buy_ticket(film3)
customer3.buy_ticket(film2)
customer1.buy_ticket(film2)
#
# binding.pry
# nil
