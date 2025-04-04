# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

customers = []
10.times do |i|
  customers << Customer.create!(
    name: "Customer #{i + 1}",
    email: "customer#{i + 1}@example-mailinator.com"
  )
end

order_states = {
  pending: 0,
  preparing: 1,
  ready: 2,
  delivered: 3
}

customers.each do |customer|
  rand(3..10).times do
    customer.orders.create!(
      total_price: rand(50..500),
      placed_at: rand(1..30).days.ago,
      created_at: rand(1..30).days.ago,
      updated_at: Time.current,
      order_state: order_states.values.sample
    )
  end
end

puts "✅ Dummy data created: #{Customer.count} customers, #{Order.count} orders."
