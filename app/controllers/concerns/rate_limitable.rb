module RateLimitable
    extend ActiveSupport::Concern
    
    included do
      before_action :check_rate_limit
    end
    
    private
    
    def check_rate_limit
      if rate_limit_exceeded?
        render json: { error: "Rate limit exceeded" }, status: :too_many_requests
      end
    end
    
    def rate_limit_exceeded?
      if controller_name == 'confessions' && action_name == 'create'
        Confession.where(ip_address: request.remote_ip)
                 .where('created_at > ?', 24.hours.ago)
                 .count >= 3
      elsif controller_name == 'reactions' && action_name == 'create'
        Reaction.where(ip_address: request.remote_ip)
                .where(confession_id: params[:confession_id])
                .exists?
      else
        false
      end
    end
  end