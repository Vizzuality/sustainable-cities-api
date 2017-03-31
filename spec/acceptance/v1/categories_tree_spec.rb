require 'acceptance_helper'

module V1
  describe 'Categories Tree and titled categories', type: :request do
    before(:each) do
      @webuser = create(:webuser)
      token    = JWT.encode({ user: @webuser.id }, ENV['AUTH_SECRET'], 'HS256')

      @headers = {
        "ACCEPT" => "application/json",
        "HTTP_SC_API_KEY" => "Bearer #{token}"
      }
    end

    let!(:categories) {
      category = FactoryGirl.create(:category, name: '00 Category one', category_type: 'Solution')
      categories = []
      categories << FactoryGirl.create_list(:category, 4, category_type: 'Solution', parent: category)
      categories << FactoryGirl.create(:category, name: 'ZZZ Next first one', category_type: 'Timing')
      Category.all.each(&:reload)
    }

    context 'Show categories tree' do
      it 'Get categories list' do
        get '/categories-tree?sort=name', headers: @headers
        expect(status).to    eq(200)
        expect(json.size).to eq(2)

        expect(json[0]['attributes']['children'].size).to eq(4)
        expect(json[1]['attributes']['children']).to      eq(nil)
      end

      it 'Get specific category tree' do
        get "/categories-tree?type=Solution", headers: @headers
        expect(status).to    eq(200)
        expect(json.size).to eq(1)
        expect(json[0]['attributes']['children'].size).to eq(4)
      end

      it 'Get specific category using specific path' do
        get "/solution-categories", headers: @headers
        expect(status).to    eq(200)
        expect(json.size).to eq(5)
      end
    end

    context 'Pagination and sort for categories' do
      it 'Show list of categories for first page with per pege param' do
        get '/categories-tree?page[number]=1&page[size]=1', headers: @headers

        expect(status).to    eq(200)
        expect(json.size).to eq(1)
      end

      it 'Show list of categories for second page with per pege param' do
        get '/categories-tree?page[number]=2&page[size]=1', headers: @headers

        expect(status).to    eq(200)
        expect(json.size).to eq(1)
      end

      it 'Show list of categories for sort by name' do
        get '/categories-tree?sort=name', headers: @headers

        expect(status).to    eq(200)
        expect(json.size).to eq(2)
        expect(json[0]['attributes']['name']).to eq('00 Category one')
      end

      it 'Show list of categories for sort by name DESC' do
        get '/categories-tree?sort=-name', headers: @headers

        expect(status).to    eq(200)
        expect(json.size).to eq(2)
        expect(json[0]['attributes']['name']).to eq('ZZZ Next first one')
      end
    end
  end
end
