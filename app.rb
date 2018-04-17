require 'sinatra'
require 'sendgrid-ruby'

include SendGrid



get '/' do   
  erb :index
end 

post '/contact' do

  @email = params[:email]
  @opinion = params[:opinion]

  from = Email.new(email: @email)
  to = Email.new(email: 'allie.g.cooper@gmail.com')
  subject = 'My Election Musings'
  content = Content.new(type: 'text/plain', value: @opinion)
  mail = Mail.new(from, subject, to, content)

  sg = SendGrid::API.new(api_key: ENV['SENDGRID_API_KEY'])
  response = sg.client.mail._('send').post(request_body: mail.to_json)
  if response.status_code == 401
    error_hash = JSON.parse(response.body)
    @errors = error_hash["errors"]
  end 
end 