module default {
  abstract type HasTimestamp {
    required property timestamp -> datetime;
  }

  abstract type HasDeviceLink {
    required link device -> Device;
  }

  type Device {
    required property device_id -> str {
      constraint exclusive;
    }
    property name -> str;
    multi link instances := .<device[is HasDeviceLink];
    property device_type := (
      with single_instance := (select .instances limit 1)
      select single_instance.__type__.name
    );
    # multi link schedules := .<schedule[is ScheduleEntry]
  }

  # type BaseDevice {
  #   required property device_id -> str {
  #     constraint exclusive;
  #   }
  #   property name -> str;
  #   multi link instances := .<device[is HasDeviceLink];
  # }

  function device_from_id(device_id: str) -> default::Device
    using(assert_exists(assert_single((select default::Device filter .device_id = device_id))));

  type SystemStats extending HasTimestamp {
    required property cpu_load_average -> float32;
    required property cpu_temperature -> float32;
  }

  type DatabaseStats extending HasTimestamp {
    required property object_count -> int64;
    required property filesystem_size -> int64;
  }

  scalar type ShellyRelayState extending enum<`on`, off, overtemperature>;

  function to_int16(srs: default::ShellyRelayState) -> int16
    using (
      <int16>(
        select 0 if srs = default::ShellyRelayState.off else
        1 if srs = default::ShellyRelayState.`on` else
        2 if srs = default::ShellyRelayState.overtemperature else
        -1
      )
    );

  type ShellyPlugS extending HasTimestamp, HasDeviceLink {
    required property power -> float32;
    required property energy -> float32;
    required property relay -> ShellyRelayState;
    required property temperature -> float32;
    required property overtemperature -> bool;
  }

  type Shelly1PM extending HasTimestamp, HasDeviceLink {
    required property power -> float32;
    required property energy -> float32;
    required property relay -> ShellyRelayState;
    required property temperature -> float32;
  }

  type Shelly3EM extending HasTimestamp, HasDeviceLink {
    required property relay -> ShellyRelayState;

    # Watt-minute
    required property energy_0 -> float32;
    required property energy_1 -> float32;
    required property energy_2 -> float32;

    # Watt-minute
    required property returned_energy_0 -> float32;
    required property returned_energy_1 -> float32;
    required property returned_energy_2 -> float32;

    # Watt-hour
    required property total_energy_0 -> float32;
    required property total_energy_1 -> float32;
    required property total_energy_2 -> float32;

    # Watt-hour
    required property total_returned_energy_0 -> float32;
    required property total_returned_energy_1 -> float32;
    required property total_returned_energy_2 -> float32;

    # Watt
    required property power_0 -> float32;
    required property power_1 -> float32;
    required property power_2 -> float32;

    # Volt
    required property voltage_0 -> float32;
    required property voltage_1 -> float32;
    required property voltage_2 -> float32;

    # Ampere
    required property current_0 -> float32;
    required property current_1 -> float32;
    required property current_2 -> float32;

    # dimensionless
    required property power_factor_0 -> float32;
    required property power_factor_1 -> float32;
    required property power_factor_2 -> float32;
  }

  type ShellyUni extending HasTimestamp, HasDeviceLink {
    required property adc -> float32;
    required property relay_0 -> ShellyRelayState;
    required property relay_1 -> ShellyRelayState;
    required property input_0 -> bool;
    required property input_1 -> bool;
  }

  type ShellyTRV extending HasTimestamp, HasDeviceLink {
    required property position -> float32;
    required property target_temperature -> float32;
    required property temperature -> float32;
    required property battery -> float32;
  }

  type ShellyDW2 extending HasTimestamp, HasDeviceLink {
    required property temperature -> float32;
    required property open -> bool;
    required property tilt -> int16;
    required property lux -> float32;
    required property battery -> float32;
  }

  function to_bool(i: int16) -> bool
    using (select <bool>"true" if i = 1 else <bool>"false");

  function to_bool(i: int32) -> bool
    using (select <bool>"true" if i = 1 else <bool>"false");

  function to_bool(i: int64) -> bool
    using (select <bool>"true" if i = 1 else <bool>"false");

  function to_int16(b: bool) -> int16
    using (select <int16>1 if b = <bool>"true" else <int16>0);

  function to_int32(b: bool) -> int32
    using (select <int32>1 if b = <bool>"true" else <int16>0);

  function to_int64(b: bool) -> int64
    using (select <int64>1 if b = <bool>"true" else <int16>0);

  type InternetRates extending HasTimestamp {
    required property up -> int64;
    required property down -> int64;
  }

  type AqaraTHP extending HasTimestamp, HasDeviceLink {
    # Xiaomi WSDCGQ11LM
    property battery -> int16;
    required property linkquality -> int16;
    required property humidity -> float32;
    required property pressure -> float32;
    required property temperature -> float32;
  }

  type CO2Sensor extending HasTimestamp, HasDeviceLink {
    required property co2_ppm -> int16;
  }
};
