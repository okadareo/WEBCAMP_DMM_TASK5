class SearchController < ApplicationController
  def search
    @keyword = params[:keyword]
    @model = params[:model]
    @search = params[:search]
    if @model == "Book"
      case @search
      when "match"
        @result = Book.where("title LIKE ?","#{@keyword}")
        @result = Book.where("body LIKE ?","#{@keyword}")
      when "forward"
        @result = Book.where("title LIKE ?","#{@keyword}%")
        @result = Book.where("body LIKE ?","#{@keyword}%")
      when "backward"
        @result = Book.where("title LIKE ?","%#{@keyword}")
        @result = Book.where("body LIKE ?","%#{@keyword}")
      when "partical"
        @result = Book.where("title LIKE ?","%#{@keyword}%")
        @result = Book.where("body LIKE ?","%#{@keyword}%")
      end
    elsif @model == "User"
      case @search
      when "match"
        @results = User.where("name LIKE ?","#{@keyword}")
      when "forward"
        @results = User.where("name LIKE ?","#{@keyword}%")
      when "backward"
        @results = User.where("name LIKE ?","%#{@keyword}")
      when "partical"
        @results = User.where("name LIKE ?","%#{@keyword}%")
      end
    end
  end
end

