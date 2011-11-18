class Borough
  include MongoMapper::Document
  many :people
  many :districts

  key :name, String
  key :slug, String
  key :services_id, String
  key :postal_codes, Array

  ensure_index :name
  ensure_index :slug
  ensure_index :services_id
  ensure_index :postal_codes

  validates_presence_of :name, :slug, :service_id

  SERVICES_URL = 'http://servicesenligne2.ville.montreal.qc.ca/sel/LesArrondissements/get'

  def self.find_by_postal_code(postal_code)
    borough = where(:postal_codes => postal_code).first
    if borough.nil?
      service_id = Nokogiri::HTML(RestClient.get(SERVICES_URL, params: {codePostal: postal_code})).at_css('table.bteintc a').text
      raise MongoMapper::DocumentNotFound if service_id.blank?
      borough = find_by_service_id service_id
      borough.postal_codes << postal_code
      borough.save!
    end
    borough
  end

  def url
    "http://ville.montreal.qc.ca/#{slug}"
  end
end
