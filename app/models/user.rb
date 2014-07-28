class User < ActiveRecord::Base
  require 'net/http'
  require 'json/jwt'

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :propostions, :class_name => 'Proposition'

  def request_nirror_token
    ni_base_url = APP_CONFIG['nirror']['api_base_url']
    nirror_base_uri = URI.parse(ni_base_url)
    http = Net::HTTP.new(nirror_base_uri.host, nirror_base_uri.port)
    if nirror_base_uri.port == 443
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    end

    claim = {
        :iss => APP_CONFIG['nirror']['idp'],
        :sub => 'mailto:'+self.email,
        :aud => 'https://jwt-rp.nirror.com',
        :exp => 7702588800
    }

    jws = JSON::JWT.new(claim).sign(OpenSSL::PKey::RSA.new(APP_CONFIG['nirror']['pivatekey']), 'RS256')

    get_token_url = "#{ni_base_url}/oauth2/token"
    request = Net::HTTP::Post.new(get_token_url)
    request.add_field('Content-Type', 'application/json')
    request.body = {
        'grant_type' => 'urn:ietf:params:oauth:grant-type:jwt-bearer',
        'assertion' => jws.to_s
    }.to_json
    response = http.request(request)
    if response.code == '200'
      res = JSON.parse(response.body)
      puts "res"+res.to_s
      res['access_token']
    else
      raise "Error while requesting a Nirror access token: #{response.body}"
    end
  end

end
