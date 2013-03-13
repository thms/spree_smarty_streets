Spree::Address.class_eval do
  
  belongs_to :county
  
  before_save :set_county
  
  # Set the county on an address, use before the address is changed so we have access to the changed attributes
  def set_county
    attempt_lookup = false
    #attempt to set the county if it is not set and validation has not yet failed
    if !self.has_county? && !self.county_lookup_failed
      attempt_lookup = true
    end
    # if parameters have changed that would impact the county, attempt to set the county again, irrespective of previous attempts
    unless (self.changed & ['address1', 'city', 'zipcode', 'state_id']).empty?
      attempt_lookup = true
    end
    if attempt_lookup
      begin
        county = self.get_county
        unless county.blank?
          self.county_id = county.id
          self.county_lookup_failed = false
        else
          self.county_id = nil
          self.county_lookup_failed = true
        end
      rescue Exception => e
        self.county_id = nil
        self.county_lookup_failed = true
      end        
    end
    true
  end
  
  # Attempt to set the county, and update the flags depending on success, useful for batch updating counties on existing addresses
  def set_county_stand_alone
    begin
      address = Spree::SmartyStreets::Address.new(
        :street => self.address1,
        :city => self.city,
        :state => self.state.abbr,
        :zip_code => self.zipcode,
        :number_of_candidates => 1
      )
      county_name = address.get_county_name
      county = Spree::County.find_by_name_and_state_id(county_name, self.state.id)
      unless county.blank?
        self.update_attributes_without_callbacks(:county_id => county.id, :county_lookup_failed => false)
      else
        self.update_attributes_without_callbacks(:county_lookup_failed => true)
      end
    rescue Exception => e
      self.update_attributes_without_callbacks(:county_lookup_failed => true)
    end
  end
  
  def has_county?
    self.county_id != nil
  end
  

  # Get the county name, mostly used for debugging.
  def get_county
    begin
      address = Spree::SmartyStreets::Address.new(
        :street => self.address1,
        :city => self.city,
        :state => self.state.abbr,
        :zip_code => self.zipcode,
        :number_of_candidates => 1
      )
      county_name = address.get_county_name
      county = Spree::County.find_by_name_and_state_id(county_name, self.state.id)
      return county
    rescue Exception => e
      raise
    end
  end
  
end
