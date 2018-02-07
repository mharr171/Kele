require 'httparty'
require 'json'
require_relative 'messaging'
require_relative 'roadmap'

class Kele
  include HTTParty
  include Messaging
  include Roadmap
  base_uri 'https://www.bloc.io/api/v1'

  def initialize(email, password)
    response = self.class.post(api_url('sessions'), body: { email: email, password: password })
    @auth_token = response['auth_token']
    p 'Incorrect credentials, please try again!' unless @auth_token
  end

  def get_me
    response = self.class.get('/users/me', headers: { 'authorization' => @auth_token })
    JSON.parse(response.body)
  end

  def get_mentor_availability(mentor_id)
    @mentor_id = mentor_id
    response = self.class.get(api_url("/mentors/#{@mentor_id}/student_availability"), headers: { 'authorization' => @auth_token })
    JSON.parse(response.body).to_a
  end

  private

  def api_url(endpoint)
    "https://www.bloc.io/api/v1/#{endpoint}"
  end
end
