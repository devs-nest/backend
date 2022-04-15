# frozen_string_literal: true

# sendgrid mailer config
class SendgridMailer
  def self.send(to, meta_data, template_id)
    data = {
      "personalizations": [
        {
          "to": [
            {
              "email": to
            }
          ],
          "dynamic_template_data": meta_data
        }
      ],
      "from": {
        "email": 'team@devsnest.in',
        "name": 'Kshitiz from Devsnest'
      },
      "template_id": template_id
    }
    sg = SendGrid::API.new(api_key: ENV['SENDGRID_API_KEY'])
    begin
      response = sg.client.mail._('send').post(request_body: data)
      response.status_code
    rescue StandardError => e
      puts e.message
    end
  end
end
