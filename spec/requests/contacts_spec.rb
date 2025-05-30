require "rails_helper"

RSpec.describe "Contacts", type: :request do
  let(:headers) { { "Accept" => "application/json", "Content-Type" => "application/json" } }

  describe "GET /contacts" do
    context "when there are no contacts" do
      it "returns an empty array" do
        get "/contacts", headers: headers

        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)).to eq([])
      end
    end

    context "when there are contacts" do
      before(:each) { create_list(:contact, 3) }

      it "returns a list of contacts" do
        get "/contacts", headers: headers

        expect(response).to have_http_status(:ok)
        contacts = JSON.parse(response.body)
        expect(contacts.size).to eq(3)
        expect(contacts.first).to include("id", "name", "email", "phone")
      end
    end
  end

  describe "POST /contacts" do
    context "with valid parameters" do
      let(:valid_attributes) do
        {
          name: "John Doe",
          email: "john@example.com",
          phone: "923-456-789"
        }
      end

      it "creates a new contact" do
        expect {
          post "/contacts", params: valid_attributes.to_json, headers: headers
        }.to change(Contact, :count).by(1)

        expect(response).to have_http_status(:created)
        contact = JSON.parse(response.body)
        expect(contact).to include("id", "name", "email", "phone")
        expect(contact["name"]).to eq("John Doe")
      end
    end

    context "with invalid parameters" do
      let(:invalid_attributes) do
        {
          name: "",
          email: "invalid-email",
          phone: "not-a-phone-number"
        }
      end

      it "returns an error" do
        post "/contacts", params: invalid_attributes.to_json, headers: headers

        expect(response).to have_http_status(:unprocessable_entity)
        parsed_response = JSON.parse(response.body)
        expect(parsed_response["errors"]).to include("Name can't be blank", "Email must be a valid email address", "Phone must be a valid phone number")
      end
    end
  end

  describe "GET /contacts/:id" do
    context "with existing contact" do
      let(:contact) { create(:contact) }

      it "returns the contact" do
        get "/contacts/#{contact.id}", headers: headers

        expect(response).to have_http_status(:ok)
        returned_contact = JSON.parse(response.body)
        expect(returned_contact).to include("id", "name", "email", "phone")
        expect(returned_contact["id"]).to eq(contact.id)
      end
    end

    context "with non-existing contact" do
      it "returns a not found error" do
        get "/contacts/999999", headers: headers

        expect(response).to have_http_status(:not_found)
        expect(JSON.parse(response.body)).to include("error" => "Contact not found")
      end
    end
  end

  describe "PUT /contacts/:id" do
    let(:contact) { create(:contact) }

    context "with valid parameters" do
      let(:valid_attributes) do
        {
          name: "Jane Doe",
          email: "jane@example.com",
          phone: "924-654-321"
        }
      end

      it "updates the contact" do
        put "/contacts/#{contact.id}", params: valid_attributes.to_json, headers: headers

        expect(response).to have_http_status(:ok)
        updated_contact = JSON.parse(response.body)
        expect(updated_contact).to include("id", "name", "email", "phone")
        expect(updated_contact["id"]).to eq(contact.id)
        expect(updated_contact["name"]).to eq("Jane Doe")
      end
    end

    context "with invalid parameters" do
      let(:invalid_attributes) do
        {
          name: "",
          email: "invalid-email",
          phone: "not-a-phone-number"
        }
      end

      it "returns an error" do
        put "/contacts/#{contact.id}", params: invalid_attributes.to_json, headers: headers

        expect(response).to have_http_status(:unprocessable_entity)
        parsed_response = JSON.parse(response.body)
        expect(parsed_response["errors"]).to include("Name can't be blank", "Email must be a valid email address", "Phone must be a valid phone number")
      end
    end

    context "with non-existing contact" do
      it "returns a not found error" do
        put "/contacts/999999", params: { name: "Test" }.to_json, headers: headers

        expect(response).to have_http_status(:not_found)
        expect(JSON.parse(response.body)).to include("error" => "Contact not found")
      end
    end
  end

  describe "DELETE /contacts/:id" do
    let(:contact) { create(:contact) }

    context "with existing contact" do
      it "deletes the contact" do
        delete "/contacts/#{contact.id}", headers: headers

        expect(response).to have_http_status(:no_content)
        expect(Contact.exists?(contact.id)).to be_falsey
      end
    end

    context "with non-existing contact" do
      it "returns a not found error" do
        delete "/contacts/999999", headers: headers

        expect(response).to have_http_status(:not_found)
        expect(JSON.parse(response.body)).to include("error" => "Contact not found")
      end
    end
  end
end
