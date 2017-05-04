require 'acceptance_helper'

module V1
  describe 'Business model elements', type: :request do
    before(:each) do
      @webuser = create(:webuser)
      token    = JWT.encode({ user: @webuser.id }, ENV['AUTH_SECRET'], 'HS256')

      @headers = {
        "ACCEPT" => "application/json",
        "HTTP_SC_API_KEY" => "Bearer #{token}"
      }
    end

    let!(:user)      { FactoryGirl.create(:user)      }
    let!(:admin)     { FactoryGirl.create(:admin)     }
    let!(:editor)    { FactoryGirl.create(:editor)    }
    let!(:publisher) { FactoryGirl.create(:publisher) }
    let!(:category)  { FactoryGirl.create(:category)  }
    let!(:enabling)  { FactoryGirl.create(:enabling)  }

    let!(:bme)      { FactoryGirl.create(:bme, name: '00 first one') }

    context 'Show bmes' do
      it 'Get bmes list' do
        get '/business-model-elements', headers: @headers
        expect(status).to eq(200)
      end

      it 'Get specific bme' do
        get "/business-model-elements/#{bme.id}", headers: @headers
        expect(status).to eq(200)
      end
    end

    context 'Pagination and sort for bmes' do
      let!(:bmes) {
        bmes = []
        bmes << FactoryGirl.create_list(:bme, 4)
        bmes << FactoryGirl.create(:bme, name: 'ZZZ Next first one', description: 'Business model element BME one')
      }

      it 'Show list of bmes for first page with per pege param' do
        get '/business-model-elements?page[number]=1&page[size]=3', headers: @headers

        expect(status).to    eq(200)
        expect(json.size).to eq(3)
      end

      it 'Show list of bmes for second page with per pege param' do
        get '/business-model-elements?page[number]=2&page[size]=3', headers: @headers

        expect(status).to    eq(200)
        expect(json.size).to eq(3)
      end

      it 'Show list of bmes for sort by name' do
        get '/business-model-elements?sort=name', headers: @headers

        expect(status).to                        eq(200)
        expect(json.size).to                     eq(6)
        expect(json[0]['attributes']['name']).to eq('00 first one')
      end

      it 'Show list of bmes for sort by name DESC' do
        get '/business-model-elements?sort=-name', headers: @headers

        expect(status).to                        eq(200)
        expect(json.size).to                     eq(6)
        expect(json[0]['attributes']['name']).to eq('ZZZ Next first one')
      end

      it 'Search business-model-elements by name or description and sort by name ASC' do
        get '/business-model-elements?search=bme&sort=name', headers: @headers

        expect(status).to                        eq(200)
        expect(json.size).to                     eq(5)
        expect(json[0]['attributes']['name']).to match('BME')
      end
    end

    context 'Create bmes' do
      let!(:error) { { errors: [{ status: 422, title: "name can't be blank" }]}}

      describe 'For admin user' do
        before(:each) do
          token    = JWT.encode({ user: admin.id }, ENV['AUTH_SECRET'], 'HS256')
          @headers = @headers.merge("Authorization" => "Bearer #{token}")
        end

        it 'Returns error object when the bme cannot be created by admin' do
          post '/business-model-elements', params: {"bme": { "name": "" }}, headers: @headers
          expect(status).to eq(422)
          expect(body).to   eq(error.to_json)
        end

        it 'Returns success object when the bme was seccessfully created by admin' do
          post '/business-model-elements', params: {"bme": { "name": "Business model element one", "description": "Lorem ipsum..", "category_ids": [category.id], "enabling_ids": [enabling.id] }},
                        headers: @headers
          expect(status).to eq(201)
          expect(body).to   eq({ messages: [{ status: 201, title: 'Business model element successfully created!' }] }.to_json)
          expect(Bme.find_by(name: 'Business model element one').categories.size).to eq(1)
          expect(Bme.find_by(name: 'Business model element one').enablings.size).to  eq(1)
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

        it 'Do not allows to create bme by not admin user' do
          post '/business-model-elements', params: {"bme": { "name": "Business model element one", "description": "Lorem ipsum.." }},
                        headers: @headers_user
          expect(status).to eq(401)
          expect(body).to   eq(error_unauthorized.to_json)
        end
      end
    end

    context 'Edit bmes' do
      let!(:error) { { errors: [{ status: 422, title: "name can't be blank" }]}}

      describe 'For admin user' do
        before(:each) do
          token    = JWT.encode({ user: admin.id }, ENV['AUTH_SECRET'], 'HS256')
          @headers = @headers.merge("Authorization" => "Bearer #{token}")
        end

        it 'Returns error object when the bme cannot be updated by admin' do
          patch "/business-model-elements/#{bme.id}", params: {"bme": { "name": "" }}, headers: @headers
          expect(status).to eq(422)
          expect(body).to   eq(error.to_json)
        end

        it 'Returns success object when the bme was seccessfully updated by admin' do
          patch "/business-model-elements/#{bme.id}", params: {"bme": { "name": "Business model element one", "description": "Lorem ipsum.." }},
                                   headers: @headers
          expect(status).to eq(200)
          expect(body).to   eq({ messages: [{ status: 200, title: 'Business model element successfully updated!' }] }.to_json)
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

        it 'Do not allows to update bme by not admin user' do
          patch "/business-model-elements/#{bme.id}", params: {"bme": { "name": "Business model element one", "description": "Lorem ipsum.." }},
                                   headers: @headers_user
          expect(status).to eq(401)
          expect(body).to   eq(error_unauthorized.to_json)
        end
      end
    end

    context 'Delete bmes' do
      describe 'For admin user' do
        before(:each) do
          token    = JWT.encode({ user: admin.id }, ENV['AUTH_SECRET'], 'HS256')
          @headers = @headers.merge("Authorization" => "Bearer #{token}")
        end

        it 'Returns success object when the bme was seccessfully deleted by admin' do
          delete "/business-model-elements/#{bme.id}", headers: @headers
          expect(status).to eq(200)
          expect(body).to   eq({ messages: [{ status: 200, title: 'Business model element successfully deleted!' }] }.to_json)
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

        it 'Do not allows to delete bme by not admin user' do
          delete "/business-model-elements/#{bme.id}", headers: @headers_user
          expect(status).to eq(401)
          expect(body).to   eq(error_unauthorized.to_json)
        end
      end
    end
  end
end
