require 'net/http'
module Spree
  module SmartyStreets

    # Raise if the API call does not return a 200 code
    class ResponseError < RuntimeError; end

    # Raise if the address cannot be validated
    class ValidationError < RuntimeError; end
    
    class Address
      
      API_URL = 'api.smartystreets.com'
      
      attr_accessor :street
      attr_accessor :city
      attr_accessor :state
      attr_accessor :zip_code
      attr_accessor :number_of_candidates
      attr_accessor :candidates
      attr_accessor :response
      attr_accessor :result
      attr_accessor :county
      
      def initialize(params)
        self.street = params[:street]
        self.city = params[:city]
        self.state = params[:state]
        self.zip_code = params[:zip_code]
        self.number_of_candidates = params[:number_of_candidates] || 1
      end
            
      # attempt to validate an address, and store validation result
      def validate
        
        @result = 404
        
        query_string = '/street-address/?' +
         	'street=' + CGI::escape(@street) +
        	'&city=' + CGI::escape(@city) +
        	'&state=' + @state +
        	'&zipcode=' + @zip_code.gsub(' ','') +
        	'&candidates=' + @number_of_candidates.to_s +
        	'&auth-id=' + Spree::SmartyStreets::Config.auth_id +
        	'&auth-token=' + Spree::SmartyStreets::Config.auth_token

        http = Net::HTTP.new(API_URL)
        request = Net::HTTP::Get.new(query_string)
        response = http.request(request)
        if response.is_a?(Net::HTTPSuccess)
          @response = JSON.parse(response.body)
          # Interpret response - 
          if @response.empty?
            # Address cannot be validated, there are zero candidates in the response
            raise ValidationError
          else
            @result = 200
          end
        else
          # Something went wrong with the API call, handle here
          raise ResponseError
        end
        return @result
          
      end
      
      # Just lookup the county via validation and then set its ID from the Spree::County tables, if successful.
      # If not successful, set the flag that the county could not be found
      def get_county_name
        
        county_name = nil
        
        query_string = '/street-address/?' +
         	'street=' + CGI::escape(@street) +
        	'&city=' + CGI::escape(@city) +
        	'&state=' + @state +
        	'&zipcode=' + @zip_code.gsub(' ','') +
        	'&candidates=' + @number_of_candidates.to_s +
        	'&auth-id=' + Spree::SmartyStreets::Config.auth_id +
        	'&auth-token=' + Spree::SmartyStreets::Config.auth_token

        http = Net::HTTP.new(API_URL)
        request = Net::HTTP::Get.new(query_string)
        # Enabling the x-standardize-only allows us to get county info, even if the address is not a perfect match, e.g. if the street number is 45 iso 47
        request.add_field("x-standardize-only", "true")
        response = http.request(request)
        if response.is_a?(Net::HTTPSuccess)
          @response = JSON.parse(response.body)
          # Interpret response - 
          if @response.empty?
            # Address cannot be validated, there are zero candidates in the response
            raise ValidationError
          else
            county_name = @response.first['metadata']['county_name']
          end
        else
          # Something went wrong with the API call, handle here
          raise ResponseError
        end
        return county_name
        
      end
      
    end
    
    class Candidate
    end
  end
end
