require 'spec_helper'

describe Movie do
  describe 'searching movies by director' do
    it 'should search in the database for movies with the same director' do
      movie = mock('movie1', :director => '')
      Movie.should_receive(:find_all_by_director).with('')
      Movie.find_similar(movie)
    end
  end
end
