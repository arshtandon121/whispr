module RateLimitable
    extend ActiveSupport::Concern
    
    included do
      before_action :check_rate_limits
    end
    
    private
    
    def check_rate_limits
      return if skip_rate_limiting?
      
      if rate_limit_exceeded?
        handle_rate_limit_exceeded
      end
    end
    
    def skip_rate_limiting?
      false
    end
    
    def rate_limit_exceeded?
      confession_rate_limit_exceeded? || reaction_rate_limit_exceeded?
    end
    
    def confession_rate_limit_exceeded?
      return false unless respond_to?(:confession_rate_limit)
      
      count = Confession.where(ip_address: request.remote_ip)
                       .where('created_at > ?', 24.hours.ago)
                       .count
      
      Rails.logger.info "Rate limit check: #{count} confessions in last 24 hours for IP #{request.remote_ip}"
      
      count >= confession_rate_limit
    end
    
    def reaction_rate_limit_exceeded?
      return false unless respond_to?(:reaction_rate_limit)
      
      if params[:confession_id].present?
        count = Reaction.where(ip_address: request.remote_ip)
                       .where(confession_id: params[:confession_id])
                       .count
        
        count >= reaction_rate_limit
      else
        false
      end
    end
    
    def handle_rate_limit_exceeded
      respond_to do |format|
        format.html do
          flash[:alert] = "Rate limit exceeded. Please try again later."
          redirect_back(fallback_location: root_path)
        end
        format.json do
          render json: { error: "Rate limit exceeded" }, status: :too_many_requests
        end
        format.turbo_stream do
          render turbo_stream: turbo_stream.replace(
            "flash",
            partial: "shared/flash",
            locals: { message: "Rate limit exceeded. Please try again later.", type: "alert" }
          )
        end
      end
    end
    
    def confession_rate_limit
      3
    end
    
    def reaction_rate_limit
      1
    end
  end
  end