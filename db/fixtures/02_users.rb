# frozen_string_literal: true
unless User.find_by(nickname: 'admin')
  assign_country_id = if country = Country.find_by(iso: 'USA')
                        country.id
                      else
                        nil
                      end

  @user = User.new(email: 'admin@example.com', password: 'password', password_confirmation: 'password', name: 'Admin', nickname: 'admin', country_id: assign_country_id, role: :admin)
  @user.skip_confirmation_notification!
  @user.save

  puts '*************************************************************************'
  puts '*                                                                       *'
  puts '* Admin user created (email: "admin@example.com", password: "password") *'
  puts '* visit http://localhost:3000/                                          *'
  puts '*                                                                       *'
  puts '*************************************************************************'
end
