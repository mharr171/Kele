require 'httparty'

class Kele
  include HTTParty
  base_uri 'https://www.bloc.io/api/v1'

  def initialize(email, password)
    post_response = self.class.post('/sessions', body: { email: email, password: password } )
    @auth_token = post_response['auth_token']
    if !@auth_token
      p "Incorrect credentials, please try again!"
    end
  end

  def get_me
    response = self.class.get('/users/me', headers: { "authorization" => @auth_token })
    @user_data = JSON.parse(response.body)
    @user_data.keys.each do |key|
      self.class.send(:define_method, key.to_sym) do
        @user_data[key]
      end
    end
  end

end
