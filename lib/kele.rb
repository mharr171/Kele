require 'httparty'

class Kele
  include HTTParty
  base_uri 'https://www.bloc.io/api/v1'

  def initialize(email, password)
    response = self.class.post(api_url('sessions'), body: { email: email, password: password })
    @auth_token = response['auth_token']
    p 'Incorrect credentials, please try again!' unless @auth_token
  end

  def get_me
    response = self.class.get('/users/me', headers: { 'authorization' => @auth_token })
    @user_data = JSON.parse(response.body)
    @user_data.keys.each do |key|
      self.class.send(:define_method, key.to_sym) do
        @user_data[key]
      end
    end
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
