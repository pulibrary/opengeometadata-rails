require 'json'
require 'xmlsimple'

class OpengeometadataController < ApplicationController
  
  def index
    # load parameters
    @datadir = Rails.application.config.datadir || 'data'
    @institution = params[:institution] || 'institutions'
    
    if @institution == 'institutions'
      # show the available institutions
      institutions = []
      Dir.glob("#{@datadir}/{edu,com,org}.*").each do |i|
        institutions << File.basename(i)
      end
      respond_to do |format|
        format.json do
          send_data institutions.to_json, disposition: 'inline', type: 'application/json'
        end
      end
    else
      respond_to do |format|
        json_fn = "#{@datadir}/#{@institution}/layers.json"
        raise ActionController::RoutingError.new("Institution is not available: #{@institution}") unless File.size?(json_fn)
        
        layers = JSON.parse(File.open(json_fn).read)
        format.json do
          send_data layers.keys.to_json, disposition: 'inline', type: 'application/json'
        end        
      end
    end
  end
    
  def show
    # load parameters
    @datadir = Rails.application.config.datadir || 'data'
    @institution = params[:institution]
    @layer_id = params[:layer_id]
    @metadata_format = params[:metadata_format] || 'iso19139'
    @metadata_format = 'iso19139' if @metadata_format == 'default'

    # construct the layer's UUID
    @uuid = "#{@institution}:#{@layer_id}"
        
    # if there's a layers.json mapping then use it
    json_fn = "#{@datadir}/#{@institution}/layers.json"
    if File.size?(json_fn)
      layers = JSON.parse(File.open(json_fn).read)
      layer_path = layers[@layer_id]
      layer_path = layers[@uuid] if layer_path.nil?  
      raise ActionController::RoutingError.new("Layer is not registered: #{@uuid}") if layer_path.nil?
    else
      # ... otherwise locate as-is
      layer_path = @layer_id
    end
    
    # validate that we actually hold this layer
    fn = File.join(@datadir, @institution, layer_path)
    raise ActionController::RoutingError.new("Layer is not available: #{@uuid}") unless File.directory?(fn)
    
    # show the layer now
    respond_to do |format|

      # get whole file path
      orig_fn = File.join(fn, "#{@metadata_format}.#{params[:format]}")

      # if file exists, send it on
      if File.size?(orig_fn)
        format.xml { send_file orig_fn, disposition: 'inline', type: 'text/xml' }
        format.html { send_file orig_fn, disposition: 'inline', type: 'text/html' }
        format.json { send_file orig_fn, disposition: 'inline', type: 'application/json' }
      
      # if not and the format is json
      elsif params[:format] == 'json'
        
        #check if xml version exists#
        xml_fn = File.join(fn, "#{@metadata_format}.xml")
        if File.size?(xml_fn)

          # it exists, so read xml and fix encoding if necessary
          xml_string = (File.read xml_fn).sub('utf8','utf-8')

          # convert to hash and render as json
          xml = XmlSimple.xml_in(xml_string, :ForceArray => false)
          format.json { render json: xml }
        end
      else
        raise ActionController::RoutingError.new("Layer is not available in #{@metadata_format.upcase} format as #{params[:format].upcase}")
      end
    end
  end
end
