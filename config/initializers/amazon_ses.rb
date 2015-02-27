require 'aws/ses'
ActionMailer::Base.add_delivery_method :ses, AWS::SES::Base,
  access_key_id: ENV['AMAZON_ACCESS_KEY'],
  secret_access_key: ENV['AMAZON_SECRET_KEY'],
  server: 'email-smtp.us-west-2.amazonaws.com'
