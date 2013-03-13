class Spree::SmartyStreetsConfiguration < Spree::Preferences::Configuration

  preference :auth_id, :string, :default => ""
  preference :auth_token, :string, :default => ""
  preference :validate_ship_address, :boolean, :default => false
  preference :validate_bill_address, :boolean, :default => false
  preference :lookup_county_for_ship_address, :boolean, :default => false  
  
end
