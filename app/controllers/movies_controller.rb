class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = Movie.ratings  #['G','PG','PG-13','R']

    if params[:ratings].nil? 
            @ratings = @all_ratings
        else
            @ratings = params[:ratings].keys
    end   

    @hilite_title   = "" 
    @hilite_release = ""
    if params[:sort].nil?
        @movies = Movie.where(:rating => @ratings)
      elsif params[:sort] == 'title'
              @movies = Movie.where(rating: @ratings).order(:title)
              @hilite_title = "hilite"
            elsif params[:sort] == 'release'
              @movies = Movie.where(rating: @ratings).order(:release_date)
              @hilite_release = "hilite"   
    end    
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

end
