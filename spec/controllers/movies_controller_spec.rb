require 'spec_helper'

describe MoviesController do
  describe 'finding similar movies' do
    it 'should call the model method that find movies with the same director' do
      movie = mock(:director => 'dir', :id => 1, :title => 'aladdin')
      Movie.should_receive(:find_by_id).with("1").and_return(movie)
      #debugger
      Movie.should_receive(:find_similar).with(movie).and_return([movie])
      #debugger
      get :similar, {:id => 1}
    end
    describe 'after a valid search' do
      before :each do
        @result = [mock('movie', :director => 'director', :title => 'title')]
        Movie.stub(:find_by_id).with("1").and_return(@result[0])
        Movie.stub(:find_similar).and_return(@result)
        get :similar, {:id => 1}
      end
      it 'should select the Similar Movie template for rendering' do
        response.should render_template('similar')
      end
      it 'should make the similar movies availabe' do
        assigns(:movies).should == @result
      end
    end
    describe 'aftern an invalid search' do
      before :each do
        @movie = mock('movie', :director => '', :title => 'aladdin')
        Movie.stub(:find_by_id).and_return(@movie)
        Movie.stub(:find_similar).and_return([])
        get :similar, {:id => 1}
      end
      it 'should return to homepage with flash message if there is not director info' do
        #debugger
        response.should redirect_to (movies_path)
      end
      it 'should have a flash notice' do
        flash[:notice].should =~ /'aladdin' has no director info/
      end
    end
  end
  describe 'indexing movies' do
    it 'should displeay all the movies' do
      Movie.should_receive(:all_ratings).and_return([])
      get :index, {:sort => 'title'}
    end
    it 'should displeay all the movies' do
      Movie.should_receive(:all_ratings).and_return([])
      get :index, {:sort => 'release_date'}
    end
     it 'should displeay all the movies' do
      Movie.should_receive(:all_ratings).and_return({:ratings => 'pg'})
      session[:ratings] = 'r'
      get :index, :params => {:sort => 'title', :ratings => 's'}
    end
  end

  describe 'showing the movies' do
    it 'should show the right movies' do
      Movie.should_receive(:find).with("1")
      #response.should render_template('show')
      get :show, {:id => 1}
    end
  end

  describe 'destroy' do
    it 'should destroy stuff' do
      Movie.should_receive(:find).with("1").and_return(mock(:destroy => "", :title => 'aladdin'))
      #flash[:notice].should =~ /Movie 'aladdin' deleted./
      #response.should redirect_to (movies_path)
      delete :destroy, {:id => 1}
    end
  end

  it 'should update stuff' do
    Movie.should_receive(:find).with('1').and_return(Movie.create!)
    put :update, {:id => 1}
  end

  it 'should create stuff' do
    #debugger
    Movie.should_receive(:create!).and_return((mock(:title => 'al')))
    post :create, {:title => 'al'}
  end

  it 'should edit stuff' do
    Movie.should_receive(:find).with("1")
    get :edit, {:id => 1}
  end
end
