class Confession < ApplicationRecord
    has_many :reactions, dependent: :destroy
    
    validates :body, presence: true, length: { maximum: 500 }
    validates :ip_address, presence: true
    
    def self.trending(limit = 3)
      # Using SQLite compatible syntax
      select("confessions.*, 
              COUNT(reactions.id) + (strftime('%s', confessions.created_at) / 3600) as score")
        .left_joins(:reactions)
        .group('confessions.id')
        .order('score DESC')
        .limit(limit)
    end
    
    def score
      reactions_count + (created_at.to_i / 3600)
    end
  end