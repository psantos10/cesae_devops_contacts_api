module Authentication
  extend ActiveSupport::Concern

  included do
    before_action :authenticate_user
    attr_reader :current_user
  end

  private

  def authenticate_user
    auth_token = request.headers["Authorization"]&.split(" ")&.last
    return render_unauthorized unless auth_token

    @current_user = User.find_by(auth_token: auth_token)
    render_unauthorized unless @current_user
  end

  def render_unauthorized
    render json: { error: "Unauthorized access" }, status: :unauthorized
  end
end
