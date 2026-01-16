require "rails_helper"

RSpec.describe "Users", type: :request do
  let(:headers) { { "Accept" => "application/json", "Content-Type" => "application/json" } }

  describe "POST /signup" do
    let(:valid_attributes) do
      {
        email: "test@example.com",
        password: "password123",
        password_confirmation: "password123"
      }
    end

    it "creates a new user" do
      expect {
        post "/signup", params: valid_attributes.to_json, headers: headers
      }.to change(User, :count).by(1)

      expect(response).to have_http_status(:created)
      user_response = JSON.parse(response.body)
      expect(user_response).to include("user", "token")
      expect(user_response["user"]).to include("id", "email")
      expect(user_response["user"]["email"]).to eq("test@example.com")
      expect(user_response["token"]).to be_present
    end

    context "with invalid parameters" do
      it "returns an error" do
        post "/signup", params: { email: "invalid" }.to_json, headers: headers

        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "POST /login" do
    let(:user) { create(:user, email: "test@example.com", password: "password123") }

    it "returns the user and token" do
      post "/login", params: { email: user.email, password: "password123" }.to_json, headers: headers

      expect(response).to have_http_status(:ok)
      user_response = JSON.parse(response.body)
      expect(user_response).to include("user", "token")
      expect(user_response["user"]).to include("id", "email")
      expect(user_response["user"]["email"]).to eq(user.email)
      expect(user_response["token"]).to eq(user.auth_token)
    end

    it "regenerates auth token when requested" do
      original_token = user.auth_token
      post "/login", params: { email: user.email, password: "password123", regenerate_token: true }.to_json, headers: headers

      expect(response).to have_http_status(:ok)
      user_response = JSON.parse(response.body)
      expect(user_response["token"]).not_to eq(original_token)
    end

    context "with invalid credentials" do
      it "returns unauthorized" do
        post "/login", params: { email: user.email, password: "wrong_password" }.to_json, headers: headers

        expect(response).to have_http_status(:unauthorized)
        expect(JSON.parse(response.body)).to include("error" => "Invalid email or password")
      end
    end
  end

  describe "GET /me" do
    let(:user) { create(:user) }
    let(:auth_headers) do
      {
        "Accept" => "application/json",
        "Content-Type" => "application/json",
        "Authorization" => "Bearer #{user.auth_token}"
      }
    end

    it "returns the current user info" do
      get "/me", headers: auth_headers

      expect(response).to have_http_status(:ok)
      user_response = JSON.parse(response.body)
      expect(user_response).to include("user")
      expect(user_response["user"]).to include("id", "email")
      expect(user_response["user"]["id"]).to eq(user.id)
    end

    context "without authentication" do
      it "returns unauthorized" do
        get "/me", headers: headers

        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe "DELETE /logout" do
    let(:user) { create(:user) }
    let(:auth_headers) do
      {
        "Accept" => "application/json",
        "Content-Type" => "application/json",
        "Authorization" => "Bearer #{user.auth_token}"
      }
    end

    it "regenerates auth token" do
      original_token = user.auth_token
      delete "/logout", headers: auth_headers

      expect(response).to have_http_status(:no_content)
      expect(user.reload.auth_token).not_to eq(original_token)
    end

    context "without authentication" do
      it "returns unauthorized" do
        delete "/logout", headers: headers

        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
