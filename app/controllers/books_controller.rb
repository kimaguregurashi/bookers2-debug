class BooksController < ApplicationController
  
  before_action :ensure_correct_user, only: [:edit, :update, :destroy]
  before_action :authenticate_user!

  def show
    @book = Book.find(params[:id])
    @book_new = Book.new
    @user = @book.user
    @book_comment = BookComment.new
  end

  def index
    to = Time.current.at_end_of_day
  from = (to - 6.day).at_beginning_of_day
  @books = Book.includes(:favorites).sort_by { |book| -book.favorites.where(created_at: from...to).count }
  
  @book = Book.new
    @book = Book.new
  end

  def create
    @book = Book.new(book_params)
    @book.user_id = current_user.id
    if @book.save
      redirect_to book_path(@book), notice: "You have created book successfully."
    else
      @books = Book.all
      render :index
    end
  end

  def edit
     unless @book.user == current_user
    redirect_to books_path
     end
  end

  def update
    if @book.update(book_params)
      redirect_to book_path(@book), notice: "You have updated book successfully."
    else
      render :edit
    end
  end

  def destroy
    @book.destroy
    redirect_to books_path
  end

  private
  
  def ensure_correct_user
      @book = Book.find(params[:id])
      unless @book.user == current_user
        redirect_to books_path
      end
  end

  def book_params
    params.require(:book).permit(:title, :body)
  end
end
