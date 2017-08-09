require 'acceptance_helper'

module V1
  describe 'Comments', type: :request do
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

    let!(:project)   { FactoryGirl.create(:project, name: '00 Project one', project_type: 'StudyCase') }

    let!(:comments) {
      comment = FactoryGirl.create(:comment, commentable: project, user: user)
      comments = []
      comments << FactoryGirl.create_list(:comment, 4, commentable: project, user: editor)
      comments << FactoryGirl.create(:comment, commentable: project, user: publisher)
      Comment.all.each(&:reload)
    }

    context 'Do not show comments list for not admin and publisher user' do
      it 'Get comments list' do
        get '/comments', headers: @headers
        expect(status).to eq(401)
      end
    end

    context 'Show comments list for admin user' do
      before(:each) do
        token    = JWT.encode({ user: admin.id }, ENV['AUTH_SECRET'], 'HS256')
        @headers = @headers.merge("Authorization" => "Bearer #{token}")
      end

      it 'Get comments list' do
        get '/comments', headers: @headers
        expect(status).to eq(200)
      end
    end

    context 'Pagination and sort for comments' do
      before(:each) do
        token    = JWT.encode({ user: publisher.id }, ENV['AUTH_SECRET'], 'HS256')
        @headers = @headers.merge("Authorization" => "Bearer #{token}")
      end

      it 'Show list of comments for first page with per pege param' do
        get '/comments?page[number]=1&page[size]=3', headers: @headers

        expect(status).to    eq(200)
        expect(json.size).to eq(3)
      end

      it 'Show list of comments for second page with per pege param' do
        get '/comments?page[number]=2&page[size]=3', headers: @headers

        expect(status).to    eq(200)
        expect(json.size).to eq(3)
      end

      it 'Show list of comments for sort by created_at' do
        get '/comments?sort=created_at', headers: @headers

        expect(status).to    eq(200)
        expect(json.size).to eq(6)
      end

      it 'Show list of comments for sort by created_at DESC' do
        get '/comments?sort=-created_at', headers: @headers

        expect(status).to    eq(200)
        expect(json.size).to eq(6)
      end
    end

    context 'Create projects' do
      let!(:error) { { errors: [{ status: 422, title: "body can't be blank" }]}}

      describe 'Logged user' do
        before(:each) do
          token    = JWT.encode({ user: user.id }, ENV['AUTH_SECRET'], 'HS256')
          @headers = @headers.merge("Authorization" => "Bearer #{token}")
        end

        let(:study_case) { FactoryGirl.create(:study_case) }

        it 'Returns error object when the comment cannot be created' do
          post '/comments', params: {"comment": { "body": "", "commentable_type": "Project", "commentable_id": study_case.id }}, headers: @headers
          expect(status).to eq(422)
          expect(body).to   eq(error.to_json)
        end

        it 'Returns success object when the comment was seccessfully created by user' do
          post '/comments', params: {"comment": { "body": "Project one", "commentable_type": "Project", "commentable_id": study_case.id }},
                            headers: @headers
          expect(status).to                   eq(201)
          expect(body).to                     eq({ messages: [{ status: 201, title: 'Comment successfully created!' }] }.to_json)
          expect(study_case.comments.size).to eq(1)
        end
      end
    end
  end
end
