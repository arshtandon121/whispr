module RateLimitable
    extend ActiveSupport::Concern
    
    included do
      before_action :check_rate_limit
    end
    
    private
    
    def check_rate_limit
      return unless rate_limit_exceeded?
      
      respond_to do |format|
        format.html do
          flash[:alert] = rate_limit_message
          redirect_to root_path
        end
        format.json do
          render json: { error: rate_limit_message }, status: :too_many_requests
        end
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.replace("flash_messages", 
              partial: "shared/flash", 
              locals: { message: rate_limit_message, type: "alert" }
            )
          ], status: :too_many_requests
        end
      end
    end
    
    def rate_limit_exceeded?
      if controller_name == 'confessions' && action_name == 'create'
        # Check for confession rate limit (3 per day)
        count = Confession.where(ip_address: request.remote_ip)
                         .where('created_at > ?', 24.hours.ago)
                         .count
        Rails.logger.info "Rate limit check: #{count} confessions in last 24 hours for IP #{request.remote_ip}"
        count >= 3
      elsif controller_name == 'reactions'
        # Check for reaction rate limit (1 per confession)
        confession = Confession.find(params[:confession_id])
        confession.reactions.exists?(ip_address: request.remote_ip)
      else
        false
      end
    end

    def rate_limit_message
      if controller_name == 'confessions' && action_name == 'create'
        "Rate limit exceeded: You can only post 3 confessions per day."
      elsif controller_name == 'reactions'
        "You can only react once to each confession."
      end
    end
  end