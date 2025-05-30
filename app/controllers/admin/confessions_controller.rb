module Admin
  class ConfessionsController < ApplicationController
    before_action :authenticate_admin!
    before_action :set_confession, only: [:destroy]

    def index
      @confessions = Confession.includes(:reactions)
                             .order(created_at: :desc)
                             .page(params[:page])
                             .per(20)
    end

    def destroy
      @confession.destroy
      respond_to do |format|
        format.html { redirect_to admin_confessions_path, notice: "Confession was successfully deleted." }
        format.turbo_stream { render turbo_stream: turbo_stream.remove(@confession) }
      end
    end

    private

    def set_confession
      @confession = Confession.find(params[:id])
    end

    def authenticate_admin!
      unless current_user&.admin?
        flash[:alert] = "You must be an admin to access this section."
        redirect_to root_path
      end
    end
  end
end 