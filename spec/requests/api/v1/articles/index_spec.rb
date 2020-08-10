RSpec.describe "GET /v1/articles", type: :request do
  describe 'successfully gets articles' do
    let!(:article_1) { create(:article, title: 'The first article', lead: 'This is the first article lead', category: 'economy') }
    let!(:article_2) { create(:article, title: 'The second article', lead: 'This is the second article lead', category: 'sports') }
    let!(:article_3) { create(:article, title: 'The third article', lead: 'This is the third article lead', category: 'lifestyle') }

    before do
      get '/api/v1/articles'
    end

    it 'should return a 200 response' do
      expect(response).to have_http_status 200
    end

    it 'should return articles' do
      expect(response_json["articles"].count).to eq 3
    end

    it 'should return first article title' do
      expect(response_json["articles"].first["title"]).to eq "The first article"
    end

    it 'should return third article lead' do
      expect(response_json["articles"].last["lead"]).to eq "This is the third article lead"
    end

    it 'article 1 should have category economy' do
      expect(response_json["articles"].first["category"]).to eq "economy"
    end

    it 'article 2 should have category sports' do
      expect(response_json["articles"].second["category"]).to eq "sports"
    end

    it 'article 3 should have category lifestyle' do
      expect(response_json["articles"].last["category"]).to eq "lifestyle"
    end
  end

  describe 'no articles has been added' do
    before do
      get '/api/v1/articles'
    end

    it 'should have no articles on page' do
      expect(response_json["articles"]).to eq []
    end
  end
end