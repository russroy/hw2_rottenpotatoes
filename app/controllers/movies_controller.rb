class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    if (session[:view_settings]  && !(params[:ratings] || params[:sort]))
      puts "*******\n"+session[:view_settings].inspect+"\n****************\n"
      flash.keep
      redirect_to session[:view_settings]
    end
    params[:sort] ||= "id"
    sort = params[:sort]
    if params.include? 'ratings'
      ratings = params[:ratings].keys
      @movies = Movie.order(sort).find(:all, :conditions => {:rating => ratings})
    else
      @movies = Movie.order(sort)
    end
    session[:view_settings] = movies_path(params.slice(:ratings, :sort))

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
