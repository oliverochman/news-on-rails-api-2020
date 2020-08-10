class Api::V1::ArticlesController < ApplicationController
  def index
    if params['category']
      articles = Article.where(category: params['category'])
    else
      articles = Article.all
    end
    render json: articles, each_serializer: ArticlesIndexSerializer
  rescue
    render json: {message: "Unfortunatly this category doesn't exist."}, status: 422
  end
  
  def show
    article = Article.find(params[:id])
      render json: article, serializer: ArticleShowSerializer
  rescue
      render json: {message: "Unfortunatly the article you were looking for could not be found."}, status: 422
  end

  def create
    article = Article.create(article_params)
    if article.persisted? && attach_image(article)
      render json: { message: "Article successfully created" }
    else
      binding.pry
    end
  end

  private

  def attach_image(article)
    params_image = params[:article][:image]
    if params_image.present?
      DecodeService.attach_image(params_image, article.image)
    end
  end
  
  def article_params
    params.require(:article).permit(:title, :category, :lead, :content)
  end
end
