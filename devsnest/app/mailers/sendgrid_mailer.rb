# frozen_string_literal: true

# sendgrid mailer config
class SendgridMailer
  def self.send(to, subsitutions, template_id)
    data = {
      "personalizations": [
        {
          "to": [
            {
              "email": to
            }
          ],
          "dynamic_template_data": subsitutions
        }
      ],
      "from": {
        "email": 'team@devsnest.in'
      },
      "template_id": template_id
    }
    sg = SendGrid::API.new(api_key: ENV['SENDGRID_API_KEY'])
    begin
      response = sg.client.mail._('send').post(request_body: data)
      response.status_code
    rescue Exception => e
      puts e.message
    end
  end
end
