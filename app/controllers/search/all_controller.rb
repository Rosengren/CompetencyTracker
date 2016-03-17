require 'fuzzy_match'

class Search::AllController < ApplicationController

  # GET /search/all?q={username}
  def index
    users = FuzzyMatch.new(User.all, :read => :username)
    games = FuzzyMatch.new(Game.all, :read => :name)
    profs = FuzzyMatch.new(Proficiency.all, :read => :name)

    results = []
    users.find_all(params[:q]).each do |user|
      results.push({
        category: 'Users',
        id: user.id,
        name: user.username,
        url: "/users/" + user.id.to_s
      })
    end

    games.find_all(params[:q]).each do |game|
      results.push({
        category: 'Games',
        id: game.id,
        name: game.name,
        url: '/games/' + game.id.to_s
      })
    end

    profs.find_all(params[:q]).each do |proficiency|
      results.push({
        category: 'Proficiencies',
        id: proficiency.id,
        name: proficiency.name,
        url: '/proficiencies/' + proficiency.id.to_s
      })
    end

    render :json => results
  end
end

