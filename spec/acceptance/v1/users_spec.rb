require 'acceptance_helper'

module V1
  describe 'Users', type: :request do
    let!(:user) { User.create(email: 'test@email.com', password: 'password', password_confirmation: 'password', nickname: 'test', name: 'Test user') }

    context 'Show users' do
      describe 'Request without valid authorization' do
        let!(:error) {
          { errors: [{ status: '401', title: 'Unauthorized' }] }
        }

        it 'Get users list' do
          get '/users'
          expect(status).to eq(401)
          expect(body).to   eq(error.to_json)
        end

        it 'Get specific user' do
          get "/users/#{user.id}"
          expect(status).to eq(401)
          expect(body).to   eq(error.to_json)
        end
      end

      describe 'Authenticated request' do
        it 'Get users list' do
          token = JWT.encode({user: user.id}, ENV['AUTH_SECRET'], 'HS256')

          headers = {
            "ACCEPT" => "application/json",
            "Authorization" => "Bearer #{token}"
          }

          get '/users', headers: headers
          expect(status).to eq(200)
          expect(json).to   eq([{"id"=>"#{user.id}", "type"=>"users", "attributes"=>{"name"=>"Test user", "email"=>"test@email.com"}}])
        end

        it 'Get specific user' do
          token = JWT.encode({user: user.id}, ENV['AUTH_SECRET'], 'HS256')

          headers = {
            "ACCEPT" => "application/json",
            "Authorization" => "Bearer #{token}"
          }

          get "/users/#{user.id}", headers: headers
          expect(status).to eq(200)
          expect(json).to   eq({"id"=>"#{user.id}", "type"=>"users", "attributes"=>{"name"=>"Test user", "email"=>"test@email.com"}})
        end
      end
    end

    context 'Create and register users' do
      let!(:error) { { errors: [{ title: "nickname can't be blank" },
                                { title: "nickname is invalid"},
                                { title: "name can't be blank"},
                                { title: "password_confirmation can't be blank" }]}}

      describe 'Registration' do
        it "Returns error object when the user cannot be created" do
          post '/users', params: {"user": { "email": "test@gmail.com", "password": "password" }}
          expect(status).to eq(422)
          expect(body).to   eq(error.to_json)
        end

        it "Register valis user" do
          post '/users', params: {"user": { "email": "test@gmail.com", "nickname": "sebanew", "password": "password", "password_confirmation": "password", "name": "Test user new" }}
          expect(status).to eq(201)
          expect(body).to   eq({ messages: [{ status: 201, title: 'User successfully created!' }] }.to_json)
        end
      end
    end

    context 'Login and authenticate user' do
      let!(:error) { { errors: [{ title: "Incorrect email or password" }]}}

      it 'Returns error object when the user cannot login' do
        post '/login', params: {"auth": { "email": "test@gmail.com", "password": "wrong password" }}
        expect(status).to eq(401)
        expect(body).to   eq(error.to_json)
      end

      it 'Valid login' do
        post '/login', params: {"auth": { "email": "test@email.com", "password": "password" }}
        expect(status).to eq(200)
        expect(body).to   eq({ token: JWT.encode({user: user.id}, ENV['AUTH_SECRET'], 'HS256') }.to_json)
      end

      describe 'For current user' do
        before(:each) do
          login_user(user)
        end

        it 'Get current user' do
          token = JWT.encode({user: user.id}, ENV['AUTH_SECRET'], 'HS256')

          headers = {
            "ACCEPT" => "application/json",
            "Authorization" => "Bearer #{token}"
          }

          get '/users/current-user', headers: headers
          expect(status).to eq(200)
          expect(json).to   eq({"id"=>"#{user.id}", "type"=>"users", "attributes"=>{"name"=>"Test user", "email"=>"test@email.com"}})
        end

        let!(:error) {
          { errors: [{ status: '401', title: 'Unauthorized' }] }
        }

        it 'Request without valid authorization for current user' do
          get '/users/current-user'
          expect(status).to eq(401)
          expect(body).to   eq(error.to_json)
        end
      end
    end
  end
end
