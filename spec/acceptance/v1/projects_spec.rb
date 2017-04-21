require 'acceptance_helper'

module V1
  describe 'Projects', type: :request do
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

    let!(:project)   { FactoryGirl.create(:project, name: '00 Project one') }

    context 'Do not show projects for not admin user' do
      it 'Get projects list' do
        get '/projects', headers: @headers
        expect(status).to eq(401)
      end

      it 'Get specific project' do
        get "/projects/#{project.id}", headers: @headers
        expect(status).to eq(401)
      end
    end

    context 'Show projects for admin user' do
      before(:each) do
        token    = JWT.encode({ user: admin.id }, ENV['AUTH_SECRET'], 'HS256')
        @headers = @headers.merge("Authorization" => "Bearer #{token}")
      end

      it 'Get projects list' do
        get '/projects', headers: @headers
        expect(status).to eq(200)
      end

      it 'Get specific project' do
        get "/projects/#{project.id}", headers: @headers
        expect(status).to eq(200)
      end
    end

    context 'Pagination and sort for projects' do
      before(:each) do
        token    = JWT.encode({ user: admin.id }, ENV['AUTH_SECRET'], 'HS256')
        @headers = @headers.merge("Authorization" => "Bearer #{token}")
      end

      let!(:projects) {
        projects = []
        projects << FactoryGirl.create_list(:project, 4)
        projects << FactoryGirl.create(:project, name: 'ZZZ Next first one')
      }

      it 'Show list of projects for first page with per pege param' do
        get '/projects?page[number]=1&page[size]=3', headers: @headers

        expect(status).to    eq(200)
        expect(json.size).to eq(3)
      end

      it 'Show list of projects for second page with per pege param' do
        get '/projects?page[number]=2&page[size]=3', headers: @headers

        expect(status).to    eq(200)
        expect(json.size).to eq(3)
      end

      it 'Show list of projects for sort by name' do
        get '/projects?sort=name', headers: @headers

        expect(status).to                        eq(200)
        expect(json.size).to                     eq(6)
        expect(json[0]['attributes']['name']).to eq('00 Project one')
      end

      it 'Show list of projects for sort by name DESC' do
        get '/projects?sort=-name', headers: @headers

        expect(status).to                        eq(200)
        expect(json.size).to                     eq(6)
        expect(json[0]['attributes']['name']).to eq('ZZZ Next first one')
      end
    end

    context 'Create projects' do
      let!(:error) { { errors: [{ status: 422, title: "name can't be blank" }]}}

      describe 'For admin user' do
        before(:each) do
          token    = JWT.encode({ user: admin.id }, ENV['AUTH_SECRET'], 'HS256')
          @headers = @headers.merge("Authorization" => "Bearer #{token}")
        end

        let(:city) { FactoryGirl.create(:city) }

        it 'Returns error object when the project cannot be created by admin' do
          post '/projects', params: {"project": { "name": "", "project_type": "BusinessModel" }}, headers: @headers
          expect(status).to eq(422)
          expect(body).to   eq(error.to_json)
        end

        it 'Returns success object when the project was seccessfully created by admin' do
          post '/projects', params: {"project": { "name": "Project one", "project_type": "BusinessModel", "city_ids": [city.id] }},
                            headers: @headers
          expect(status).to                  eq(201)
          expect(body).to                    eq({ messages: [{ status: 201, title: 'Project successfully created!' }] }.to_json)
          expect(City.last.projects.size).to eq(1)
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

        it 'Allows to create project by publisher user' do
          post '/projects', params: {"project": { "name": "Project one", "project_type": 'BusinessModel' }},
                            headers: @headers_user
          expect(status).to eq(201)
        end
      end

      describe 'User can upload attachment to project' do
        let!(:photo_data) {
          "data:image/jpeg;base64,#{Base64.encode64(File.read(File.join(Rails.root, 'spec', 'support', 'files', 'image.jpg')))}"
        }

        let!(:document_data) {
          "data:application/pdf;base64,#{Base64.encode64(File.read(File.join(Rails.root, 'spec', 'support', 'files', 'doc.pdf')))}"
        }

        before(:each) do
          token         = JWT.encode({ user: editor.id }, ENV['AUTH_SECRET'], 'HS256')
          @headers_user = @headers.merge("Authorization" => "Bearer #{token}")
        end

        it 'Upload image and returns success object when the project was seccessfully created' do
          post '/projects', params: {"project": { "name": "Project one with photo", "project_type": 'BusinessModel', "photos_attributes": [{"name": "project photo", "attachment": photo_data }]}},
                            headers: @headers_user
          expect(status).to eq(201)
          expect(body).to   eq({ messages: [{ status: 201, title: 'Project successfully created!' }] }.to_json)
          expect(Project.find_by(name: 'Project one with photo').photos.first.attachment.present?).to be(true)
        end

        it 'Upload document and returns success object when the project was seccessfully created' do
          post '/projects', params: {"project": { "name": "Project one with document", "project_type": 'BusinessModel', "documents_attributes": [{"name": "project doc", "attachment": document_data }]}},
                            headers: @headers_user
          expect(status).to eq(201)
          expect(body).to   eq({ messages: [{ status: 201, title: 'Project successfully created!' }] }.to_json)
          expect(Project.find_by(name: 'Project one with document').documents.first.attachment.present?).to be(true)
        end
      end
    end

    context 'Edit projects' do
      let!(:error) { { errors: [{ status: 422, title: "name can't be blank" }]}}

      describe 'For admin user' do
        before(:each) do
          token    = JWT.encode({ user: admin.id }, ENV['AUTH_SECRET'], 'HS256')
          @headers = @headers.merge("Authorization" => "Bearer #{token}")
        end

        it 'Returns error object when the project cannot be updated by admin' do
          patch "/projects/#{project.id}", params: {"project": { "name": "" }}, headers: @headers
          expect(status).to eq(422)
          expect(body).to   eq(error.to_json)
        end

        it 'Returns success object when the project was seccessfully updated by admin' do
          patch "/projects/#{project.id}", params: {"project": { "name": "Project one"}},
                                           headers: @headers
          expect(status).to eq(200)
          expect(body).to   eq({ messages: [{ status: 200, title: 'Project successfully updated!' }] }.to_json)
        end
      end

      describe 'For not admin user' do
        before(:each) do
          token         = JWT.encode({ user: editor.id }, ENV['AUTH_SECRET'], 'HS256')
          @headers_user = @headers.merge("Authorization" => "Bearer #{token}")
        end

        let!(:error_unauthorized) {
          { errors: [{ status: '401', title: 'You are not authorized to access this page.' }] }
        }

        it 'Do not allows to update project by not admin user' do
          patch "/projects/#{project.id}", params: {"project": { "name": "Project one" }},
                                           headers: @headers_user
          expect(status).to eq(401)
          expect(body).to   eq(error_unauthorized.to_json)
        end
      end
    end

    context 'Delete projects' do
      describe 'For admin user' do
        before(:each) do
          token    = JWT.encode({ user: admin.id }, ENV['AUTH_SECRET'], 'HS256')
          @headers = @headers.merge("Authorization" => "Bearer #{token}")
        end

        it 'Returns success object when the project was seccessfully deleted by admin' do
          delete "/projects/#{project.id}", headers: @headers
          expect(status).to eq(200)
          expect(body).to   eq({ messages: [{ status: 200, title: 'Project successfully deleted!' }] }.to_json)
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

        it 'Do not allows to delete project by not admin user' do
          delete "/projects/#{project.id}", headers: @headers_user
          expect(status).to eq(401)
          expect(body).to   eq(error_unauthorized.to_json)
        end
      end
    end
  end
end
