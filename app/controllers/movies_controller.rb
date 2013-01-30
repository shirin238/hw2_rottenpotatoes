class MoviesController < ApplicationController

  def initialize
    super
    @all_ratings = Movie.all_ratings
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
   
    @sort_by = params[:sort_by] || session[:sort_by]
    @ratings = params[:ratings]

    case @sort_by
      when 'title'
        ordering,@title_header = {:order => :title}, 'hilite'
      when 'release_date'
        ordering,@date_header = {:order => :release_date}, 'hilite'
    end

    @selected_ratings = params[:ratings] || session[:ratings] || {}

    if @selected_ratings == {}
      @selected_ratings = Hash[@all_ratings.map {|rating| [rating, rating]}]
    end

    if params[:sort_by] != session[:sort_by] or params[:ratings] != session[:ratings]
      session[:sort_by] = @sort_by
      session[:ratings] = @selected_ratings
      redirect_to :sort_by => @sort_by, :ratings => @selected_ratings and return
    end

    @movies = Movie.where(:rating => @selected_ratings.keys).order(@sort_by)

  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

  def search_tmdb
    flash[:warning] = "'#{params[:search_terms]}' was not found in TMDb."
    redirect_to movies_path
  end


end
