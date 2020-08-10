RSpec.describe "POST /v1/articles", type: :request do
  let (:image) {
    {
      type: 'application/json',
      encoder: 'name=iphone_picture.jpg:base64',
      data: 'cxjierwngpewrggfh9werpnbejnigvnqgerpjf0kqkw',
      extension: 'jpg'
    }
  }

  describe 'successfully with correct params' do
    before do
      post '/api/v1/articles',
      params: {
        article: {
          title: 'Back from vacation',
          lead: 'Back to reality',
          content: 'Life is wondefull',
          category: 'sports',
          image: image
        }
      }
    end

    it 'expetced to return a 200 response' do
      expect(response.status).to eq 200
    end

    it 'expected to return success message' do
      expect(response_json["message"]).to eq "Article successfully created"
    end
  end
end