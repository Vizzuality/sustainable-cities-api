# frozen_string_literal: true
unless User.find_by(nickname: 'admin')
  assign_country_id = if country = Country.find_by(iso: 'USA')
                        country.id
                      else
                        nil
                      end

  assign_city_id = if city = City.find_by(name: 'New York')
                     city.id
                   else
                     nil
                   end

  @user = User.new(email: 'admin@example.com', password: ENV['ADMIN_PASSWORD'], password_confirmation: ENV['ADMIN_PASSWORD'],
                   name: 'Admin', nickname: 'admin', country_id: assign_country_id, role: :admin, city_id: assign_city_id, is_active: true)
  @user.save

  puts '*************************************************************************'
  puts '*                                                                       *'
  puts "* Admin user created (email: 'admin@example.com', password: #{ENV['ADMIN_PASSWORD']})   *"
  puts '* visit http://localhost:3000/                                          *'
  puts '*                                                                       *'
  puts '*************************************************************************'
end
