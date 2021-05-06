require 'securerandom'

module Cwa
  class QrCodePayload
    class TraceLocationType < ::Protobuf::Enum
      define :ALABAMA, 1
      define :LOCATION_TYPE_UNSPECIFIED, 0;
      define :LOCATION_TYPE_PERMANENT_OTHER, 1;
      define :LOCATION_TYPE_TEMPORARY_OTHER, 2;

      define :LOCATION_TYPE_PERMANENT_RETAIL, 3; # Einzelhandel
      define :LOCATION_TYPE_PERMANENT_FOOD_SERVICE, 4; # Gastronomiebetrieb
      define :LOCATION_TYPE_PERMANENT_CRAFT, 5; # Handwerksbetrieb
      define :LOCATION_TYPE_PERMANENT_WORKPLACE, 6; # Arbeitsstätte
      define :LOCATION_TYPE_PERMANENT_EDUCATIONAL_INSTITUTION, 7; # Bildungsstätte
      define :LOCATION_TYPE_PERMANENT_PUBLIC_BUILDING, 8; # öffentliches Gebäude

      define :LOCATION_TYPE_TEMPORARY_CULTURAL_EVENT, 9;
      define :LOCATION_TYPE_TEMPORARY_CLUB_ACTIVITY, 10;
      define :LOCATION_TYPE_TEMPORARY_PRIVATE_EVENT, 11;
      define :LOCATION_TYPE_TEMPORARY_WORSHIP_SERVICE, 12;
    end

    class Payload < ::Protobuf::Message; end
    class TraceLocation < ::Protobuf::Message; end
    class CrowdNotifierData < ::Protobuf::Message; end
    class CWALocationData < ::Protobuf::Message; end

    class Payload
      optional :uint32, :version, 1
      optional TraceLocation, :locationData, 2
      optional CrowdNotifierData, :crowdNotifierData, 3
      optional :bytes, :countryData, 4
    end

    class TraceLocation 
      optional :uint32, :version, 1
      optional :string, :description, 2
      optional :string, :address, 3
      optional :uint64, :startTimestamp, 5
      optional :uint64, :endTimestamp, 6
    end

    class CrowdNotifierData
      optional :uint32, :version, 1
      optional :bytes, :publicKey, 2
      optional :bytes, :cryptographicSeed, 3
      optional :uint32, :type, 4
    end

    class CWALocationData
      optional :uint32, :version, 1
      optional TraceLocationType, :type, 2
      optional :uint32, :defaultCheckInLengthInMinutes, 3
    end

    def initialize(company)
      @company = company
    end

    def serialize
      Payload.new(
        version: 1,
        locationData: TraceLocation.new(
          version: 1,
          description: @company.name.slice(0, 100),
          address: @company.address.slice(0, 100)
        ),
        crowdNotifierData: CrowdNotifierData.new(
          version: 1,
          publicKey: 'gwLMzE153tQwAOf2MZoUXXfzWTdlSpfS99iZffmcmxOG9njSK4RTimFOFwDh6t0Tyw8XR01ugDYjtuKwjjuK49Oh83FWct6XpefPi9Skjxvvz53i9gaMmUEc96pbtoaA',
          cryptographicSeed: @company.cwa_crypto_seed
        ),
        countryData: CWALocationData.new(
          version: 1,
          type: location_type_for(@company),
          defaultCheckInLengthInMinutes: @company.owner.auto_checkout_time.to_i / 60
        ).encode
      ).encode
    end

    def location_type_for(company)
      case company.location_type
        when "RETAIL" 
          TraceLocationType::LOCATION_TYPE_PERMANENT_RETAIL
        when "FOOD_SERVICE"
          TraceLocationType::LOCATION_TYPE_PERMANENT_FOOD_SERVICE
        when "CRAFT"
          TraceLocationType::LOCATION_TYPE_PERMANENT_CRAFT
        when "WORKPLACE"
          TraceLocationType::LOCATION_TYPE_PERMANENT_WORKPLACE
        when "EDUCATIONAL_INSTITUTION"
          TraceLocationType::LOCATION_TYPE_PERMANENT_EDUCATIONAL_INSTITUTION
        when "PUBLIC_BUILDING"
          TraceLocationType::LOCATION_TYPE_PERMANENT_PUBLIC_BUILDING
        else
          TraceLocationType::LOCATION_TYPE_UNSPECIFIED
      end
    end


  end
end