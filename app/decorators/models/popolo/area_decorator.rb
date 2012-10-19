# @note Since postal_codes can be large, exclude it when selecting records.
Popolo::Area.class_eval do
  SERVICES_URL = 'http://servicesenligne2.ville.montreal.qc.ca/sel/LesArrondissements/get'

  # The postal codes within this area.
  field :postal_codes, type: Array
  # The area's identifier on the external service.
  field :services_id, type: String

  validates_presence_of :services_id

  index({postal_codes: 1})
  index({services_id: 1}, unique: true)

  # @param [String] postal_code a postal code
  # @return [Area] the area containing that postal code
  def self.find_by_postal_code(postal_code)
    area = where(postal_codes: postal_code).first
    if area.nil?
      a = Nokogiri::HTML(RestClient.get(SERVICES_URL, params: {codePostal: postal_code})).at_css('table.bteintc a')
      if a.nil?
        area = find_by service_id: a.text
        area.postal_codes << postal_code
        area.save!
      end
    end
    area
  end

  # @return [String] the area's external URL
  def external_url
    "http://ville.montreal.qc.ca/#{slug}"
  end
end
