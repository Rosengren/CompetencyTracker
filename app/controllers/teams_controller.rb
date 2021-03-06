class TeamsController < ApplicationController
  before_action :set_team, :set_user_team, only: [:show, :edit, :update, :destroy, :requestDecision]
  helper_method :game_name, :get_role, :is_user_on_team?, :get_pending_requests,
                :team_members, :pending_join_requests?, :has_requested_to_join?

  # GET /teams
  # GET /teams.json
  def index
    @teams = Team.order("community_rating DESC").all
    @games = Game.all
  end

  # GET /teams/1
  # GET /teams/1.json
  def show
    @team = Team.find_by_slug(params[:id])

    if @team.nil?
      raise ActionController::RoutingError.new('Not Found')
    end
  end

  def requestDecision

    decision = @team.user_teams.find_by(user_id: params[:user_id])
    if params[:decision] == 'true'
      decision.status = 1
    else
     decision.destroy
    end

    respond_to do |format|
      if decision.save
        format.html { redirect_to @team, notice: 'Decisions have been made.' }
        format.json { render :show, status: :ok, location: @team }
      else
        format.html { render :edit }
        format.json { render json: @team.errors, status: :unprocessable_entity }
      end
    end
  end

  # GET /teams/new
  def new
    @team = Team.new
    @role = ""
  end

  # GET /teams/1/edit
  def edit
  end

  # POST /teams
  # POST /teams.json
  def create
    @team = Team.new(team_params)
    @team.slug = @team.name.downcase.gsub(" ", "-")

    @team.community_rating = 0

    # Set default picture url
    if !@team.picture_url
      @team.picture_url = 'https://d13yacurqjgara.cloudfront.net/users/205424/screenshots/1953810/pandamoniumshot.png'
    end

    @user = User.find(session[:session_key])

    respond_to do |format|
      if @team.save
        @team.users.push(@user)
        @team.users
        @team.save
        user_teams = @team.user_teams.find_by(user_id: @user.id)
        user_teams.role = params[:role]
        user_teams.status = 1
        user_teams.save!

        # TODO: Add game to user profile if it's not already there

        format.html { redirect_to @team, notice: 'Team was successfully created.' }
        format.json { render :show, status: :created, location: @team }
      else
        format.html { render :new }
        format.json { render json: @team.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /teams/1
  # PATCH/PUT /teams/1.json
  def update
    respond_to do |format|
      if @team.update(team_params)
        format.html { redirect_to @team, notice: 'Team was successfully updated.' }
        format.json { render :show, status: :ok, location: @team }
      else
        format.html { render :edit }
        format.json { render json: @team.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /teams/1
  # DELETE /teams/1.json
  def destroy
    @team.destroy
    respond_to do |format|
      format.html { redirect_to teams_url, notice: 'Team was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def game_name
    Game.find(@team.game_id).name
  end

  def get_role (user_id)
    @team.user_teams.find_by(user_id: user_id).role
  end

  def is_user_on_team?
    userOnTeam = @team.user_teams.find_by(user_id: session[:session_key])
    if userOnTeam != nil and userOnTeam.status == 1
      return true
    else
      return false
    end
  end

  def get_pending_requests
    @team.user_teams.where(status: 0)
  end

  def pending_join_requests?
    if is_user_on_team?
      return @team.user_teams.where(status: 0).exists?
    else
      return false
    end
  end

  def has_requested_to_join?
    @team.user_teams.where(user_id: current_user.id).any?
  end

  def team_members
    team_members = []
    @team.user_teams.where(status: 1).each do |userTeam|
      team_members.push(User.find(userTeam.user_id))
    end
    team_members
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_team
      @team = Team.find_by_slug(params[:id])
    end

    def set_user_team
      @user_team = UserTeam.new
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def team_params
      params.require(:team).permit(:game_id, :name, :description, :location, :picture_url, :role)
    end
end
