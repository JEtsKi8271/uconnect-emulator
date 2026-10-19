# VP2 (Uconnect 5.0 RA2, MY15 PowerNet) CAN signal catalog

From the HMI's SignalData definitions (`Reference="NET+MESSAGE-Signal"`). Value = raw * factor + offset.
Numeric CAN IDs and bit positions are **not** in this firmware as text (see README).

## BCAN · ENVIRONMENTAL_CONDITIONS

| signal | bits | factor | offset | min | max |
|---|---|---|---|---|---|
| BatteryVoltageLevel | 1 | 1 | 0 | 0 | 0 |
| ExtTempFailSts | 1 | 1 | 0 | 0 | 0 |
| ExternalTemperature | 8 | 0.5 | -40 | 0 | 0 |
| ExternalTemperatureFailSts | 1 | 1 | 0 | 0 | 0 |

## BCAN · IPC_VEHICLE_SETUP

| signal | bits | factor | offset | min | max |
|---|---|---|---|---|---|
| ConsumptionUnit | 3 | 1 | 0 | 0 | 0 |
| DistanceUnit | 1 | 1 | 0 | 0 | 0 |

## BCAN · NQS_VEHICLE_SETUP

| signal | bits | factor | offset | min | max |
|---|---|---|---|---|---|
| ConsumptionUnit | 3 | 1 | 0 | 0 | 0 |
| DistanceUnit | 1 | 1 | 0 | 0 | 0 |

## BCAN · SERVICEINFO

| signal | bits | factor | offset | min | max |
|---|---|---|---|---|---|
| DistanceToService | 15 | 1 | 0 | 0 | 0 |
| DistanceToServiceValidData | 1 | 1 | 0 | 0 | 0 |

## BCAN · SERVICEINFO2

| signal | bits | factor | offset | min | max |
|---|---|---|---|---|---|
| DistanceToService | 17 | 1 | 0 | 0 | 0 |
| DistanceToServiceValidData | 1 | 1 | 0 | 0 | 0 |

## BCAN · STATUS_BCM

| signal | bits | factor | offset | min | max |
|---|---|---|---|---|---|
| BrakeFluidLevelSts | 1 | 1 | 0 | 0 | 0 |
| BrakePadWearSts | 1 | 1 | 0 | 0 | 0 |
| FuelLevel | 8 | 1 | 0 | 0 | 0 |
| FuelLevelFailSts | 1 | 1 | 0 | 0 | 0 |

## BCAN · STATUS_BCM2

| signal | bits | factor | offset | min | max |
|---|---|---|---|---|---|
| EngineWaterLevel | 1 | 1 | 0 | 0 | 0 |

## BCAN · STATUS_B_ECM

| signal | bits | factor | offset | min | max |
|---|---|---|---|---|---|
| CompressorSts | 2 | 1 | 0 | 0 | 0 |
| DPFSts | 1 | 1 | 0 | 0 | 0 |
| EngineSpeed | 8 | 32 | 0 | 0 | 0 |
| EngineSpeedValidData | 1 | 1 | 0 | 0 | 0 |
| FuelConsumption | 16 | 0.0022 | 0 | 0 | 0 |
| FuelConsumptionValidData | 1 | 1 | 0 | 0 | 0 |
| OilLifeSts | 2 | 1 | 0 | 0 | 0 |
| OilPressureSts | 1 | 1 | 0 | 0 | 0 |

## BCAN · STATUS_B_ECM.GPLGasolineMode

| signal | bits | factor | offset | min | max |
|---|---|---|---|---|---|
|  | 1 | 1 | 0 | 0 | 1 |

## BCAN · STATUS_B_ECM2

| signal | bits | factor | offset | min | max |
|---|---|---|---|---|---|
| AlternativeFuelFillingTank | 7 | 1 | 0 | 0 | 100 |
| CNGFillingTank | 7 | 1 | 0 | 0 | 100 |
| CNGGasolineMode | 1 | 1 | 0 | 0 | 0 |
| OilLevelIndication | 3 | 1 | 0 | 0 | 0 |

## BCAN · STATUS_B_ECM4

