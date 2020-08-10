RSpec.describe "GET /v1/articles", type: :request do
  let!(:article) { create(:article, title: 'The first article', lead: 'This is the first article lead', content: 'This is the first article content', category: "sports") }

  describe 'successfully gets article' do
    before do
      get "/api/v1/articles/#{article.id}"
    end

    it 'responds with 200 status' do
      expect(response).to have_http_status 200
    end

    it 'shows article content' do
      expect(response_json['article']['content']).to eq 'This is the first article content'
    end

    it 'shows article category' do
      expect(response_json['article']['category']).to eq 'sports'
    end
  end

  describe 'unsuccessfully gets article' do
    before do
      get "/api/v1/articles/3"
    end

  it 'responds with 422 status' do
    expect(response).to have_http_status 422
    end

  it 'responds with error message' do
    expect(response_json["message"]).to eq 'Unfortunatly the article you were looking for could not be found.'
    end
  end
end