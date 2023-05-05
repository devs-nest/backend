# frozen_string_literal: true

# listmonk mailer config
class ListmonkMailer
  def self.send(email, data, template_id)
    # Initialize the Listmonk API client

    listmonk_api = Listmonk::BaseApis.new(
      ENV['LISTMONK_HOST'],
      ENV['LISTMONK_USERNAME'],
      ENV['LISTMONK_PASSWORD']
    )

    # Send the email via Listmonk API
    listmonk_api.tx(email, template_id, **data)
  end
end
