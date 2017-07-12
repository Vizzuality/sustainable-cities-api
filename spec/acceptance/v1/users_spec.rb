require 'acceptance_helper'

module V1
  describe 'Users', type: :request do
    before(:each) do
      @webuser = create(:webuser)
      token = JWT.encode({ user: @webuser.id }, ENV['AUTH_SECRET'], 'HS256')

      @headers = {
        "ACCEPT" => "application/json",
        "HTTP_SC_API_KEY" => "Bearer #{token}"
      }
    end

    let!(:user) { User.create(email: 'test@email.com', password: 'password', password_confirmation: 'password', nickname: 'test', name: '00 User one') }

    let!(:admin)     { FactoryGirl.create(:admin)     }
    let!(:editor)    { FactoryGirl.create(:editor)    }
    let!(:publisher) { FactoryGirl.create(:publisher) }

    context 'Show users' do
      it 'Get users list' do
        get '/users', headers: @headers
        expect(status).to eq(200)
      end

      it 'Get specific user' do
        get "/users/#{user.id}", headers: @headers
        expect(status).to eq(200)
      end
    end

    context 'Pagination and sort for users' do
      let!(:users) {
        users = []
        users << FactoryGirl.create_list(:user, 4)
        users << FactoryGirl.create(:user, name: 'ZZZ pepe Next first one')
      }

      it 'Show list of users for first page with per pege param' do
        get '/users?page[number]=1&page[size]=5', headers: @headers

        expect(status).to    eq(200)
        expect(json.size).to eq(5)
      end

      it 'Show list of users for second page with per pege param' do
        get '/users?page[number]=2&page[size]=5', headers: @headers

        expect(status).to    eq(200)
        expect(json.size).to eq(5)
      end

      it 'Show list of users for sort by name' do
        get '/users?sort=name', headers: @headers

        expect(status).to                        eq(200)
        expect(json.size).to                     eq(10)
        expect(json[0]['attributes']['name']).to eq('00 User one')
      end

      it 'Show list of users for sort by name DESC' do
        get '/users?sort=-name', headers: @headers

        expect(status).to                        eq(200)
        expect(json.size).to                     eq(10)
        expect(json[0]['attributes']['name']).to eq('ZZZ pepe Next first one')
      end

      it 'Search users by name or nickname and sort by name DESC' do
        get '/users?search=pepe&sort=name', headers: @headers

        expect(status).to                            eq(200)
        expect(json.size).to                         eq(5)
        expect(json[0]['attributes']['nickname']).to match('pepe')
      end
    end

    context 'Register users' do
      let!(:error) { { errors: [{ status: 422, title: "nickname can't be blank" },
                                { status: 422, title: "nickname is invalid"},
                                { status: 422, title: "name can't be blank"},
                                { status: 422, title: "password_confirmation can't be blank" }]}}

      let!(:error_pw) { { errors: [{ status: 422, title: "password is too short (minimum is 8 characters)" }]}}

      describe 'Registration' do
        it 'Returns error object when the user cannot be registrated' do
          post '/register', params: {"user": { "email": "test@gmail.com", "password": "password" }}, headers: @headers
          expect(status).to eq(422)
          expect(body).to   eq(error.to_json)
        end

        it 'Returns error object when the user password is to short' do
          post '/register', params: {"user": { "email": "test@gmail.com", "nickname": "sebanew", "password": "12", "password_confirmation": "12", "name": "Test user new" }}, headers: @headers
          expect(status).to eq(422)
          expect(body).to   eq(error_pw.to_json)
        end

        it 'Register valid user' do
          post '/register', params: {"user": { "email": "test@gmail.com", "nickname": "sebanew", "password": "password", "password_confirmation": "password", "name": "Test user new" }},
                            headers: @headers
          expect(status).to eq(201)
          expect(body).to   eq({ messages: [{ status: 201, title: 'User successfully registrated!' }] }.to_json)
        end
      end
    end

    context 'Create users' do
      before(:each) do
        token    = JWT.encode({ user: admin.id }, ENV['AUTH_SECRET'], 'HS256')
        @headers = @headers.merge("Authorization" => "Bearer #{token}")
      end

      let!(:error) { { errors: [{ status: 422, title: "nickname can't be blank" },
                                { status: 422, title: "nickname is invalid"},
                                { status: 422, title: "name can't be blank"},
                                { status: 422, title: "password_confirmation can't be blank" }]}}

      describe 'Create user by admin' do
        it 'Returns error object when the user cannot be created' do
          post '/users', params: {"user": { "email": "test@gmail.com", "password": "password" }}, headers: @headers
          expect(status).to eq(422)
          expect(body).to   eq(error.to_json)
        end

        it 'Create valid user by admin' do
          post '/users', params: {"user": { "email": "test@gmail.com", "nickname": "sebanew", "password": "password", "password_confirmation": "password", "name": "Test user new" }},
                         headers: @headers
          expect(status).to eq(201)
          expect(body).to   eq({ messages: [{ status: 201, title: 'User successfully created!' }] }.to_json)
        end
      end
    end

    context 'Update users' do
      let!(:error) { { errors: [{ status: 422, title: "name can't be blank"}]}}

      describe 'Update user by admin' do
        before(:each) do
          token    = JWT.encode({ user: admin.id }, ENV['AUTH_SECRET'], 'HS256')
          @headers = @headers.merge("Authorization" => "Bearer #{token}")
        end

        it 'Returns error object when the user cannot be updated' do
          patch "/users/#{user.id}", params: {"user": { "name": "" }}, headers: @headers
          expect(status).to eq(422)
          expect(body).to   eq(error.to_json)
        end

        it 'Update user by admin' do
          patch "/users/#{user.id}", params: {"user": { "nickname": "sebanew", "name": "Test user new" }},
                                     headers: @headers
          expect(status).to eq(200)
          expect(body).to   eq({ messages: [{ status: 200, title: 'User successfully updated!' }] }.to_json)
        end

        it 'Update user role by admin' do
          patch "/users/#{user.id}", params: {"user": { "role": "admin" }}, headers: @headers
          expect(status).to           eq(200)
          expect(user.reload.role).to eq('admin')
        end
      end

      describe 'User can update profile' do
        let!(:photo_data) {
          "data:image/jpeg;base64,#{Base64.encode64(File.read(File.join(Rails.root, 'spec', 'support', 'files', 'image.jpg')))}"
        }

        before(:each) do
          token    = JWT.encode({ user: user.id }, ENV['AUTH_SECRET'], 'HS256')
          @headers = @headers.merge("Authorization" => "Bearer #{token}")
        end

        it 'Returns error object when the user cannot be updated' do
          patch "/users/#{user.id}", params: {"user": { "name": "" }}, headers: @headers
          expect(status).to eq(422)
          expect(body).to   eq(error.to_json)
        end

        it 'Update user by owner' do
          patch "/users/#{user.id}", params: {"user": { "nickname": "sebanew", "name": "Test user new" }},
                                     headers: @headers
          expect(status).to eq(200)
          expect(body).to   eq({ messages: [{ status: 200, title: 'User successfully updated!' }] }.to_json)
        end

        it 'Do not allow user to change the role' do
          patch "/users/#{user.id}", params: {"user": { "role": "admin" }}, headers: @headers
          expect(status).to           eq(200)
          expect(user.reload.role).to eq('user')
        end

        it 'Upload avatar and returns success object when the user was seccessfully updated' do
          patch "/users/#{user.id}", params: {"user": { "image": photo_data }},
                                     headers: @headers
          expect(status).to eq(200)
          expect(body).to   eq({ messages: [{ status: 200, title: 'User successfully updated!' }] }.to_json)
        end
      end
    end

    context 'Login and authenticate user' do
      let!(:error) { { errors: [{ status: '401', title: "Incorrect email or password" }]}}

      it 'Returns error object when the user cannot login' do
        post '/login', params: {"data": {"type": "session", "attributes": {"email":"test@email.com","password":"wrong password"}}}, headers: @headers

        expect(body).to   eq(error.to_json)
        expect(status).to eq(401)
      end

      it 'Valid login' do
        email = "test@email.com"
        post '/login', params: {"data": {"type": "session", "attributes": {"email": email,"password":"password"}}}, headers: @headers
        token = JWT.encode({ user: user.id }, ENV['AUTH_SECRET'], 'HS256')
        expect(body).to   eq({data: {id: token, type: "sessions", attributes: {email: email, password: nil, token: token}}}.to_json)
        expect(status).to eq(200)
      end

      describe 'For current user' do
        before(:each) do
          login_user(user)
        end

        it 'Get current user' do
          token = JWT.encode({ user: user.id }, ENV['AUTH_SECRET'], 'HS256')

          headers = @headers.merge("Authorization" => "Bearer #{token}")

          get '/users/current-user', headers: headers
          expect(status).to eq(200)
          expect(json).to   eq({"id"=>"#{user.id}", "type"=>"users", "attributes"=>{"name"=>"00 User one", "email"=>"test@email.com",
                                                                                    "role"=>"user", "country_id"=>nil, "city_id"=>nil,
                                                                                    "nickname"=>"test", "institution"=>nil, "position"=>nil,
                                                                                    "twitter_account"=>nil, "linkedin_account"=>nil,
                                                                                    "is_active"=>true, "deactivated_at"=>nil,
                                                                                    "image"=>{"url"=>nil, "thumbnail"=>{"url"=>nil}, "square"=>{"url"=>nil}},
                                                                                    "permissions"=>{"all"=>{"StudyCase"=>["read"], "BusinessModel"=>[],
                                                                                                            "Bme"=>["read"], "Category"=>["read"], "City"=>["read"],
                                                                                                            "Comment"=>["create"], "Country"=>["read"], "Document"=>["read"],
                                                                                                            "Enabling"=>["read"], "ExternalSource"=>["read"], "Impact"=>["read"],
                                                                                                            "Photo"=>["read"], "User"=>["read"]},
                                                                                                    "owner"=>{"User"=>["update"]},
                                                                                                    "member"=>{"StudyCase"=>["update"], "BusinessModel"=>["read", "update"]}}}})
        end

        let!(:error) {
          { errors: [{ status: '401', title: 'Unauthorized' }] }
        }

        it 'Request without valid authorization for current user' do
          get '/users/current-user', headers: @headers
          expect(status).to eq(401)
          expect(body).to   eq(error.to_json)
        end
      end
    end

    context 'Delete users' do
      describe 'For admin user' do
        before(:each) do
          token    = JWT.encode({ user: admin.id }, ENV['AUTH_SECRET'], 'HS256')
          @headers = @headers.merge("Authorization" => "Bearer #{token}")
        end

        it 'Returns success object when the user was seccessfully deleted by admin' do
          delete "/users/#{user.id}", headers: @headers
          expect(status).to eq(200)
          expect(body).to   eq({ messages: [{ status: 200, title: 'User successfully deleted!' }] }.to_json)
        end
      end

      describe 'For not admin user' do
        before(:each) do
          token         = JWT.encode({ user: publisher.id }, ENV['AUTH_SECRET'], 'HS256')
          @headers_user = @headers.merge("Authorization" => "Bearer #{token}")
        end

        let!(:error_unauthorized) {
          { errors: [{ status: '401', title: 'You are not authorized to access this page.' }] }
        }

        it 'Do not allows to delete user by not admin user' do
          delete "/users/#{user.id}", headers: @headers_user
          expect(status).to eq(401)
          expect(body).to   eq(error_unauthorized.to_json)
        end
      end
    end
  end
end
