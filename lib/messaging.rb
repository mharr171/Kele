require 'httparty'
require 'json'

module Messaging
  include HTTParty

  def get_messages(page = nil)
    if page
      @page = page
      response = self.class.get(api_url("/message_threads?page=#{@page}"), headers: { 'authorization' => @auth_token })
      JSON.parse(response.body)
    else
      response = self.class.get(api_url('/message_threads'), headers: { 'authorization' => @auth_token })
      JSON.parse(response.body)
    end
  end

  def create_message(recipient_id, subject, text)
    url = '/messages'
    options = {
      body: {
        "sender": self.get_me["email"],
        "recipient_id": recipient_id,
        "subject": subject,
        "stripped-text": text.strip
      },
      headers: {
        "authorization" => @auth_token
      }
    }
    if @auth_token
      response = self.class.post(url, options)
      puts response
    else
      puts "Not logged in. Please log in."
    end
  end
end
