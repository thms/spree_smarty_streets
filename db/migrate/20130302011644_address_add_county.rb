# Add fields for address validation and county lookup
# Definition if: failed is false and 
class AddressAddCounty < ActiveRecord::Migration
  def up
    add_column :spree_addresses, :county_id, :integer, :null => true
    add_column :spree_addresses, :county_lookup_failed, :boolean, :null => false, :default => false
    add_column :spree_addresses, :validation_failed, :boolean, :null => false, :default => false
    add_column :spree_addresses, :validated_at, :datetime
  end

  def down
    remove_column :spree_addresses, :county_id
    remove_column :spree_addresses, :county_lookup_failed
    remove_column :spree_addresses, :validation_failed
    remove_column :spree_addresses, :validated_at
  end
end
