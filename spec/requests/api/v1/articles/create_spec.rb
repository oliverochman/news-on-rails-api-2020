#we want to create an article, only a journalist should be able to create an article
#Journalist has many articles and article belong to journalist

RSpec.describe "POST /v1/articles", type: :request do
  let(:journalist) { create(:user, role: 'journalist') }
  let(:journalist_credentials) { journalist.create_new_auth_token }
  let(:journalist_headers) { { HTTP_ACCEPT: 'application/json' }.merge!(journalist_credentials) }

  describe 'successfully with vaild params and headers' do 
    before do 
      post '/api/v1/articles',
      params: {
        title: 'Scrum Lord',
        lead: 'All hail thy scrum lord',
        content: 'A good scrum lord will save us',
        category: 'lifestyle'  
      }, headers: journalist_headers 
    end
    
    it 'is expected to return 200 response status' do
      expect(response).to have_http_status 200
    end

    it 'is expected to return success message' do
      expect(response_json['message']).to eq 'Articles successfully created'
    end

    it 'is expected to create article' do
      article = Article.last
      expect(article.title).to eq 'Scrum Lord'
    end

    it 'article is expected to be associated with journalist' do
      expect(journalist.articles.first.lead).to eq 'All hail thy scrum lord'
    end
  end

  describe "unsuccessfully with " do
    describe "invalid params " do
      before do 
        post '/api/v1/articles',
        params: {
          title: '',
          lead: '',
          content: '',
          category: ''  
        }, headers: journalist_headers 
      end

      it 'is expected to return 400 response status' do
        expect(response).to have_http_status 422
      end
  
      it 'is expected to return error message' do
        expect(response_json['message']).to eq "Title can't be blank, Lead can't be blank, Content can't be blank, and Category can't be blank"
      end
    end

    describe "non-registered user " do
      before do 
        post '/api/v1/articles',
        params: {
          title: 'Scrum Lord',
          lead: 'All hail thy scrum lord',
          content: 'A good scrum lord will save us',
          category: 'lifestyle'  
        } 
      end

      it 'is expected to return 401 response status' do
        expect(response).to have_http_status 401
      end
  
      it 'is expected to return error message' do
        expect(response_json['errors'].first).to eq 'You need to sign in or sign up before continuing.'
      end
    end
    
    describe "user that is not journalist" do
      let(:unauthorized_user) { create(:user, role: 'registered') }
      let(:unauthorized_user_credentials) { unauthorized_user.create_new_auth_token }
      let(:unauthorized_headers) { { HTTP_ACCEPT: 'application/json' }.merge!(unauthorized_user_credentials) }

      before do 
        post '/api/v1/articles',
        params: {
          title: 'Scrum Lord',
          lead: 'All hail thy scrum lord',
          content: 'A good scrum lord will save us',
          category: 'lifestyle'  
        }, headers: unauthorized_headers
      end

      it 'is expected to return 401 response status' do
        expect(response).to have_http_status 401
      end
  
      it 'is expected to return error message' do
        expect(response_json['message']).to eq 'You are not authorized to access this action'
      end
    end
    
  end
end