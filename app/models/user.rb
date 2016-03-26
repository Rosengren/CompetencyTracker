class User < ActiveRecord::Base
  has_many :user_proficiencies
  has_many :user_teams
  has_and_belongs_to_many :games
  has_many :teams, through: :user_teams
  has_many :proficiencies, through: :user_proficiencies
  validates :username, presence: true, uniqueness: true
  validates :password, presence: true, length: {minimum: 7}
  has_secure_password

  validates_presence_of :slug

  def to_param
    slug
  end
end
