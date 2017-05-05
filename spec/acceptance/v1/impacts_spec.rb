require 'acceptance_helper'

module V1
  describe 'Impacts', type: :request do
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

    let!(:impact)    { FactoryGirl.create(:impact, name: '00 first one', impact_value: 'ZZZ value') }

    context 'Show impacts' do
      it 'Get impacts list' do
        get '/impacts', headers: @headers
        expect(status).to eq(200)
      end

      it 'Get specific impact' do
        get "/impacts/#{impact.id}", headers: @headers
        expect(status).to eq(200)
      end
    end

    context 'Pagination and sort for impacts' do
      let!(:impacts) {
        impacts = []
        impacts << FactoryGirl.create_list(:impact, 4)
        impacts << FactoryGirl.create(:impact, name: 'ZZZ Next first one', description: 'lorem ipsum Impact', impact_value: 'AAA value', impact_unit: 'ZZZ unit')
      }

      it 'Show list of impacts for first page with per pege param' do
        get '/impacts?page[number]=1&page[size]=3', headers: @headers

        expect(status).to    eq(200)
        expect(json.size).to eq(3)
      end

      it 'Show list of impacts for second page with per pege param' do
        get '/impacts?page[number]=2&page[size]=3', headers: @headers

        expect(status).to    eq(200)
        expect(json.size).to eq(3)
      end

      it 'Show list of impacts for sort by name' do
        get '/impacts?sort=name', headers: @headers

        expect(status).to                        eq(200)
        expect(json.size).to                     eq(6)
        expect(json[0]['attributes']['name']).to eq('00 first one')
      end

      it 'Show list of impacts for sort by name DESC' do
        get '/impacts?sort=-name', headers: @headers

        expect(status).to                        eq(200)
        expect(json.size).to                     eq(6)
        expect(json[0]['attributes']['name']).to eq('ZZZ Next first one')
      end

      it 'Search impacts by name or description and sort by name DESC' do
        get '/impacts?search=impact&sort=name', headers: @headers

        expect(status).to                        eq(200)
        expect(json.size).to                     eq(5)
        expect(json[0]['attributes']['name']).to match('Impact')
      end

      it 'Show list of impacts for sort by impact_unit DESC' do
        get '/impacts?sort=-impact_unit', headers: @headers

        expect(status).to                               eq(200)
        expect(json.size).to                            eq(6)
        expect(json[0]['attributes']['impact_unit']).to eq('ZZZ unit')
      end

      it 'Show list of impacts for sort by impact_value DESC' do
        get '/impacts?sort=-impact_value', headers: @headers

        expect(status).to                                eq(200)
        expect(json.size).to                             eq(6)
        expect(json[0]['attributes']['impact_value']).to eq('ZZZ value')
      end
    end

    context 'Create impacts' do
      let!(:error) { { errors: [{ status: 422, title: "impact_value can't be blank" }]}}

      describe 'For admin user' do
        before(:each) do
          token    = JWT.encode({ user: admin.id }, ENV['AUTH_SECRET'], 'HS256')
          @headers = @headers.merge("Authorization" => "Bearer #{token}")
        end

        it 'Returns error object when the impact cannot be created by admin' do
          post '/impacts', params: {"impact": { "name": "" }}, headers: @headers
          expect(status).to eq(422)
          expect(body).to   eq(error.to_json)
        end

        it 'Returns success object when the impact was seccessfully created by admin' do
          post '/impacts', params: {"impact": { "name": "Impact one", "impact_value": "Lorem ipsum.." }},
                           headers: @headers
          expect(status).to eq(201)
          expect(body).to   eq({ messages: [{ status: 201, title: 'Impact successfully created!' }] }.to_json)
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

        it 'Do not allows to create impact by not admin user' do
          post '/impacts', params: {"impact": { "name": "Impact one", "impact_value": "Lorem ipsum.." }},
                           headers: @headers_user
          expect(status).to eq(401)
          expect(body).to   eq(error_unauthorized.to_json)
        end
      end
    end

    context 'Edit impacts' do
      let!(:error) { { errors: [{ status: 422, title: "impact_value can't be blank" }]}}

      describe 'For admin user' do
        before(:each) do
          token    = JWT.encode({ user: admin.id }, ENV['AUTH_SECRET'], 'HS256')
          @headers = @headers.merge("Authorization" => "Bearer #{token}")
        end

        it 'Returns error object when the impact cannot be updated by admin' do
          patch "/impacts/#{impact.id}", params: {"impact": { "name": "", "impact_value": "" }}, headers: @headers
          expect(status).to eq(422)
          expect(body).to   eq(error.to_json)
        end

        it 'Returns success object when the impact was seccessfully updated by admin' do
          patch "/impacts/#{impact.id}", params: {"impact": { "name": "Impact one", "impact_value": "Lorem ipsum.." }},
                                         headers: @headers
          expect(status).to eq(200)
          expect(body).to   eq({ messages: [{ status: 200, title: 'Impact successfully updated!' }] }.to_json)
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

        it 'Do not allows to update impact by not admin user' do
          patch "/impacts/#{impact.id}", params: {"impact": { "name": "Impact one", "impact_value": "Lorem ipsum.." }},
                                         headers: @headers_user
          expect(status).to eq(401)
          expect(body).to   eq(error_unauthorized.to_json)
        end
      end
    end

    context 'Delete impacts' do
      describe 'For admin user' do
        before(:each) do
          token    = JWT.encode({ user: admin.id }, ENV['AUTH_SECRET'], 'HS256')
          @headers = @headers.merge("Authorization" => "Bearer #{token}")
        end

        it 'Returns success object when the impact was seccessfully deleted by admin' do
          delete "/impacts/#{impact.id}", headers: @headers
          expect(status).to eq(200)
          expect(body).to   eq({ messages: [{ status: 200, title: 'Impact successfully deleted!' }] }.to_json)
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

        it 'Do not allows to delete impact by not admin user' do
          delete "/impacts/#{impact.id}", headers: @headers_user
          expect(status).to eq(401)
          expect(body).to   eq(error_unauthorized.to_json)
        end
      end
    end
  end
end
