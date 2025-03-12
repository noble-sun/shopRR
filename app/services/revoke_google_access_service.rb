class RevokeGoogleAccessService < ApplicationService
  def initialize(user:)
    @user = user
    @client = IdentityProviders::GoogleClient.new
  end

  attr_reader :user, :client

  def call
    provider = user.identity_provider

    if DateTime.now > provider.expires_in
      client.refresh_access_token(user:)
    end

    client.revoke_access(user:)

    OpenStruct.new(success?: true)
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
      OpenStruct.new(success?: false, error: I18n.t("errors.clients.google.refresh"))
    when IdentityProviders::GoogleClient::OAuthUnrevokableError.to_s
      OpenStruct.new(success?: false, error: I18n.t("errors.clients.google.unrevokable"))
    else
      OpenStruct.new(success?: false, error: I18n.t("errors.clients.google.unexpected", message: message))
    end
  end
end