| signal | bits | factor | offset | min | max |
|---|---|---|---|---|---|
| AFSts | 7 | 0.1 | 8 | 0 | 0 |
| AF_FailSts | 1 | 1 | 0 | 0 | 0 |

## BCAN · STATUS_B_NCM

| signal | bits | factor | offset | min | max |
|---|---|---|---|---|---|
| CompressorSts | 2 | 1 | 0 | 0 | 0 |
| DPFSts | 1 | 1 | 0 | 0 | 0 |
| EngineSpeed | 8 | 32 | 0 | 0 | 0 |
| EngineSpeedValidData | 1 | 1 | 0 | 0 | 0 |
| FuelConsumption | 16 | 0.0022 | 0 | 0 | 0 |
| FuelConsumptionValidData | 1 | 1 | 0 | 0 | 0 |
| OilLifeSts | 2 | 1 | 0 | 0 | 0 |
| OilPressureSts | 1 | 1 | 0 | 0 | 0 |

## BCAN · STATUS_B_NCM2

| signal | bits | factor | offset | min | max |
|---|---|---|---|---|---|
| CNGFillingTank | 7 | 1 | 0 | 0 | 100 |
| CNGGasolineMode | 1 | 1 | 0 | 0 | 0 |
| OilLevelIndication | 3 | 1 | 0 | 0 | 0 |

## BCAN · STATUS_B_NCM3

| signal | bits | factor | offset | min | max |
|---|---|---|---|---|---|
| AFSts | 7 | 0.1 | 8 | 0 | 0 |
| AF_FailSts | 1 | 1 | 0 | 0 | 0 |

## BCAN · STATUS_IPC

| signal | bits | factor | offset | min | max |
|---|---|---|---|---|---|
| TemperatureSensorPresenceSt | 1 | 1 | 0 | 0 | 0 |

## BCAN · STATUS_NBC

| signal | bits | factor | offset | min | max |
|---|---|---|---|---|---|
| BrakeFluidLevelSts | 1 | 1 | 0 | 0 | 0 |
| BrakePadWearSts | 1 | 1 | 0 | 0 | 0 |
| FuelLevel | 8 | 1 | 0 | 0 | 0 |
| FuelLevelFailSts | 1 | 1 | 0 | 0 | 0 |

## BCAN · STATUS_NBC_2

| signal | bits | factor | offset | min | max |
|---|---|---|---|---|---|
| EngineWaterLevel | 1 | 1 | 0 | 0 | 0 |
| TyreInflationState | 2 | 1 | 0 | 0 | 0 |
| TyrePressureSystemFailSts | 1 | 1 | 0 | 0 | 0 |

## BCAN · STATUS_TPMS

| signal | bits | factor | offset | min | max |
|---|---|---|---|---|---|
| TyreInflationState | 2 | 1 | 0 | 0 | 0 |
| TyrePressureSystemFailSts | 1 | 1 | 0 | 0 | 0 |

## BCAN · TRIP_A

| signal | bits | factor | offset | min | max |
|---|---|---|---|---|---|
| AverageFuelConsAPlusValidData | 1 | 1 | 0 | 0 | 0 |
| AverageFuelConsumptionAPlus | 10 | 1 | 0 | 0 | 0 |
| AverageFuelConsumptionAValidData | 1 | 1 | 0 | 0 | 0 |
| AverageFuelConsumptionA_Digit1 | 4 | 1 | 0 | 0 | 0 |
| AverageFuelConsumptionA_Digit2 | 4 | 1 | 0 | 0 | 0 |
| AverageFuelConsumptionA_Digit3 | 4 | 1 | 0 | 0 | 0 |
| AverageSpeedA | 8 | 1 | 0 | 0 | 0 |
| AverageSpeedAPlus | 8 | 1 | 0 | 0 | 0 |
| AverageSpeedAPlusValidData | 1 | 1 | 0 | 0 | 0 |
| AverageSpeedAValidData | 1 | 1 | 0 | 0 | 0 |
| PartialOdometerA | 17 | 0.1 | 0 | 0 | 0 |
| PartialOdometerAPlus | 20 | 0.1 | 0 | 0 | 0 |
| PartialOdometerAPlusValidData | 1 | 1 | 0 | 0 | 0 |
| PartialOdometerAValidData | 1 | 1 | 0 | 0 | 0 |
| ResetTripAACK | 2 | 1 | 0 | 0 | 0 |

