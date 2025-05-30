class ConfessionsController < ApplicationController
  include RateLimitable
  
  def index
    @confessions = Confession.order(created_at: :desc).limit(20)
    @trending_confessions = Confession.trending(3)
  end
  
  def create
    @confession = Confession.new(confession_params)
    @confession.ip_address = request.remote_ip
    
    if @confession.save
      respond_to do |format|
        format.html do
          flash[:notice] = "Your confession has been posted successfully! 🎉"
          redirect_to root_path
        end
        format.turbo_stream do
          flash.now[:notice] = "Your confession has been posted successfully! 🎉"
          render turbo_stream: [
            turbo_stream.update("flash_messages", 
              partial: "shared/flash"
            ),
            turbo_stream.prepend("confessions", 
              partial: "confession", 
              locals: { confession: @confession }
            )
          ]
        end
      end
    else
      error_message = @confession.errors.full_messages.join(', ')
      respond_to do |format|
        format.html do
          flash[:alert] = "Unable to post confession: #{error_message}"
          redirect_to root_path
        end
        format.turbo_stream do
          flash.now[:alert] = "Unable to post confession: #{error_message}"
          render turbo_stream: turbo_stream.update("flash_messages", 
            partial: "shared/flash"
          ), status: :unprocessable_entity
        end
      end
    end
  end

  def check_reaction
    @confession = Confession.find(params[:id])
    has_reacted = @confession.reactions.exists?(ip_address: request.remote_ip)
    render json: { has_reacted: has_reacted }
  end
  
  private
  
  def confession_params
    params.require(:confession).permit(:body)
  end
end