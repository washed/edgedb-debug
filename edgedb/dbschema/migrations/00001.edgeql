CREATE MIGRATION m14apgnghofhfju73nlzaod2xtzamdcio22axpiguxksffxsonw5dq
    ONTO initial
{
  CREATE TYPE default::Device {
      CREATE REQUIRED PROPERTY device_id -> std::str {
          CREATE CONSTRAINT std::exclusive;
      };
      CREATE PROPERTY name -> std::str;
  };
  CREATE FUNCTION default::device_from_id(device_id: std::str) ->  default::Device USING (std::assert_exists(std::assert_single((SELECT
      default::Device
  FILTER
      (.device_id = device_id)
  ))));
  CREATE FUNCTION default::to_bool(i: std::int16) ->  std::bool USING (SELECT
      (<std::bool>'true' IF (i = 1) ELSE <std::bool>'false')
  );
  CREATE FUNCTION default::to_bool(i: std::int32) ->  std::bool USING (SELECT
      (<std::bool>'true' IF (i = 1) ELSE <std::bool>'false')
  );
  CREATE FUNCTION default::to_bool(i: std::int64) ->  std::bool USING (SELECT
      (<std::bool>'true' IF (i = 1) ELSE <std::bool>'false')
  );
  CREATE SCALAR TYPE default::ShellyRelayState EXTENDING enum<`on`, off, overtemperature>;
  CREATE FUNCTION default::to_int16(srs: default::ShellyRelayState) ->  std::int16 USING (<std::int16>(SELECT
      (0 IF (srs = default::ShellyRelayState.off) ELSE (1 IF (srs = default::ShellyRelayState.`on`) ELSE (2 IF (srs = default::ShellyRelayState.overtemperature) ELSE -1)))
  ));
  CREATE FUNCTION default::to_int16(b: std::bool) ->  std::int16 USING (SELECT
      (<std::int16>1 IF (b = <std::bool>'true') ELSE <std::int16>0)
  );
  CREATE FUNCTION default::to_int32(b: std::bool) ->  std::int32 USING (SELECT
      (<std::int32>1 IF (b = <std::bool>'true') ELSE <std::int16>0)
  );
  CREATE FUNCTION default::to_int64(b: std::bool) ->  std::int64 USING (SELECT
      (<std::int64>1 IF (b = <std::bool>'true') ELSE <std::int16>0)
  );
  CREATE ABSTRACT TYPE default::HasDeviceLink {
      CREATE REQUIRED LINK device -> default::Device;
  };
  CREATE ABSTRACT TYPE default::HasTimestamp {
      CREATE REQUIRED PROPERTY timestamp -> std::datetime;
  };
  CREATE TYPE default::AqaraTHP EXTENDING default::HasTimestamp, default::HasDeviceLink {
      CREATE PROPERTY battery -> std::int16;
      CREATE REQUIRED PROPERTY humidity -> std::float32;
      CREATE REQUIRED PROPERTY linkquality -> std::int16;
      CREATE REQUIRED PROPERTY pressure -> std::float32;
      CREATE REQUIRED PROPERTY temperature -> std::float32;
  };
  CREATE TYPE default::CO2Sensor EXTENDING default::HasTimestamp, default::HasDeviceLink {
      CREATE REQUIRED PROPERTY co2_ppm -> std::int16;
  };
  CREATE TYPE default::DatabaseStats EXTENDING default::HasTimestamp {
      CREATE REQUIRED PROPERTY filesystem_size -> std::int64;
      CREATE REQUIRED PROPERTY object_count -> std::int64;
  };
  ALTER TYPE default::Device {
      CREATE MULTI LINK instances := (.<device[IS default::HasDeviceLink]);
      CREATE PROPERTY device_type := (WITH
          single_instance := 
              (SELECT
                  .instances 
              LIMIT
                  1
              )
      SELECT
          single_instance.__type__.name
      );
  };
  CREATE TYPE default::ShellyPlugS EXTENDING default::HasTimestamp, default::HasDeviceLink {
      CREATE REQUIRED PROPERTY energy -> std::float32;
      CREATE REQUIRED PROPERTY overtemperature -> std::bool;
      CREATE REQUIRED PROPERTY power -> std::float32;
      CREATE REQUIRED PROPERTY relay -> default::ShellyRelayState;
      CREATE REQUIRED PROPERTY temperature -> std::float32;
  };
  CREATE TYPE default::ShellyDW2 EXTENDING default::HasTimestamp, default::HasDeviceLink {
      CREATE REQUIRED PROPERTY battery -> std::float32;
      CREATE REQUIRED PROPERTY lux -> std::float32;
      CREATE REQUIRED PROPERTY open -> std::bool;
      CREATE REQUIRED PROPERTY temperature -> std::float32;
      CREATE REQUIRED PROPERTY tilt -> std::int16;
  };
  CREATE TYPE default::ShellyTRV EXTENDING default::HasTimestamp, default::HasDeviceLink {
      CREATE REQUIRED PROPERTY battery -> std::float32;
      CREATE REQUIRED PROPERTY position -> std::float32;
      CREATE REQUIRED PROPERTY target_temperature -> std::float32;
      CREATE REQUIRED PROPERTY temperature -> std::float32;
  };
  CREATE TYPE default::Shelly1PM EXTENDING default::HasTimestamp, default::HasDeviceLink {
      CREATE REQUIRED PROPERTY energy -> std::float32;
      CREATE REQUIRED PROPERTY power -> std::float32;
      CREATE REQUIRED PROPERTY relay -> default::ShellyRelayState;
      CREATE REQUIRED PROPERTY temperature -> std::float32;
  };
  CREATE TYPE default::Shelly3EM EXTENDING default::HasTimestamp, default::HasDeviceLink {
      CREATE REQUIRED PROPERTY current_0 -> std::float32;
      CREATE REQUIRED PROPERTY current_1 -> std::float32;
      CREATE REQUIRED PROPERTY current_2 -> std::float32;
      CREATE REQUIRED PROPERTY energy_0 -> std::float32;
      CREATE REQUIRED PROPERTY energy_1 -> std::float32;
      CREATE REQUIRED PROPERTY energy_2 -> std::float32;
      CREATE REQUIRED PROPERTY power_0 -> std::float32;
      CREATE REQUIRED PROPERTY power_1 -> std::float32;
      CREATE REQUIRED PROPERTY power_2 -> std::float32;
      CREATE REQUIRED PROPERTY power_factor_0 -> std::float32;
      CREATE REQUIRED PROPERTY power_factor_1 -> std::float32;
      CREATE REQUIRED PROPERTY power_factor_2 -> std::float32;
      CREATE REQUIRED PROPERTY relay -> default::ShellyRelayState;
      CREATE REQUIRED PROPERTY returned_energy_0 -> std::float32;
      CREATE REQUIRED PROPERTY returned_energy_1 -> std::float32;
      CREATE REQUIRED PROPERTY returned_energy_2 -> std::float32;
      CREATE REQUIRED PROPERTY total_energy_0 -> std::float32;
      CREATE REQUIRED PROPERTY total_energy_1 -> std::float32;
      CREATE REQUIRED PROPERTY total_energy_2 -> std::float32;
      CREATE REQUIRED PROPERTY total_returned_energy_0 -> std::float32;
      CREATE REQUIRED PROPERTY total_returned_energy_1 -> std::float32;
      CREATE REQUIRED PROPERTY total_returned_energy_2 -> std::float32;
      CREATE REQUIRED PROPERTY voltage_0 -> std::float32;
      CREATE REQUIRED PROPERTY voltage_1 -> std::float32;
      CREATE REQUIRED PROPERTY voltage_2 -> std::float32;
  };
  CREATE TYPE default::ShellyUni EXTENDING default::HasTimestamp, default::HasDeviceLink {
      CREATE REQUIRED PROPERTY adc -> std::float32;
      CREATE REQUIRED PROPERTY input_0 -> std::bool;
      CREATE REQUIRED PROPERTY input_1 -> std::bool;
      CREATE REQUIRED PROPERTY relay_0 -> default::ShellyRelayState;
      CREATE REQUIRED PROPERTY relay_1 -> default::ShellyRelayState;
  };
  CREATE TYPE default::InternetRates EXTENDING default::HasTimestamp {
      CREATE REQUIRED PROPERTY down -> std::int64;
      CREATE REQUIRED PROPERTY up -> std::int64;
  };
  CREATE TYPE default::SystemStats EXTENDING default::HasTimestamp {
      CREATE REQUIRED PROPERTY cpu_load_average -> std::float32;
      CREATE REQUIRED PROPERTY cpu_temperature -> std::float32;
  };
};