## BCAN · TRIP_APlus

| signal | bits | factor | offset | min | max |
|---|---|---|---|---|---|
| AverageFuelConsumptionAPlus | 10 | 1 | 0 | 0 | 0 |
| AverageFuelConsumptionAPlusValidData | 1 | 1 | 0 | 0 | 0 |
| AverageSpeedAPlus | 8 | 1 | 0 | 0 | 0 |
| AverageSpeedAPlusValidData | 1 | 1 | 0 | 0 | 0 |
| PartialOdometerAPlus | 20 | 0.1 | 0 | 0 | 0 |
| PartialOdometerAPlusValidData | 1 | 1 | 0 | 0 | 0 |

## BCAN · TRIP_A_B

| signal | bits | factor | offset | min | max |
|---|---|---|---|---|---|
| AutonomyDistance | 11 | 1 | 0 | 0 | 0 |
| AutonomyDistanceValidData | 1 | 1 | 0 | 0 | 0 |
| InstantFuelConsumptionValidData | 1 | 1 | 0 | 0 | 0 |
| InstantaneousFuelConsumption1 | 4 | 1 | 0 | 0 | 0 |
| InstantaneousFuelConsumption2 | 4 | 1 | 0 | 0 | 0 |
| InstantaneousFuelConsumption3 | 4 | 1 | 0 | 0 | 0 |
| TotalOdometer | 20 | 1 | 0 | 0 | 0 |

## BCAN · VEHICLE_SPEED_ODOMETER

| signal | bits | factor | offset | min | max |
|---|---|---|---|---|---|
| TravelDistance | 8 | 9.8 | 0 | 0 | 0 |
| VehicleSpeed | 13 | 0.0625 | 0 | 0 | 0 |
| VehicleSpeedFailSts | 1 | 1 | 0 | 0 | 0 |

## BCAN · VEHICLE_SPEED_ODOMETER_B_ECM

| signal | bits | factor | offset | min | max |
|---|---|---|---|---|---|
| TravelDistanceAverage | 13 | 0.125 | 0 | 0 | 0 |
| VehicleSpeedAverage | 15 | 0.015625 | 0 | 0 | 0 |
| VehicleSpeedAverageValidData | 1 | 1 | 0 | 0 | 0 |

## BHCAN · IPC_VEHICLE_SETUP

| signal | bits | factor | offset | min | max |
|---|---|---|---|---|---|
| ConsumptionUnit | 3 | 1 | 0 | 0 | 0 |
| DistanceUnit | 1 | 1 | 0 | 0 | 0 |

## BHCAN · SERVICEINFO2

| signal | bits | factor | offset | min | max |
|---|---|---|---|---|---|
| DistanceToService | 17 | 1 | 0 | 0 | 131071 |

## BHCAN · STATUS_BH_BCM1

| signal | bits | factor | offset | min | max |
|---|---|---|---|---|---|
| BrakeFluidLevelSts | 1 | 1 | 0 | 0 | 0 |
| BrakePedalSwitchNOSts | 1 | 1 | 0 | 0 | 0 |
| FuelLevel | 8 | 1 | 0 | 0 | 255 |
| FuelLevelFailSts | 1 | 1 | 0 | 0 | 0 |

## BHCAN · STATUS_BH_BCM2

| signal | bits | factor | offset | min | max |
|---|---|---|---|---|---|
| ExternalTemperatureC | 9 | 0.5 | -85 | 0 | 511 |
| ExternalTemperatureFailSts | 1 | 1 | 0 | 0 | 0 |

## BHCAN · STATUS_BH_BCM2.DriveStyleSts

| signal | bits | factor | offset | min | max |
|---|---|---|---|---|---|
|  | 5 | 1 | 0 | 0 | 31 |

## BHCAN · STATUS_CCAN1_V1

