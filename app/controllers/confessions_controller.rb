class ConfessionsController < ApplicationController
  include RateLimitable
  
  def index
    @confessions = Confession.order(created_at: :desc).limit(20)
    @trending_confessions = Confession.all.sort_by(&:score).reverse.first(3)
  end
  
  def create
    @confession = Confession.new(confession_params)
    @confession.ip_address = request.remote_ip
    
    if @confession.save
      redirect_to root_path, notice: 'Confession posted successfully!'
    else
      redirect_to root_path, alert: 'Error posting confession.'
    end
  end
  
  private
  
  def confession_params
    params.require(:confession).permit(:body)
  end
end