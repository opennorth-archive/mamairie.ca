class Borough
  include MongoMapper::Document
  many :people
  many :districts

  key :name, String, required: true, unique: true
  key :slug, String, required: true, unique: true
  key :services_id, String, required: true, unique: true
  # @note As postal_codes can become large, explicitly select fields on queries.
  key :postal_codes, Array

  ensure_index :name
  ensure_index :slug
  ensure_index :services_id
  ensure_index :postal_codes

  SERVICES_URL = 'http://servicesenligne2.ville.montreal.qc.ca/sel/LesArrondissements/get'

  def self.find_by_postal_code(postal_code)
    borough = where(postal_codes: postal_code).first
    if borough.nil?
      borough = find_by_service_id! Nokogiri::HTML(RestClient.get(SERVICES_URL, params: {codePostal: postal_code})).at_css('table.bteintc a').text
      borough.postal_codes << postal_code
      borough.save!
    end
    borough
  end

  def url
    "http://ville.montreal.qc.ca/#{slug}"
  end
end
