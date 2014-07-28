class Proposition < ActiveRecord::Base
  require 'net/http'
  require 'json'

  belongs_to :user, :class_name => 'User', :foreign_key => 'user_id'
  has_many :visits, :class_name => 'Visit'
  after_create :add_nirror_site

  private
    def add_nirror_site
      ni_base_url = APP_CONFIG['nirror']['api_base_url']
      nirror_base_uri = URI.parse(ni_base_url)
      http = Net::HTTP.new(nirror_base_uri.host, nirror_base_uri.port)
      if nirror_base_uri.port == 443
        http.use_ssl = true
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      end

      ni_org_id = APP_CONFIG['nirror']['id']
      proposition_id = self.id
      client = {
          :email => self.user.email,
          :site => {
              :hostname => 'https://www.tilkee.fr',
              :name => "Proposition Tilkee #{proposition_id}"
          }
      }

      create_user_url = "#{ni_base_url}/org/#{ni_org_id}/clients"
      puts create_user_url
      request = Net::HTTP::Post.new(create_user_url)
      request.add_field('Authorization', APP_CONFIG['nirror']['apikey'])
      request.add_field('Content-Type', 'application/json')
      request.body = client.to_json
      response = http.request(request)

      if response.code == '200'
        res = JSON.parse(response.body)
        client_id = res['client_id']
        site_id = res['site_id']
        self.nirror_site_id = site_id
        self.save
      else
        raise "Error while creating a Nirror Site: #{response.body}"
      end
    end

end
