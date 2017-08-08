require 'acceptance_helper'

module V1
  describe 'Enablings', type: :request do
    before(:each) do
      @webuser = create(:webuser)
      token    = JWT.encode({ user: @webuser.id }, ENV['AUTH_SECRET'], 'HS256')

      @headers = {
        "ACCEPT" => "application/vnd.api+json",
        "HTTP_SC_API_KEY" => "Bearer #{token}"
      }
    end

    let!(:user)      { FactoryGirl.create(:user)      }
    let!(:admin)     { FactoryGirl.create(:admin)     }
    let!(:editor)    { FactoryGirl.create(:editor)    }
    let!(:publisher) { FactoryGirl.create(:publisher) }

    let!(:enabling)  { FactoryGirl.create(:enabling, name: '00 first one') }

    context 'Show enablings' do
      it 'Get enablings list' do
        get '/enablings', headers: @headers
        expect(status).to eq(200)
      end

      it 'Get specific enabling' do
        get "/enablings/#{enabling.id}", headers: @headers
        expect(status).to eq(200)
      end
    end

    context 'Pagination and sort for enablings' do
      let!(:enablings) {
        enablings = []
        enablings << FactoryGirl.create_list(:enabling, 4)
        enablings << FactoryGirl.create(:enabling, name: 'ZZZ Next first one', description: 'lorem ipsum Enabling')
      }

      it 'Show list of enablings for first page with per pege param' do
        get '/enablings?page[number]=1&page[size]=3', headers: @headers

        expect(status).to    eq(200)
        expect(json.size).to eq(3)
      end

      it 'Show list of enablings for second page with per pege param' do
        get '/enablings?page[number]=2&page[size]=3', headers: @headers

        expect(status).to    eq(200)
        expect(json.size).to eq(3)
      end

      it 'Show list of enablings for sort by name' do
        get '/enablings?sort=name', headers: @headers

        expect(status).to                        eq(200)
        expect(json.size).to                     eq(6)
        expect(json[0]['attributes']['name']).to eq('00 first one')
      end

      it 'Show list of enablings for sort by name DESC' do
        get '/enablings?sort=-name', headers: @headers

        expect(status).to                        eq(200)
        expect(json.size).to                     eq(6)
        expect(json[0]['attributes']['name']).to eq('ZZZ Next first one')
      end

      it 'Search enablings by name' do
        get '/enablings?filter[name]=00 first one', headers: @headers

        expect(status).to                        eq(200)
        expect(json.size).to                     eq(1)
        expect(json[0]['attributes']['name']).to match('00 first one')
      end
    end

    context 'Create enablings' do
      let!(:error) { { errors: [{ status: 422, title: "name can't be blank" }]}}

      describe 'For admin user' do
        before(:each) do
          token    = JWT.encode({ user: admin.id }, ENV['AUTH_SECRET'], 'HS256')
          @headers = @headers.merge("Authorization" => "Bearer #{token}")
        end

        it 'Returns error object when the enabling cannot be created by admin' do
          post '/enablings', params: {"enabling": { "name": "" }}, headers: @headers
          expect(status).to eq(422)
          expect(body).to   eq(error.to_json)
        end

        it 'Returns success object when the enabling was seccessfully created by admin' do
          post '/enablings', params: {"enabling": { "name": "Enabling one" }},
                             headers: @headers
          expect(status).to eq(201)
          expect(body).to   eq({ messages: [{ status: 201, title: 'Enabling successfully created!' }] }.to_json)
        end
      end

      describe 'For not admin user' do
        before(:each) do
          token         = JWT.encode({ user: user.id }, ENV['AUTH_SECRET'], 'HS256')
          @headers_user = @headers.merge("Authorization" => "Bearer #{token}")
        end

        let!(:error_unauthorized) {
          { errors: [{ status: '401', title: 'You are not authorized to access this page.' }] }
        }

        it 'Do not allows to create enabling by not admin user' do
          post '/enablings', params: {"enabling": { "name": "Enabling one" }},
                             headers: @headers_user
          expect(status).to eq(401)
          expect(body).to   eq(error_unauthorized.to_json)
        end
      end
    end

    context 'Edit enablings' do
      let!(:error) { { errors: [{ status: 422, title: "name can't be blank" }]}}

      describe 'For admin user' do
        before(:each) do
          token    = JWT.encode({ user: admin.id }, ENV['AUTH_SECRET'], 'HS256')
          @headers = @headers.merge("Authorization" => "Bearer #{token}")
        end

        it 'Returns error object when the enabling cannot be updated by admin' do
          patch "/enablings/#{enabling.id}", params: {"enabling": { "name": "" }}, headers: @headers
          expect(status).to eq(422)
          expect(body).to   eq(error.to_json)
        end

        it 'Returns success object when the enabling was seccessfully updated by admin' do
          patch "/enablings/#{enabling.id}", params: {"enabling": { "name": "Enabling one" }},
                                             headers: @headers
          expect(status).to eq(200)
          expect(body).to   eq({ messages: [{ status: 200, title: 'Enabling successfully updated!' }] }.to_json)
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

        it 'Do not allows to update enabling by not admin user' do
          patch "/enablings/#{enabling.id}", params: {"enabling": { "name": "Enabling one" }},
                                             headers: @headers_user
          expect(status).to eq(401)
          expect(body).to   eq(error_unauthorized.to_json)
        end
      end
    end

    context 'Delete enablings' do
      describe 'For admin user' do
        before(:each) do
          token    = JWT.encode({ user: admin.id }, ENV['AUTH_SECRET'], 'HS256')
          @headers = @headers.merge("Authorization" => "Bearer #{token}")
        end

        it 'Returns success object when the enabling was seccessfully deleted by admin' do
          delete "/enablings/#{enabling.id}", headers: @headers
          expect(status).to eq(200)
          expect(body).to   eq({ messages: [{ status: 200, title: 'Enabling successfully deleted!' }] }.to_json)
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

        it 'Do not allows to delete enabling by not admin user' do
          delete "/enablings/#{enabling.id}", headers: @headers_user
          expect(status).to eq(401)
          expect(body).to   eq(error_unauthorized.to_json)
        end
      end
    end
  end
end
