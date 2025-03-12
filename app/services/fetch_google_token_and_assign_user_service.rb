class FetchGoogleTokenAndAssignUserService < ApplicationService
  def initialize(code:)
    @code = code
    @client = IdentityProviders::GoogleClient.new
  end

  attr_reader :code, :client

  def call
    client_token = client.fetch_token(code:)

    user_info = JWT.decode(client_token["id_token"], nil, false).first

    provider = create_or_update_identity_provider(
      user_info:, token_data: client_token
    )

    provider.save!

    OpenStruct.new(success?: true, user: provider.user)
  rescue StandardError => e
    error_handler(error_type: e.class, message: e.message)
  end

  private

  def error_handler(error_type:, message:)
    Rails.logger.error message

    case error_type.to_s
    when IdentityProviders::GoogleClient::OAuthClientError.to_s
      OpenStruct.new(success?: false, error: I18n.t("errors.clients.google.client"))
    when IdentityProviders::GoogleClient::OAuthGrantError.to_s
      OpenStruct.new(success?: false, error: I18n.t("errors.clients.google.grant"))
    when IdentityProviders::GoogleClient::OAuthRedirectError.to_s
      OpenStruct.new(success?: false, error: I18n.t("errors.clients.google.redirect"))
    else
      OpenStruct.new(success?: false, error: I18n.t("errors.clients.google.unexpected", message: message))
    end
  end

  def create_or_update_identity_provider(user_info:, token_data:)
    provider = IdentityProvider.find_by(
      name: "google",
      account_identifier: user_info["sub"]
    )

    access_token = token_data["access_token"]
    id_token = token_data["id_token"]
    refresh_token = token_data["refresh_token"]
    expires_in = DateTime.now + token_data["expires_in"].seconds

    if provider
      provider.assign_attributes(access_token:, id_token:, expires_in:)

      provider.refresh_token = refresh_token if refresh_token
    else
      provider = initialize_new_identity_provider_with_user(
        user_info:, access_token:, id_token:, token_data:
      )
    end

    provider
  end

  def initialize_new_identity_provider_with_user(user_info:, access_token:, id_token:, token_data:)
    password = generate_random_password

    provider = IdentityProvider.new(
      name: "google",
      account_identifier: user_info["sub"],
      expires_in: (DateTime.now + token_data["expires_in"].seconds),
      access_token: access_token,
      id_token: id_token,
      refresh_token: token_data["refresh_token"],
      user_attributes: {
        name: user_info["given_name"],
        surname: user_info["family_name"],
        email_address: user_info["email"],
        password: password
      }
    )
  end

  def generate_random_password
    PasswordGeneratorService.call(
      length: 8, min_uppercase: 1, min_lowercase: 1, min_number: 1, min_symbol: 1
    )
  end
end
