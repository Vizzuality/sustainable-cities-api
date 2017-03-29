require 'acceptance_helper'

module V1
  describe 'User can manage projects depending of the role', type: :request do
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

    let!(:business_model_1) { FactoryGirl.create(:business_model, name: 'Business model test', users: [editor, publisher]) }
    let!(:business_model_2) { FactoryGirl.create(:business_model, name: 'Business model test', users: [admin])             }
    let!(:study_case)       { FactoryGirl.create(:study_case,     name: 'Study case test',     users: [user])              }

    context 'Show study cases' do
      it 'Get study cases list for not logged users' do
        get '/study-cases', headers: @headers
        expect(status).to    eq(200)
        expect(json.size).to eq(1)
      end

      it 'Get specific study case for not logged users' do
        get "/study-cases/#{study_case.id}", headers: @headers
        expect(status).to eq(200)
      end

      describe 'For logged user' do
        before(:each) do
          token    = JWT.encode({ user: user.id }, ENV['AUTH_SECRET'], 'HS256')
          @headers = @headers.merge("Authorization" => "Bearer #{token}")
        end

        it 'Get study cases list for logged users' do
          get '/study-cases', headers: @headers
          expect(status).to    eq(200)
          expect(json.size).to eq(1)
        end

        it 'Get specific study case for logged users' do
          get "/study-cases/#{study_case.id}", headers: @headers
          expect(status).to eq(200)
        end
      end
    end

    context 'Show projects' do
      it 'Do not get projects list for not logged users' do
        get '/projects', headers: @headers
        expect(status).to eq(401)
      end

      it 'Do not get specific project for not logged users' do
        get "/projects/#{business_model_1.id}", headers: @headers
        expect(status).to eq(401)
      end

      describe 'For logged user' do
        before(:each) do
          token    = JWT.encode({ user: user.id }, ENV['AUTH_SECRET'], 'HS256')
          @headers = @headers.merge("Authorization" => "Bearer #{token}")
        end

        it 'Do not get projects list for logged users' do
          get '/projects', headers: @headers
          expect(status).to eq(401)
        end

        it 'Do not get specific project for logged users' do
          get "/projects/#{business_model_1.id}", headers: @headers
          expect(status).to eq(401)
        end
      end

      describe 'For logged editor' do
        before(:each) do
          token    = JWT.encode({ user: editor.id }, ENV['AUTH_SECRET'], 'HS256')
          @headers = @headers.merge("Authorization" => "Bearer #{token}")
        end

        it 'Do not get projects list for logged editor' do
          get '/projects', headers: @headers
          expect(status).to eq(401)
        end

        it 'Do not get specific project for logged editor' do
          get "/projects/#{business_model_2.id}", headers: @headers
          expect(status).to eq(401)
        end
      end

      describe 'For logged publisher' do
        before(:each) do
          token    = JWT.encode({ user: publisher.id }, ENV['AUTH_SECRET'], 'HS256')
          @headers = @headers.merge("Authorization" => "Bearer #{token}")
        end

        it 'Get projects list for logged publisher' do
          get '/projects', headers: @headers
          expect(status).to    eq(200)
          expect(json.size).to eq(3)
        end

        it 'Get specific project for logged publisher' do
          get "/projects/#{business_model_1.id}", headers: @headers
          expect(status).to eq(200)
        end
      end

      describe 'For logged admin' do
        before(:each) do
          token    = JWT.encode({ user: admin.id }, ENV['AUTH_SECRET'], 'HS256')
          @headers = @headers.merge("Authorization" => "Bearer #{token}")
        end

        it 'Get projects list for logged admin' do
          get '/projects', headers: @headers
          expect(status).to    eq(200)
          expect(json.size).to eq(3)
        end

        it 'Get specific project for logged admin' do
          get "/projects/#{business_model_1.id}", headers: @headers
          expect(status).to eq(200)
        end
      end
    end

    context 'Show business models' do
      it 'Do not get business models list for not logged users' do
        get '/business-models', headers: @headers
        expect(status).to eq(401)
      end

      it 'Do not get specific business model for not logged users' do
        get "/business-models/#{business_model_1.id}", headers: @headers
        expect(status).to eq(401)
      end

      describe 'For logged user' do
        before(:each) do
          token    = JWT.encode({ user: user.id }, ENV['AUTH_SECRET'], 'HS256')
          @headers = @headers.merge("Authorization" => "Bearer #{token}")
        end

        it 'Get empty business models list for logged users' do
          get '/business-models', headers: @headers
          expect(status).to    eq(200)
          expect(json.size).to eq(0)
        end

        it 'Do not get specific business model for logged users' do
          get "/business-models/#{business_model_1.id}", headers: @headers
          expect(status).to eq(401)
        end
      end

      describe 'For logged admin user' do
        before(:each) do
          token    = JWT.encode({ user: admin.id }, ENV['AUTH_SECRET'], 'HS256')
          @headers = @headers.merge("Authorization" => "Bearer #{token}")
        end

        it 'Get business models list for logged admin user' do
          get '/business-models', headers: @headers
          expect(status).to    eq(200)
          expect(json.size).to eq(2)
        end

        it 'Get specific business model for logged admin user' do
          get "/business-models/#{business_model_1.id}", headers: @headers
          expect(status).to eq(200)
        end
      end

      describe 'For logged editor user' do
        before(:each) do
          token    = JWT.encode({ user: editor.id }, ENV['AUTH_SECRET'], 'HS256')
          @headers = @headers.merge("Authorization" => "Bearer #{token}")
        end

        it 'Get business models list for editor users if owner' do
          get '/business-models', headers: @headers
          expect(status).to    eq(200)
          expect(json.size).to eq(1)
        end

        it 'Get specific business model for editor users if owner' do
          get "/business-models/#{business_model_1.id}", headers: @headers
          expect(status).to eq(200)
        end

        it 'Get specific business model for editor users if not owner' do
          get "/business-models/#{business_model_2.id}", headers: @headers
          expect(status).to eq(401)
        end
      end

      describe 'For logged publisher user' do
        before(:each) do
          token    = JWT.encode({ user: publisher.id }, ENV['AUTH_SECRET'], 'HS256')
          @headers = @headers.merge("Authorization" => "Bearer #{token}")
        end

        it 'Get business models list for publisher users' do
          get '/business-models', headers: @headers
          expect(status).to    eq(200)
          expect(json.size).to eq(2)
        end

        it 'Get specific business model for publisher users' do
          get "/business-models/#{business_model_1.id}", headers: @headers
          expect(status).to eq(200)
        end

        it 'Get specific business model for publisher users if not owner' do
          get "/business-models/#{business_model_2.id}", headers: @headers
          expect(status).to eq(200)
        end
      end
    end

    context 'Create projects' do
      let!(:error) { { errors: [{ status: 422, title: "name can't be blank" }]}}

      describe 'For admin user' do
        before(:each) do
          token    = JWT.encode({ user: admin.id }, ENV['AUTH_SECRET'], 'HS256')
          @headers = @headers.merge("Authorization" => "Bearer #{token}")
        end

        it 'Returns error object when the project cannot be created by admin' do
          post '/projects', params: {"project": { "name": "", "project_type": "StudyCase" }}, headers: @headers
          expect(status).to eq(422)
          expect(body).to   eq(error.to_json)
        end

        it 'Returns success object when the project was seccessfully created by admin' do
          post '/projects', params: {"project": { "name": "Project one", "project_type": "StudyCase", "user_ids": [editor.id], "is_active": true }},
                            headers: @headers
          expect(status).to                                 eq(201)
          expect(body).to                                   eq({ messages: [{ status: 201, title: 'Project successfully created!' }] }.to_json)
          expect(editor.reload.projects.last.activated?).to eq(true)
        end
      end

      describe 'For user' do
        before(:each) do
          token         = JWT.encode({ user: user.id }, ENV['AUTH_SECRET'], 'HS256')
          @headers_user = @headers.merge("Authorization" => "Bearer #{token}")
        end

        let!(:error_unauthorized) {
          { errors: [{ status: '401', title: 'You are not authorized to access this page.' }] }
        }

        it 'Do not allows to create study case by user' do
          post '/projects', params: {"project": { "name": "Project one", "project_type": "StudyCase" }},
                            headers: @headers_user
          expect(status).to eq(401)
          expect(body).to   eq(error_unauthorized.to_json)
        end

        it 'Do not allows to create business model by user' do
          post '/projects', params: {"project": { "name": "Project one", "project_type": "BusinessModel" }},
                            headers: @headers_user
          expect(status).to eq(401)
        end
      end

      describe 'For editor' do
        before(:each) do
          token         = JWT.encode({ user: editor.id }, ENV['AUTH_SECRET'], 'HS256')
          @headers_user = @headers.merge("Authorization" => "Bearer #{token}")
        end

        let!(:error_unauthorized) {
          { errors: [{ status: '401', title: 'Unauthorized to create a study case.' }] }
        }

        it 'Do not allows to create study case by editor' do
          post '/projects', params: {"project": { "name": "Project one", "project_type": "StudyCase" }},
                            headers: @headers_user
          expect(status).to eq(401)
          expect(body).to   eq(error_unauthorized.to_json)
        end

        it 'Allows to create business model by editor ignore is active option(only accessible by admin)' do
          post '/projects', params: {"project": { "name": "Project one", "project_type": "BusinessModel", "is_active": true }},
                            headers: @headers_user
          expect(status).to                                   eq(201)
          expect(editor.reload.projects.last.deactivated?).to eq(true)
        end
      end

      describe 'For publisher' do
        before(:each) do
          token         = JWT.encode({ user: publisher.id }, ENV['AUTH_SECRET'], 'HS256')
          @headers_user = @headers.merge("Authorization" => "Bearer #{token}")
        end

        let!(:error_unauthorized) {
          { errors: [{ status: '401', title: 'Unauthorized to create a study case.' }] }
        }

        it 'Do not allows to create study case by publisher' do
          post '/projects', params: {"project": { "name": "Project one", "project_type": "StudyCase" }},
                            headers: @headers_user
          expect(status).to eq(401)
          expect(body).to   eq(error_unauthorized.to_json)
        end

        it 'Allows to create business model by publisher ignore is active option(only accessible by admin)' do
          post '/projects', params: {"project": { "name": "Project one", "project_type": "BusinessModel", "is_active": true }},
                            headers: @headers_user
          expect(status).to                                    eq(201)
          expect(publisher.reload.projects.last.activated?).to eq(true)
        end
      end
    end

    context 'Edit projects' do
      let!(:category) { FactoryGirl.create(:category)        }
      let!(:country)  { FactoryGirl.create(:country)         }
      let!(:city)     { FactoryGirl.create(:city)            }
      let!(:bme)      { FactoryGirl.create(:bme)             }
      let!(:source)   { FactoryGirl.create(:external_source) }
      let!(:impact)   { FactoryGirl.create(:impact)          }

      let!(:error)    { { errors: [{ status: 422, title: "name can't be blank" }]}}

      describe 'For admin user' do
        before(:each) do
          token    = JWT.encode({ user: admin.id }, ENV['AUTH_SECRET'], 'HS256')
          @headers = @headers.merge("Authorization" => "Bearer #{token}")
        end

        it 'Returns error object when the study_case cannot be updated by admin' do
          patch "/projects/#{study_case.id}", params: {"project": { "name": "" }}, headers: @headers
          expect(status).to eq(422)
          expect(body).to   eq(error.to_json)
        end

        it 'Returns success object when the study_case was seccessfully updated by admin' do
          patch "/projects/#{study_case.id}", params: {"project": { "project_type": "StudyCase",
                                                                    "name": "Project one",
                                                                    "situation": "Lorem ipsum..",
                                                                    "solution": "Lorem ipsum..",
                                                                    "category_id": category.id,
                                                                    "country_id": country.id,
                                                                    "operational_year": DateTime.now,
                                                                    "user_ids": [editor.id, user.id],
                                                                    "city_ids": [city.id],
                                                                    "bme_ids": [bme.id],
                                                                    "external_source_ids": [source.id],
                                                                    "impact_ids": [impact.id],
                                                                    "is_active": true }},
                                              headers: @headers
          expect(status).to eq(200)
          expect(body).to   eq({ messages: [{ status: 200, title: 'Project successfully updated!' }] }.to_json)
        end
      end

      describe 'For editor user' do
        before(:each) do
          token         = JWT.encode({ user: editor.id }, ENV['AUTH_SECRET'], 'HS256')
          @headers_user = @headers.merge("Authorization" => "Bearer #{token}")
        end

        let!(:error_unauthorized) {
          { errors: [{ status: '401', title: 'You are not authorized to access this page.' }] }
        }

        it 'Do not allows to update study_case by editor if not owner' do
          patch "/projects/#{study_case.id}", params: {"project": { "name": "Project one" }},
                                              headers: @headers_user
          expect(status).to eq(401)
          expect(body).to   eq(error_unauthorized.to_json)
        end
      end

      describe 'For user' do
        before(:each) do
          token         = JWT.encode({ user: user.id }, ENV['AUTH_SECRET'], 'HS256')
          @headers_user = @headers.merge("Authorization" => "Bearer #{token}")
        end

        let!(:error_unauthorized) {
          { errors: [{ status: '401', title: 'You are not authorized to access this page.' }] }
        }

        it 'Allows to update study_case by user if owner' do
          patch "/projects/#{study_case.id}", params: {"project": { "name": "Project one" }},
                                              headers: @headers_user
          expect(status).to eq(200)
        end
      end
    end

    context 'Delete projects' do
      let!(:error_unauthorized) {
        { errors: [{ status: '401', title: 'You are not authorized to access this page.' }] }
      }

      describe 'For admin user' do
        before(:each) do
          token    = JWT.encode({ user: admin.id }, ENV['AUTH_SECRET'], 'HS256')
          @headers = @headers.merge("Authorization" => "Bearer #{token}")
        end

        it 'Returns success object when the study_case was seccessfully deleted by admin' do
          delete "/projects/#{study_case.id}", headers: @headers
          expect(status).to eq(200)
          expect(body).to   eq({ messages: [{ status: 200, title: 'Project successfully deleted!' }] }.to_json)
        end
      end

      describe 'For editor if not owner' do
        before(:each) do
          token         = JWT.encode({ user: editor.id }, ENV['AUTH_SECRET'], 'HS256')
          @headers_user = @headers.merge("Authorization" => "Bearer #{token}")
        end

        it 'Do not allows to delete study_case by editor if not owner' do
          delete "/projects/#{study_case.id}", headers: @headers_user
          expect(status).to eq(401)
          expect(body).to   eq(error_unauthorized.to_json)
        end
      end

      describe 'For user if one of the owners' do
        before(:each) do
          token         = JWT.encode({ user: user.id }, ENV['AUTH_SECRET'], 'HS256')
          @headers_user = @headers.merge("Authorization" => "Bearer #{token}")
        end

        it 'Do not allows to delete study_case by user' do
          delete "/projects/#{study_case.id}", headers: @headers_user
          expect(status).to eq(401)
          expect(body).to   eq(error_unauthorized.to_json)
        end
      end
    end
  end
end
