class Product < ActiveRecord::Base

  def self.find_products_for_sale 
    # All resulsts sorted by title
    find(:all, :order => "title") 
  end

  # Is this entered? 
  validates_presence_of :title, :description, :image_url

  # Makes sure it's a number 
  validates_numericality_of :price

  # must have a decimal point
  # validate :price_must_contain_decimal

  # Custom made method below 
  validate :price_must_be_at_least_a_cent


  # Only one of This value in DataBase 
  validates_uniqueness_of :title

  # Use RegEx against a field 
  validates_format_of :image_url,
    :with => %r{\.(gif|jpg|png)$}i,
    :message => 'must be a GIF, JPG or PNG.'

  # Ensure a length can do a range or max too
  validates_length_of :title, :minimum => 10,
                      :message => 'must be at least 10 characters long.'

  def convert_to_currency
    price/100.0
  end

  
  protected

    def price_must_be_at_least_a_cent
      errors.add(:price, 'must be at least $0.01') if price.nil? || price < 0.01     
    end

#     def price_must_contain_decimal
#       # figure out how to get price here
#       errors.add(:price, 'must have a value for cents. EX 0.00') if  
#     end

end
