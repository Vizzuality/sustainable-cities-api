# frozen_string_literal: true
unless User.find_by(nickname: 'user')
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

  @user = User.new(email: 'user@example.com', password: 'password', password_confirmation: 'password',
                   name: 'Web', nickname: 'user', country_id: assign_country_id, role: :user, city_id: assign_city_id, is_active: true)
  @user.save

  puts '*************************************************************************'
  puts '*                                                                       *'
  puts "* Web user created (email: 'user@example.com', password: 'password'     *"
  puts '*                                                                       *'
  puts '*************************************************************************'
end

unless User.find_by(nickname: 'editor')
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

  @user = User.new(email: 'editor@example.com', password: 'password', password_confirmation: 'password',
                   name: 'Editor', nickname: 'editor', country_id: assign_country_id, role: :editor, city_id: assign_city_id, is_active: true)
  @user.save

  puts '*************************************************************************'
  puts '*                                                                       *'
  puts "* Editor created (email: 'editor@example.com', password: 'password'     *"
  puts '*                                                                       *'
  puts '*************************************************************************'
end

unless User.find_by(nickname: 'publisher')
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

  @user = User.new(email: 'publisher@example.com', password: 'password', password_confirmation: 'password',
                   name: 'Publisher', nickname: 'publisher', country_id: assign_country_id, role: :publisher, city_id: assign_city_id, is_active: true)
  @user.save

  puts '***************************************************************************'
  puts '*                                                                         *'
  puts "* Publisher created (email: 'publisher@example.com', password: 'password' *"
  puts '*                                                                         *'
  puts '***************************************************************************'
end

unless User.find_by(nickname: 'webuser')
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

  @user = User.new(email: 'webuser@example.com', password: 'password', password_confirmation: 'password',
                   name: 'Web', nickname: 'webuser', country_id: assign_country_id, role: :user, city_id: assign_city_id, is_active: true)
  @user.save

  @user.regenerate_api_key

  puts '*************************************************************************'
  puts '*                                                                       *'
  puts "* Web user created (email: 'webuser@example.com', password: 'password'  *"
  puts '*                                                                       *'
  puts "* API Key created (SC_API_KEY: Bearer #{@user.api_key.access_token})"
  puts '*                                                                       *'
  puts '*************************************************************************'
end
