class ReactionsController < ApplicationController
  include RateLimitable
  
  def create
    @confession = Confession.find(params[:confession_id])
    @reaction = @confession.reactions.new(reaction_params)
    @reaction.ip_address = request.remote_ip
    
    if @reaction.save
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to root_path }
      end
    else
      redirect_to root_path, alert: 'Error adding reaction.'
    end
  end
  
  private
  
  def reaction_params
    params.require(:reaction).permit(:reaction_type)
  end
end