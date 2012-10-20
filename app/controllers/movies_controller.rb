class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = Movie.ratings  #['G','PG','PG-13','R']

    if params[:ratings].nil? 
            if session[:ratings].nil?
                    @ratings = @all_ratings 
                else
                    @ratings = session[:ratings].keys
            end        
        else
            @ratings = params[:ratings].keys
    end   
    @checked_ratings = Hash[@ratings.map {|k| [k,1]}]
    session[:ratings]=@checked_ratings

    @hilite_title   = "" 
    @hilite_release = ""

    if params[:sort].nil? && params[:ratings].nil?    # daca nu pun asta intra in infinite loop
          if session[:sort].nil?                      # pentru ratinguri nu intreb PENTRU CA SUNT INTOTDEAUNA
                  #@movies = Movie.where(rating: @ratings)
                  flash.keep
                  redirect_to movies_path( ratings: session[:ratings])
              else
                  #@movies = Movie.where(rating: @ratings).order(session[:sort]) 
                  flash.keep
                  redirect_to movies_path( sort: session[:sort], ratings: session[:ratings])    
              end         
      elsif params[:sort] == 'title'
                @movies = Movie.where(rating: @ratings).order(:title)
                @hilite_title = "hilite"
                session[:sort] = 'title'
            elsif params[:sort] == 'release'
                      @movies = Movie.where(rating: @ratings).order(:release_date)
                      @hilite_release = "hilite"
                      session[:sort] = 'release' 
                  else 
                      @movies = Movie.where(rating: @ratings)     
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
