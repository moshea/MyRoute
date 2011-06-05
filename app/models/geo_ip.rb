class GeoIP
  include Singleton
  
  def initialize
    @geoip = Net::GeoIP.new(APP_CONFIG['maxmind_geoip_database'])
  end
  
  def lat_lng(ipaddr)
    lat = lng = nil
    begin
      lat = @geoip[ipaddr].latitude
      lng = @geoip[ipaddr].longitude
    rescue Net::GeoIP::RecordNotFoundError
      lat = 51.5
      lng = 0
    end
    return lat, lng
  end
end