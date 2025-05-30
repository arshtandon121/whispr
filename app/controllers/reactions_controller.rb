class ReactionsController < ApplicationController
  include RateLimitable
  
  def create
    @confession = Confession.find(params[:confession_id])
    
    if rate_limit_exceeded?
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: turbo_stream.replace(
            "flash_messages",
            partial: "shared/flash",
            locals: { message: "You can only react once to each confession.", type: "alert" }
          )
        end
        format.html do
          flash[:alert] = "You can only react once to each confession."
          redirect_to root_path
        end
      end
      return
    end
    
    @reaction = @confession.reactions.new(reaction_params)
    @reaction.ip_address = request.remote_ip
    
    if @reaction.save
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to root_path, notice: "Reaction added!" }
      end
    else
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: turbo_stream.replace(
            "flash_messages",
            partial: "shared/flash",
            locals: { message: @reaction.errors.full_messages.join(', '), type: "alert" }
          )
        end
        format.html do
          flash[:alert] = @reaction.errors.full_messages.join(', ')
          redirect_to root_path
        end
      end
    end
  end
  
  private
  
  def reaction_params
    params.require(:reaction).permit(:reaction_type)
  end
end