| signal | bits | factor | offset | min | max |
|---|---|---|---|---|---|
| AFSts | 1 | 1 | 0 | 0 | 0 |
| AF_FailSts | 1 | 1 | 0 | 0 | 0 |

## BHCAN · STATUS_CCAN2

| signal | bits | factor | offset | min | max |
|---|---|---|---|---|---|
| TravelDistance | 8 | 1 | 0 | 0 | 255 |

## BHCAN · STATUS_CCAN3

| signal | bits | factor | offset | min | max |
|---|---|---|---|---|---|
| CompressorSts | 2 | 1 | 0 | 0 | 0 |
| ShiftModeSts | 1 | 1 | 0 | 0 | 0 |
| VehicleSpeedVSOSig | 13 | 0.0625 | 0 | 0 | 8191 |
| VehicleSpeedVSOSigFailSts | 1 | 1 | 0 | 0 | 0 |

## BHCAN · STATUS_CCAN4

| signal | bits | factor | offset | min | max |
|---|---|---|---|---|---|
| CNGGasolineMode | 1 | 1 | 0 | 0 | 0 |
| DPFSts | 1 | 1 | 0 | 0 | 0 |
| FuelConsumption_GAG | 16 | 0.0022 | 0 | 0 | 65535 |
| GPLGasolineMode | 1 | 1 | 0 | 0 | 0 |
| GearShiftIndication | 2 | 1 | 0 | 0 | 0 |
| OilLifeSts | 2 | 1 | 0 | 0 | 0 |
| ReverseGearSts | 2 | 1 | 0 | 0 | 3 |

## BHCAN · STATUS_CCAN5

| signal | bits | factor | offset | min | max |
|---|---|---|---|---|---|
| EngineSpeed | 14 | 1 | 0 | 0 | 16383 |
| EngineSpeedFailSts | 1 | 1 | 0 | 0 | 0 |

## BHCAN · STATUS_CCAN6

| signal | bits | factor | offset | min | max |
|---|---|---|---|---|---|
| InflationState_LHF_Tyre | 3 | 1 | 0 | 0 | 0 |
| TyrePressureSystemFailSts | 1 | 1 | 0 | 0 | 0 |

## BHCAN · STATUS_CCAN6.InflationState_LHR_Tyre

| signal | bits | factor | offset | min | max |
|---|---|---|---|---|---|
|  | 3 | 1 | 0 | 0 | 0 |

## BHCAN · STATUS_CCAN6.InflationState_RHF_Tyre

| signal | bits | factor | offset | min | max |
|---|---|---|---|---|---|
|  | 3 | 1 | 0 | 0 | 0 |

## BHCAN · STATUS_CCAN6.InflationState_RHR_Tyre

| signal | bits | factor | offset | min | max |
|---|---|---|---|---|---|
|  | 3 | 1 | 0 | 0 | 0 |

## BHCAN · TRIP_A

| signal | bits | factor | offset | min | max |
|---|---|---|---|---|---|
| AverageFuelConsumptionAPlus | 10 | 0.1 | 0 | 0 | 1023 |
| AverageSpeedAPlus | 8 | 1 | 0 | 0 | 255 |
| PartialOdometerAPlus | 20 | 0.1 | 0 | 0 | 1048575 |
| ResetTripAPlusACK | 2 | 1 | 0 | 0 | 0 |

## BHCAN · TRIP_A_B

| signal | bits | factor | offset | min | max |
|---|---|---|---|---|---|
| AutonomyDistance | 11 | 1 | 0 | 0 | 2047 |
| InstantaneousFuelConsumption1 | 4 | 1 | 0 | 0 | 15 |
| InstantaneousFuelConsumption2 | 4 | 1 | 0 | 0 | 15 |
| InstantaneousFuelConsumption3 | 4 | 1 | 0 | 0 | 15 |
| TotalOdometer | 20 | 1 | 0 | 0 | 0 |

## BHCAN · TRIP_B

| signal | bits | factor | offset | min | max |
|---|---|---|---|---|---|
| PartialOdometerBPlus | 20 | 0.1 | 0 | 0 | 1048575 |

