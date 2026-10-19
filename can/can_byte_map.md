# CAN byte map (Uconnect 8.4AN RA4 17.43.01, from canservice)

`d[n]` = data byte n (0-based, after the 2-byte ID the IOC prepends). Types: `b` bit field, `y` multi-byte number (last byte = MSB, per the firmware's Lua decoder; not checked on a live bus), `s` ASCII text, `j`/`z` native-only types (raw fields).
Tables 0-8 are the 9 CAN architectures in canservice; a signal listed with different tables has a different layout in each.

## 0x000  ·  bytes 0-0 used  ·  PPS: unknown

| bytes | bits | signal | type | decode | tables |
|---|---|---|---|---|---|
| 0 | ? (raw shift=0 mask=0x0) | zzz-NULL | z | `type z: raw byte 0` | 3,5 |
| 0 | ? (raw shift=0 mask=0x0) | zzz-null | z | `type z: raw byte 0` | 0,1,2,4,6,7,8 |

## 0x001  ·  bytes 0-0 used  ·  PPS: tester

| bytes | bits | signal | type | decode | tables |
|---|---|---|---|---|---|
| 0 | bit 0 | TestToolPresent | b | `d[0] & 0x1` | all |

## 0x008  ·  bytes 0-0 used  ·  PPS: vehcfg0

| bytes | bits | signal | type | decode | tables |
|---|---|---|---|---|---|
| 0 | bit 0 | EC_MIRROR_HK_PRSNT | b | `d[0] & 0x1` | 7 |

## 0x0FC  ·  bytes 0-1 used  ·  PPS: can_c

| bytes | bits | signal | type | decode | tables |
|---|---|---|---|---|---|
| 0-1 | 16-bit | EngineSpeed_C | y | `d[1]<<8 \| d[0]` | 3,5 |

## 0x101  ·  bytes 0-2 used  ·  PPS: can_c

| bytes | bits | signal | type | decode | tables |
|---|---|---|---|---|---|
| 0 | bits 0-7 | RAD_FAN1_STAT | b | `d[0] & 0xFF` | 1,2,3,4,5,6,7,8 |
| 1 | bit 0 | DPFRgnMode | b | `d[1] & 0x1` | all |
| 1 | bits 6-7 | RAD_FAN1_STAT | b | `(d[1] >> 6) & 0x3` | 0 |
| 1 | bit 5 | RearLockLastElSts | b | `(d[1] >> 5) & 0x1` | all |
| 1 | bit 4 | RechargeSts | b | `(d[1] >> 4) & 0x1` | all |
| 2 | bits 0-7 | EngLoad_OBD | b | `d[2] & 0xFF` | 0,6 |

## 0x102  ·  bytes 0-7 used  ·  PPS: can_c

| bytes | bits | signal | type | decode | tables |
|---|---|---|---|---|---|
| 0 | bit 0 | LRW_PLRTY | b | `d[0] & 0x1` | all |
| 2-3 | 16-bit | VLRW | y | `d[3]<<8 \| d[2]` | all |
| 4 | bits 0-1 | LRWS_ST | b | `d[4] & 0x3` | all |
| 4 | bits 2-4 | Pad_Shft | b | `(d[4] >> 2) & 0x7` | all |
| 6 | bits 0-3 | LRW_RHP | b | `d[6] & 0xF` | all |
| 6 | bits 4-7 | MC_STW_Angle_STAT | b | `(d[6] >> 4) & 0xF` | all |
| 7 | bits 0-7 | CRC_STW_Angle_STAT | b | `d[7] & 0xFF` | all |

## 0x10C  ·  bytes 0-1 used  ·  PPS: can_c

| bytes | bits | signal | type | decode | tables |
|---|---|---|---|---|---|
| 0-1 | 16-bit | EngTrq_Rq_ESC | y | `d[1]<<8 \| d[0]` | 0,1,2,3,4,6,7,8 |

## 0x112  ·  bytes 0-1 used  ·  PPS: can_c

| bytes | bits | signal | type | decode | tables |
|---|---|---|---|---|---|
| 1 | bit 7 | TeenKeyIsPresent | b | `(d[1] >> 7) & 0x1` | 6 |
| 1 | bit 7 | TeenKeyPrsnt | b | `(d[1] >> 7) & 0x1` | 0,1,2,3,4,5,7,8 |

## 0x120  ·  bytes 0-0 used  ·  PPS: can_c

| bytes | bits | signal | type | decode | tables |
|---|---|---|---|---|---|
| 0 | bits 0-7 | AccelPdlPosn | b | `d[0] & 0xFF` | all |

## 0x122  ·  bytes 0-1 used  ·  PPS: teenkey, vehcfg, vehctl, vehstat

| bytes | bits | signal | type | decode | tables |
|---|---|---|---|---|---|
| 0 | bits 0-2 | CmdIgnStat | b | `d[0] & 0x7` | all |
| 0 | bit 7 | RedKeyPrsnt | b | `(d[0] >> 7) & 0x1` | all |
| 0 | bit 6 | RemStActv | b | `(d[0] >> 6) & 0x1` | all |
| 0 | bits 3-5 | StTyp | b | `(d[0] >> 3) & 0x7` | all |
| 1 | bits 0-1 | KeyInIgn | b | `d[1] & 0x3` | all |
| 1 | bit 7 | TeenKeyIsPresent | b | `(d[1] >> 7) & 0x1` | 6 |

## 0x134  ·  bytes 0-1 used  ·  PPS: can_c

| bytes | bits | signal | type | decode | tables |
|---|---|---|---|---|---|
| 0 | bits 0-7 | MAP_ENG | b | `d[0] & 0xFF` | all |
| 1 | bits 0-7 | BARO_ENG | b | `d[1] & 0xFF` | all |

## 0x140  ·  bytes 0-1 used  ·  PPS: can_c

| bytes | bits | signal | type | decode | tables |
|---|---|---|---|---|---|
| 0 | bits 2-3 | BrkPdl_Stat | b | `(d[0] >> 2) & 0x3` | all |
| 1 | bit 6 | ABS_BrkEvt | b | `(d[1] >> 6) & 0x1` | all |
| 1 | bits 4-5 | SelSpdSts_CANC | b | `(d[1] >> 4) & 0x3` | all |

## 0x14B  ·  bytes 0-4 used  ·  PPS: can_c

| bytes | bits | signal | type | decode | tables |
|---|---|---|---|---|---|
| 0-1 | 16-bit | BrkPrss_TMC | y | `d[1]<<8 \| d[0]` | all |
| 4 | bits 0-5 | HSA_BrkPrss | b | `d[4] & 0x3F` | all |

## 0x14C  ·  bytes 0-3 used  ·  PPS: can_c

| bytes | bits | signal | type | decode | tables |
|---|---|---|---|---|---|
| 0 | bits 0-7 | VehYawRate_Offset | b | `d[0] & 0xFF` | all |
| 1 | bits 0-7 | VehAccel_X_Offset | b | `d[1] & 0xFF` | all |
| 2 | bits 4-7 | MC_VEH_DYN_STAT | b | `(d[2] >> 4) & 0xF` | all |
| 3 | bits 0-7 | VehAccel_Y_Offset | b | `d[3] & 0xFF` | all |

## 0x178  ·  bytes 0-2 used  ·  PPS: can_c

| bytes | bits | signal | type | decode | tables |
|---|---|---|---|---|---|
| 0 | bit 3 | TxTemp_Excess | b | `(d[0] >> 3) & 0x1` | 0,1,2,3,4,6,7,8 |
| 2 | bits 0-7 | RoboticTransmissionWarnings | b | `d[2] & 0xFF` | 0 |

## 0x180  ·  bytes 0-2 used  ·  PPS: can_c

| bytes | bits | signal | type | decode | tables |
|---|---|---|---|---|---|
| 0 | bits 0-7 | IntkAirTemp | b | `d[0] & 0xFF` | 0,6,7 |
| 1 | bit 1 | CHRG_FAIL | b | `(d[1] >> 1) & 0x1` | 0,1,2,3,4,6,7,8 |
| 2 | bits 0-7 | AirPress_Outsd | b | `d[2] & 0xFF` | all |

## 0x1C0  ·  bytes 0-0 used  ·  PPS: personal

| bytes | bits | signal | type | decode | tables |
|---|---|---|---|---|---|
| 0 | bit 7 | PE_ENABLE | b | `(d[0] >> 7) & 0x1` | all |

## 0x1C8  ·  bytes 0-2 used  ·  PPS: can_c

| bytes | bits | signal | type | decode | tables |
|---|---|---|---|---|---|
| 0 | bit 4 | DLY_5_SEC | b | `(d[0] >> 4) & 0x1` | all |
| 0 | bit 5 | LKOUT_1_MIN | b | `(d[0] >> 5) & 0x1` | all |
| 0 | bit 3 | MOT_DSBL_RQ | b | `(d[0] >> 3) & 0x1` | all |
| 0 | bits 0-2 | VTA_STAT | b | `d[0] & 0x7` | all |
| 1-2 | 16-bit | VTA_AUTH | y | `d[2]<<8 \| d[1]` | all |

## 0x1D0  ·  bytes 0-6 used  ·  PPS: can_c

| bytes | bits | signal | type | decode | tables |
|---|---|---|---|---|---|
| 0 | bit 4 | DSBL_PSG_LMP | b | `(d[0] >> 4) & 0x1` | all |
| 0 | bit 0 | EPP_FAULT | b | `d[0] & 0x1` | all |
| 0 | bits 5-6 | PsngrBagSts | b | `(d[0] >> 5) & 0x3` | all |
| 0 | bits 2-3 | SRS_IndLmp_Rq | b | `(d[0] >> 2) & 0x3` | 0,1,2,3,4,6,7,8 |
| 1 | bit 3 | OC_P_Flt_ORC | b | `(d[1] >> 3) & 0x1` | all |
| 1 | bits 0-2 | OC_P_ORC | b | `d[1] & 0x7` | all |
| 2 | bits 0-1 | DRV_SEATBELT | b | `d[2] & 0x3` | 0,1,2,3,4,6,7,8 |
| 2 | bits 2-3 | PSG_SEATBELT | b | `(d[2] >> 2) & 0x3` | 0,1,2,3,4,6,7,8 |
| 3 | bits 0-1 | OC_P_Fast_ORC | b | `d[3] & 0x3` | all |
| 3 | bits 2-3 | PSG_ODS_STAT | b | `(d[3] >> 2) & 0x3` | all |
| 4 | bits 0-2 | COD_Stat | b | `d[4] & 0x7` | all |
| 5 | bit 0 | SRS_DtlMsg01_Disp_Rq | b | `d[5] & 0x1` | all |
| 5 | bit 1 | SRS_DtlMsg02_Disp_Rq | b | `(d[5] >> 1) & 0x1` | all |
| 5 | bit 2 | SRS_DtlMsg03_Disp_Rq | b | `(d[5] >> 2) & 0x1` | all |
| 5 | bit 3 | SRS_DtlMsg04_Disp_Rq | b | `(d[5] >> 3) & 0x1` | all |
| 5 | bit 4 | SRS_DtlMsg05_Disp_Rq | b | `(d[5] >> 4) & 0x1` | all |
| 5 | bit 5 | SRS_DtlMsg06_Disp_Rq | b | `(d[5] >> 5) & 0x1` | all |
| 5 | bit 6 | SRS_DtlMsg07_Disp_Rq | b | `(d[5] >> 6) & 0x1` | all |
| 5 | bit 7 | SRS_DtlMsg08_Disp_Rq | b | `(d[5] >> 7) & 0x1` | all |
| 6 | bit 7 | AirBagFailSts | b | `(d[6] >> 7) & 0x1` | 0 |
| 6 | bit 0 | SRS_DtlMsg09_Disp_Rq | b | `d[6] & 0x1` | all |
| 6 | bit 1 | SRS_DtlMsg10_Disp_Rq | b | `(d[6] >> 1) & 0x1` | all |
| 6 | bit 2 | SRS_DtlMsg11_Disp_Rq | b | `(d[6] >> 2) & 0x1` | all |
| 6 | bit 3 | SRS_DtlMsg12_Disp_Rq | b | `(d[6] >> 3) & 0x1` | all |
| 6 | bit 4 | SRS_DtlMsg13_Disp_Rq | b | `(d[6] >> 4) & 0x1` | all |
| 6 | bit 5 | SRS_DtlMsg14_Disp_Rq | b | `(d[6] >> 5) & 0x1` | all |
| 6 | bit 6 | SRS_DtlMsg15_Disp_Rq | b | `(d[6] >> 6) & 0x1` | all |
| 6 | bit 7 | SRS_DtlMsg16_Disp_Rq | b | `(d[6] >> 7) & 0x1` | all |

## 0x1D2  ·  bytes 0-1 used  ·  PPS: can_c

| bytes | bits | signal | type | decode | tables |
|---|---|---|---|---|---|
| 0 | bit 0 | IMPACT_A | b | `d[0] & 0x1` | all |
| 0 | bit 1 | IMPACT_B | b | `(d[0] >> 1) & 0x1` | all |
| 0 | bit 2 | IMPACT_C | b | `(d[0] >> 2) & 0x1` | all |
| 0 | bit 3 | IMPACT_D | b | `(d[0] >> 3) & 0x1` | all |
| 0 | bit 4 | IMPACT_E | b | `(d[0] >> 4) & 0x1` | all |
| 0 | bit 5 | IMPACT_F | b | `(d[0] >> 5) & 0x1` | all |
| 0 | bit 6 | IMPACT_G | b | `(d[0] >> 6) & 0x1` | all |
| 0 | bit 7 | IMPACT_Tgl | b | `(d[0] >> 7) & 0x1` | all |
| 1 | bit 0 | IMPACT_H | b | `d[1] & 0x1` | all |
| 1 | bit 1 | IMPACT_I | b | `(d[1] >> 1) & 0x1` | all |
| 1 | bit 2 | IMPACT_K | b | `(d[1] >> 2) & 0x1` | all |
| 1 | bit 3 | IMPACT_L | b | `(d[1] >> 3) & 0x1` | all |
| 1 | bit 4 | IMPACT_M | b | `(d[1] >> 4) & 0x1` | all |
| 1 | bit 5 | IMPACT_N | b | `(d[1] >> 5) & 0x1` | all |
| 1 | bit 6 | IMPACT_O | b | `(d[1] >> 6) & 0x1` | all |
| 1 | bit 7 | IMPACT_X | b | `(d[1] >> 7) & 0x1` | all |

## 0x1F4  ·  bytes 0-1 used  ·  PPS: can_c

| bytes | bits | signal | type | decode | tables |
|---|---|---|---|---|---|
| 0-1 | 16-bit | EngTrq_Rq_DAS | y | `d[1]<<8 \| d[0]` | 0,1,6,7 |

## 0x212  ·  bytes 0-1 used  ·  PPS: can_c

| bytes | bits | signal | type | decode | tables |
|---|---|---|---|---|---|
| 0 | bit 3 | PreHtIndLmp_On_Rq | b | `(d[0] >> 3) & 0x1` | all |
| 1 | bits 0-1 | PFW | b | `d[1] & 0x3` | all |
| 1 | bit 6 | WtrFuelIndLmp_On_Rq | b | `(d[1] >> 6) & 0x1` | 0,1,2,3,4,6,7,8 |

## 0x22D  ·  bytes 0-5 used  ·  PPS: audioctl

| bytes | bits | signal | type | decode | tables |
|---|---|---|---|---|---|
| 0 | bits 0-1 | Command_01 | b | `d[0] & 0x3` | all |
| 0 | bits 2-3 | Command_02 | b | `(d[0] >> 2) & 0x3` | all |
| 0 | bits 4-5 | Command_03 | b | `(d[0] >> 4) & 0x3` | all |
| 0 | bits 6-7 | Command_04 | b | `(d[0] >> 6) & 0x3` | all |
| 1 | bits 0-1 | Command_05 | b | `d[1] & 0x3` | all |
| 1 | bits 2-3 | Command_06 | b | `(d[1] >> 2) & 0x3` | all |
| 1 | bits 4-5 | Command_07 | b | `(d[1] >> 4) & 0x3` | all |
| 1 | bits 6-7 | Command_08 | b | `(d[1] >> 6) & 0x3` | all |
| 2 | bits 0-1 | Command_09 | b | `d[2] & 0x3` | all |
| 2 | bits 2-3 | Command_10 | b | `(d[2] >> 2) & 0x3` | all |
| 2 | bits 4-5 | Command_11 | b | `(d[2] >> 4) & 0x3` | all |
| 2 | bits 6-7 | Command_12 | b | `(d[2] >> 6) & 0x3` | all |
| 3 | bits 0-1 | Command_13 | b | `d[3] & 0x3` | all |
| 3 | bits 2-3 | Command_14 | b | `(d[3] >> 2) & 0x3` | all |
| 3 | bits 4-5 | Command_15 | b | `(d[3] >> 4) & 0x3` | all |
| 3 | bits 6-7 | Command_16 | b | `(d[3] >> 6) & 0x3` | all |
| 4 | bits 0-6 | Focus | b | `d[4] & 0x7F` | all |
| 4 | bit 7 | Status_OK | b | `(d[4] >> 7) & 0x1` | all |
| 5 | bits 0-3 | List | b | `d[5] & 0xF` | all |
| 5 | bit 4 | Status_Down | b | `(d[5] >> 4) & 0x1` | all |
| 5 | bit 5 | Status_Left | b | `(d[5] >> 5) & 0x1` | all |
| 5 | bit 6 | Status_Right | b | `(d[5] >> 6) & 0x1` | all |
| 5 | bit 7 | Status_Up | b | `(d[5] >> 7) & 0x1` | all |

## 0x22F  ·  bytes 0-3 used  ·  PPS: vehstat

| bytes | bits | signal | type | decode | tables |
|---|---|---|---|---|---|
| 2 | bits 0-7 | IntkAirTempIntrClr | b | `d[2] & 0xFF` | 0,6 |
| 2 | bits 0-7 | LTR_CoolantTemp | b | `d[2] & 0xFF` | 7 |
| 3 | bits 0-7 | IntkAirTempIntrClr | b | `d[3] & 0xFF` | 7 |
| 3 | bits 0-7 | LTR_CoolantTemp | b | `d[3] & 0xFF` | 0,6 |

## 0x230  ·  bytes 0-2 used  ·  PPS: comfortstat

| bytes | bits | signal | type | decode | tables |
|---|---|---|---|---|---|
| 0 | bit 7 | AQS_Active | b | `(d[0] >> 7) & 0x1` | all |
| 0 | bit 3 | DEFROST_SEL | b | `(d[0] >> 3) & 0x1` | all |
| 0 | bits 0-2 | SpSt_Pad1 | b | `d[0] & 0x7` | all |
| 0 | bits 4-6 | SpSt_Pad2 | b | `(d[0] >> 4) & 0x7` | all |
| 1 | bits 0-7 | EVAP_TEMP | b | `d[1] & 0xFF` | all |
| 2 | bits 0-7 | EvapTempTar | b | `d[2] & 0xFF` | all |

## 0x232  ·  bytes 0-7 used  ·  PPS: location, vehstat

| bytes | bits | signal | type | decode | tables |
|---|---|---|---|---|---|
| 0 | bits 0-7 | EngOilTemp | b | `d[0] & 0xFF` | all |
| 1 | bits 0-7 | TX_TEMP | b | `d[1] & 0xFF` | all |
| 3 | bits 0-7 | ACT_CNT_DIF_TRQ | b | `d[3] & 0xFF` | all |
| 4-5 | 16-bit | LT_DIST | y | `d[5]<<8 \| d[4]` | all |
| 6-7 | 16-bit | RT_DIST | y | `d[7]<<8 \| d[6]` | all |

## 0x248  ·  bytes 0-0 used  ·  PPS: vehstat

| bytes | bits | signal | type | decode | tables |
|---|---|---|---|---|---|
| 0 | bit 7 | Batt_ST_Crit | b | `(d[0] >> 7) & 0x1` | all |
| 0 | bits 1-2 | PN14_Key_Off_Load_Shed | b | `(d[0] >> 1) & 0x3` | all |
| 0 | bit 0 | PN14_LS_Actv | b | `d[0] & 0x1` | all |
| 0 | bit 5 | PN14_LS_Lvl5 | b | `(d[0] >> 5) & 0x1` | all |
| 0 | bit 6 | PN14_LS_Lvl7 | b | `(d[0] >> 6) & 0x1` | all |

## 0x24E  ·  bytes 0-4 used  ·  PPS: vehstat

| bytes | bits | signal | type | decode | tables |
|---|---|---|---|---|---|
| 0-1 | 16-bit | FuelCons | y | `d[1]<<8 \| d[0]` | all |
| 2 | bits 5-7 | EngRunFuelTyp | b | `(d[2] >> 5) & 0x7` | all |
| 3 | bits 0-7 | Roll_Angle | b | `d[3] & 0xFF` | all |
| 4 | bits 0-7 | Pitch_Angle | b | `d[4] & 0xFF` | all |

## 0x252  ·  bytes 0-7 used  ·  PPS: vehstat

| bytes | bits | signal | type | decode | tables |
|---|---|---|---|---|---|
| 0 | bits 0-1 | FUEL_SAV_MD_ACT | b | `d[0] & 0x3` | all |
| 1 | bits 0-7 | IntkAirTemp | b | `d[1] & 0xFF` | 1,2,3,4,5,8 |
| 2-3 | 16-bit | LRW | y | `d[3]<<8 \| d[2]` | all |
| 4-5 | 16-bit | VehYawRate_Raw | y | `d[5]<<8 \| d[4]` | all |
| 6 | bits 0-7 | VehAccel_X | b | `d[6] & 0xFF` | all |
| 7 | bits 0-7 | VehAccel_Y | b | `d[7] & 0xFF` | all |

## 0x280  ·  bytes 0-0 used  ·  PPS: personal

| bytes | bits | signal | type | decode | tables |
|---|---|---|---|---|---|
| 0 | bits 0-1 | Mem_D_Pos_Rq | b | `d[0] & 0x3` | all |
| 0 | bit 2 | Mem_D_Rc_Rq | b | `(d[0] >> 2) & 0x1` | all |
| 0 | bit 3 | Mem_D_Sv_Rq | b | `(d[0] >> 3) & 0x1` | all |

## 0x290  ·  bytes 0-3 used  ·  PPS: can_c

| bytes | bits | signal | type | decode | tables |
|---|---|---|---|---|---|
| 0 | bits 0-7 | UConnSeed1 | b | `d[0] & 0xFF` | all |
| 1 | bits 0-7 | UConnSeed2 | b | `d[1] & 0xFF` | all |
| 2 | bits 0-7 | UConnSeed3 | b | `d[2] & 0xFF` | all |
| 3 | bits 0-7 | UConnSeed4 | b | `d[3] & 0xFF` | all |

## 0x29D  ·  bytes 0-2 used  ·  PPS: can_c

| bytes | bits | signal | type | decode | tables |
|---|---|---|---|---|---|
| 0 | bits 0-7 | BSMBrkReq | b | `d[0] & 0xFF` | all |
| 1 | bit 0 | BSMBrkReqActive | b | `d[1] & 0x1` | all |
| 1 | bits 1-3 | EPBHoldSts | b | `(d[1] >> 1) & 0x7` | all |
| 1 | bits 4-7 | MC_EPB_A1 | b | `(d[1] >> 4) & 0xF` | all |
| 2 | bits 0-7 | CRC_EPB_A1 | b | `d[2] & 0xFF` | all |

## 0x2A0  ·  bytes 0-5 used  ·  PPS: can_c, vehstat

| bytes | bits | signal | type | decode | tables |
|---|---|---|---|---|---|
| 0 | bits 0-2 | DCSD_TCH_STAT | b | `d[0] & 0x7` | 6 |
| 0 | bits 2-3 | ETC_IND_LMP | b | `(d[0] >> 2) & 0x3` | 1,2,3,4,7,8 |
| 0 | bits 4-5 | MZR_MODE_ACT | b | `(d[0] >> 4) & 0x3` | 1,2,3,4,5,7,8 |
| 1 | bit 7 | ChkFuelCap | b | `(d[1] >> 7) & 0x1` | 1,2,3,4,7,8 |
| 1 | bit 2 | EngOilIndLmp_On_Rq | b | `(d[1] >> 2) & 0x1` | 1,2,3,4,7,8 |
| 1 | bits 5-6 | OIL_TEMP_CHM_RQ | b | `(d[1] >> 5) & 0x3` | 1,2,3,4,5,7,8 |
| 1 | bits 3-4 | OIL_TEMP_IND_RQ | b | `(d[1] >> 3) & 0x3` | 1,2,3,4,7,8 |
| 2 | bits 0-7 | OIL_PRESS | b | `d[2] & 0xFF` | 1,2,3,4,5,7,8 |
| 3-2 | 0-bit | DCSD_TCH_X_COORD | y | `` | 6 |
| 5 | bits 0-2 | DCSD_DISP_STAT | b | `d[5] & 0x7` | 6 |
| 5-4 | 0-bit | DCSD_TCH_Y_COORD | y | `` | 6 |

## 0x2AD  ·  bytes 0-2 used  ·  PPS: vehcfg, vehstat

| bytes | bits | signal | type | decode | tables |
|---|---|---|---|---|---|
| 0 | bit 5 | CBC_AUX1_PWRMD | b | `(d[0] >> 5) & 0x1` | all |
| 0 | bit 0 | CBC_AUX1_Type | b | `d[0] & 0x1` | all |
| 0 | bit 6 | CBC_AUX2_PWRMD | b | `(d[0] >> 6) & 0x1` | all |
| 0 | bit 1 | CBC_AUX2_Type | b | `(d[0] >> 1) & 0x1` | all |
| 0 | bit 7 | CBC_AUX3_PWRMD | b | `(d[0] >> 7) & 0x1` | all |
| 0 | bit 2 | CBC_AUX3_Type | b | `(d[0] >> 2) & 0x1` | all |
| 0 | bit 3 | CBC_AUX4_Type | b | `(d[0] >> 3) & 0x1` | all |
| 0 | bit 4 | CBC_AUX5_Type | b | `(d[0] >> 4) & 0x1` | all |
| 1 | bit 2 | CBC_AUX1_HLEnbl | b | `(d[1] >> 2) & 0x1` | all |
| 1 | bit 3 | CBC_AUX2_HLEnbl | b | `(d[1] >> 3) & 0x1` | all |
| 1 | bit 4 | CBC_AUX3_HLEnbl | b | `(d[1] >> 4) & 0x1` | all |
| 1 | bit 5 | CBC_AUX4_HLEnbl | b | `(d[1] >> 5) & 0x1` | all |
| 1 | bit 0 | CBC_AUX4_PWRMD | b | `d[1] & 0x1` | all |
| 1 | bit 6 | CBC_AUX5_HLEnbl | b | `(d[1] >> 6) & 0x1` | all |
| 1 | bit 1 | CBC_AUX5_PWRMD | b | `(d[1] >> 1) & 0x1` | all |
| 2 | bits 0-2 | Cfg_Aux_PTO | b | `d[2] & 0x7` | all |

## 0x2C2  ·  bytes 0-2 used  ·  PPS: comfortstat, vehstat

| bytes | bits | signal | type | decode | tables |
|---|---|---|---|---|---|
| 0-1 | 16-bit | AMB_TEMP_AVG | y | `d[1]<<8 \| d[0]` | all |
| 2 | bits 0-7 | BATT_VOLT | b | `d[2] & 0xFF` | all |

## 0x2C3  ·  bytes 0-7 used  ·  PPS: vehstat

| bytes | bits | signal | type | decode | tables |
|---|---|---|---|---|---|
| 0 | bits 0-7 | WhlPlsCnt_FL | b | `d[0] & 0xFF` | all |
| 1 | bits 0-7 | WhlPlsCnt_FR | b | `d[1] & 0xFF` | all |
| 2 | bits 0-7 | WhlPlsCnt_RL | b | `d[2] & 0xFF` | all |
| 3 | bits 0-7 | WhlPlsCnt_RR | b | `d[3] & 0xFF` | all |
| 4-5 | 16-bit | VehPerfAccel_X | y | `d[5]<<8 \| d[4]` | all |
| 6-7 | 16-bit | VehPerfAccel_Y | y | `d[7]<<8 \| d[6]` | all |

## 0x2C5  ·  bytes 0-3 used  ·  PPS: vehcfg0

| bytes | bits | signal | type | decode | tables |
|---|---|---|---|---|---|
| 0 | bit 7 | DRIVE_MODE | b | `(d[0] >> 7) & 0x1` | 6 |
| 0 | bits 0-1 | EC_ECUCfg16_Stat | b | `d[0] & 0x3` | 6 |
| 0 | bit 2 | OC_Dsbl_LF | b | `(d[0] >> 2) & 0x1` | 6,7 |
| 0 | bit 4 | OC_Dsbl_LR | b | `(d[0] >> 4) & 0x1` | 6,7 |
| 0 | bit 3 | OC_Dsbl_RF | b | `(d[0] >> 3) & 0x1` | 6,7 |
| 0 | bit 5 | OC_Dsbl_RR | b | `(d[0] >> 5) & 0x1` | 6,7 |
| 0 | bit 6 | SVC_SK_PRSNT | b | `(d[0] >> 6) & 0x1` | 6 |
| 1-2 | 16-bit | CPD | y | `d[2]<<8 \| d[1]` | 6,7 |
| 3 | bit 5 | ACN_PRSNT | b | `(d[3] >> 5) & 0x1` | 6 |
| 3 | bit 4 | Clari_FI_PRSNT | b | `(d[3] >> 4) & 0x1` | 6 |
| 3 | bits 0-1 | DEFROST_MODE | b | `d[3] & 0x3` | 6 |
| 3 | bit 3 | EC_MIRROR_HK_PRSNT | b | `(d[3] >> 3) & 0x1` | 6 |
| 3 | bit 2 | PhoneInfoInCluster | b | `(d[3] >> 2) & 0x1` | 6 |
| 3 | bit 6 | RVC_SK_PRSNT | b | `(d[3] >> 6) & 0x1` | 6 |

## 0x2D0  ·  bytes 0-2 used  ·  PPS: personal, teenkey

| bytes | bits | signal | type | decode | tables |
|---|---|---|---|---|---|
| 1 | bits 0-1 | BSM_CFG_STAT | b | `d[1] & 0x3` | all |
| 1 | bit 4 | BSM_MUTE_RQ | b | `(d[1] >> 4) & 0x1` | all |
| 1 | bit 3 | BSM_OPR_STAT | b | `(d[1] >> 3) & 0x1` | 6 |
| 1 | bit 2 | BSM_SRV_RQ | b | `(d[1] >> 2) & 0x1` | all |
| 2 | bits 2-3 | BSM_OPR_STAT | b | `(d[2] >> 2) & 0x3` | 0 |
| 2 | bit 2 | BSS_LT_OPR_StatSts | b | `(d[2] >> 2) & 0x1` | 0 |
| 2 | bit 3 | BSS_RT_OPR_StatSts | b | `(d[2] >> 3) & 0x1` | 0 |
| 2 | bits 0-1 | TeenKeyBSM_ConfigStatus | b | `d[2] & 0x3` | 6 |

## 0x2D3  ·  bytes 0-7 used  ·  PPS: vehstat

| bytes | bits | signal | type | decode | tables |
|---|---|---|---|---|---|
| 0 | bits 0-2 | ICS_DISP_STAT | b | `d[0] & 0x7` | 6 |
| 2 | bit 0 | ICS_btn_0 | b | `d[2] & 0x1` | 6 |
| 2 | bit 1 | ICS_btn_1 | b | `(d[2] >> 1) & 0x1` | 6 |
| 2 | bit 2 | ICS_btn_2 | b | `(d[2] >> 2) & 0x1` | 6 |
| 2 | bit 3 | ICS_btn_3 | b | `(d[2] >> 3) & 0x1` | 6 |
| 2 | bit 4 | ICS_btn_4 | b | `(d[2] >> 4) & 0x1` | 6 |
| 2 | bit 5 | ICS_btn_5 | b | `(d[2] >> 5) & 0x1` | 6 |
| 2 | bit 6 | ICS_btn_6 | b | `(d[2] >> 6) & 0x1` | 6 |
| 2 | bit 7 | ICS_btn_7 | b | `(d[2] >> 7) & 0x1` | 6 |
| 3 | bit 4 | ICS_btn_12 | b | `(d[3] >> 4) & 0x1` | all |
| 3 | bit 5 | ICS_btn_13 | b | `(d[3] >> 5) & 0x1` | all |
| 3 | bit 1 | ICS_btn_9 | b | `(d[3] >> 1) & 0x1` | 6 |
| 5 | bit 0 | ICS_btn_24 | b | `d[5] & 0x1` | 0,6 |
| 5 | bit 2 | ICS_btn_26 | b | `(d[5] >> 2) & 0x1` | 3,5,6 |
| 5 | bit 3 | ICS_btn_27 | b | `(d[5] >> 3) & 0x1` | 3,5,6 |
| 5 | bit 4 | ICS_btn_28 | b | `(d[5] >> 4) & 0x1` | 0,6 |
| 5 | bit 5 | ICS_btn_29 | b | `(d[5] >> 5) & 0x1` | 0,6 |
| 5 | bit 6 | ICS_btn_30 | b | `(d[5] >> 6) & 0x1` | 3,5,6 |
| 5 | bit 7 | ICS_btn_31 | b | `(d[5] >> 7) & 0x1` | 3,5,6 |
| 6 | bit 3 | ICS_FT_HVAC_MD_Cntrl | b | `(d[6] >> 3) & 0x1` | 6 |
| 7 | bit 6 | ICS_btn_46 | b | `(d[7] >> 6) & 0x1` | 6 |
| 7 | bits 3-4 | ICS_launch_hardbtn_status | b | `(d[7] >> 3) & 0x3` | all |

## 0x2DE  ·  bytes 0-0 used  ·  PPS: vehstat

| bytes | bits | signal | type | decode | tables |
|---|---|---|---|---|---|
| 0 | bit 7 | AudioMuteRq_TBM | b | `(d[0] >> 7) & 0x1` | 5,6 |

## 0x2DF  ·  bytes 0-0 used  ·  PPS: personal, vehstat

| bytes | bits | signal | type | decode | tables |
|---|---|---|---|---|---|
| 0 | bit 7 | DynamicGridRespSts | b | `(d[0] >> 7) & 0x1` | 6 |
| 0 | bit 6 | ImageDefeatRQSts | b | `(d[0] >> 6) & 0x1` | 6 |

## 0x2E0  ·  bytes 0-8 used  ·  PPS: can_c, notification, suspension

| bytes | bits | signal | type | decode | tables |
|---|---|---|---|---|---|
| 0 | bits 4-7 | ASCM_Stat | b | `(d[0] >> 4) & 0xF` | 1,2,3,4,5,7,8 |
| 0 | bit 6 | ESP_Off_IndLmp_On_Rq | b | `(d[0] >> 6) & 0x1` | 8 |
| 0 | bits 0-3 | TerMdStat | b | `d[0] & 0xF` | all |
| 1 | bits 2-3 | ABS_IndLmp_On_Rq | b | `(d[1] >> 2) & 0x3` | 8 |
| 1 | bits 4-5 | BrkIndLmp_On_Rq_ESC | b | `(d[1] >> 4) & 0x3` | 8 |
| 1 | bits 0-1 | ESC_CtrlLmp_Info | b | `d[1] & 0x3` | 8 |
| 1 | bits 6-7 | SelSpdSts | b | `(d[1] >> 6) & 0x3` | all |
| 2 | bits 0-7 | ACT_R_DIF_TRQ | b | `d[2] & 0xFF` | all |
| 3 | bits 0-7 | FL_Lvl | b | `d[3] & 0xFF` | all |
| 4 | bits 0-7 | FR_Lvl | b | `d[4] & 0xFF` | all |
| 5 | bits 0-7 | RL_Lvl | b | `d[5] & 0xFF` | all |
| 6 | bits 0-7 | RR_Lvl | b | `d[6] & 0xFF` | all |
| 7 | bits 4-7 | HALF_CHIME_REP_RATE | b | `(d[7] >> 4) & 0xF` | 6,7 |
| 7 | bits 4-7 | HALF_CHIME_REP_RATESts | b | `(d[7] >> 4) & 0xF` | 8 |
| 7 | bits 0-3 | HALF_CHIME_TYPE | b | `d[7] & 0xF` | 6,7 |
| 7 | bits 0-3 | HALF_CHIME_TYPESts | b | `d[7] & 0xF` | 8 |
| 8 | bit 0 | HALF_LF_CHIME_RQ | b | `d[8] & 0x1` | 6,7 |
| 8 | bit 0 | HALF_LF_CHIME_RQSts | b | `d[8] & 0x1` | 8 |
| 8 | bit 1 | HALF_RF_CHIME_RQ | b | `(d[8] >> 1) & 0x1` | 6,7 |
| 8 | bit 1 | HALF_RF_CHIME_RQSts | b | `(d[8] >> 1) & 0x1` | 8 |

## 0x2E2  ·  bytes 0-0 used  ·  PPS: personal

| bytes | bits | signal | type | decode | tables |
|---|---|---|---|---|---|
| 0 | bit 5 | AutoFoldMirrorDriver | b | `(d[0] >> 5) & 0x1` | 6 |
| 0 | bit 4 | TILT_IN_REV_D | b | `(d[0] >> 4) & 0x1` | all |

## 0x2EA  ·  bytes 0-0 used  ·  PPS: vehstat

| bytes | bits | signal | type | decode | tables |
|---|---|---|---|---|---|
| 0 | bit 2 | HFM_MD_RQ | b | `(d[0] >> 2) & 0x1` | all |

## 0x2F0  ·  bytes 0-0 used  ·  PPS: personal, unknown

| bytes | bits | signal | type | decode | tables |
|---|---|---|---|---|---|
| 0 | bits 1-2 | EASY_EXIT | b | `(d[0] >> 1) & 0x3` | all |
| 0 | bits 3-5 | MEM_RC_STAT | b | `(d[0] >> 3) & 0x7` | all |
| 0 | bit 0 | RKE_MEM | b | `d[0] & 0x1` | all |

## 0x2F2  ·  bytes 0-0 used  ·  PPS: personal

| bytes | bits | signal | type | decode | tables |
|---|---|---|---|---|---|
| 0 | bit 5 | PassWinLO_Enbl | b | `(d[0] >> 5) & 0x1` | all |
| 0 | bit 4 | TILT_IN_REV_P | b | `(d[0] >> 4) & 0x1` | all |

## 0x2F8  ·  bytes 0-3 used  ·  PPS: personal, teenkey, vehstat

| bytes | bits | signal | type | decode | tables |
|---|---|---|---|---|---|
| 0 | bits 0-4 | TextDisplay | b | `d[0] & 0x1F` | 6 |
| 1 | bits 5-6 | AutoParkSts | b | `(d[1] >> 5) & 0x3` | 6 |
| 1 | bits 1-2 | FCWSetting | b | `(d[1] >> 1) & 0x3` | 6 |
| 1 | bit 0 | FCWState | b | `d[1] & 0x1` | 6 |
| 1 | bit 7 | ServiceModeSts | b | `(d[1] >> 7) & 0x1` | 6 |
| 1 | bits 3-4 | TeenKeyFCWSensitivitySetting | b | `(d[1] >> 3) & 0x3` | 6 |
| 2 | bit 0 | TeenKeyFCWBrakingAssistStatus | b | `d[2] & 0x1` | 6 |
| 2 | bit 7 | TeenKeyPTS_BrakingAssistStatus | b | `(d[2] >> 7) & 0x1` | 6 |
| 2 | bits 1-2 | TeenKeyPTS_ConfigStatus | b | `(d[2] >> 1) & 0x3` | 6 |
| 2 | bits 3-4 | TeenKeyPTS_FrontVolume | b | `(d[2] >> 3) & 0x3` | 6 |
| 2 | bits 5-6 | TeenKeyPTS_RearVolume | b | `(d[2] >> 5) & 0x3` | 6 |
| 3 | bits 6-7 | RrAxleLkIndRq | b | `(d[3] >> 6) & 0x3` | 6 |

## 0x2FA  ·  bytes 0-7 used  ·  PPS: can_c, compact, personal, vehctl, vehstat

| bytes | bits | signal | type | decode | tables |
|---|---|---|---|---|---|
| 0 | bit 0 | DRV_AJAR | b | `d[0] & 0x1` | all |
| 0 | bit 6 | DR_LKD | b | `(d[0] >> 6) & 0x1` | all |
| 0 | bit 4 | FG_AJAR | b | `(d[0] >> 4) & 0x1` | all |
| 0 | bit 2 | L_R_AJAR | b | `(d[0] >> 2) & 0x1` | all |
| 0 | bit 1 | PSG_AJAR | b | `(d[0] >> 1) & 0x1` | all |
| 0 | bit 3 | R_R_AJAR | b | `(d[0] >> 3) & 0x1` | all |
| 0 | bit 5 | TLG_AJAR | b | `(d[0] >> 5) & 0x1` | all |
| 1 | bit 0 | DAY_LGT_MD | b | `d[1] & 0x1` | all |
| 1 | bit 2 | PoliceStlthMdAct | b | `(d[1] >> 2) & 0x1` | all |
| 2 | bits 0-7 | PANEL_INTS | b | `d[2] & 0xFF` | all |
| 3 | bits 2-3 | DR_LK_STAT | b | `(d[3] >> 2) & 0x3` | all |
| 3 | bits 5-7 | DriveStyleSts | b | `(d[3] >> 5) & 0x7` | 0,1,2,4,6,7,8 |
| 3 | bit 1 | PARK_BRK_EGD | b | `(d[3] >> 1) & 0x1` | all |
| 3 | bit 0 | REV_GEAR | b | `d[3] & 0x1` | all |
| 3 | bit 4 | RR_DR_UNLKD | b | `(d[3] >> 4) & 0x1` | all |
| 4 | bits 0-7 | MOOD_LGT_INTS | b | `d[4] & 0xFF` | all |
| 5 | bits 0-7 | FuelLevel | b | `d[5] & 0xFF` | all |
| 6 | bit 1 | BrakeFluidLevelSts | b | `(d[6] >> 1) & 0x1` | all |
| 6 | bit 0 | FuelLevelFailSts | b | `d[6] & 0x1` | all |
| 6 | bit 2 | IceRiskIndication | b | `(d[6] >> 2) & 0x1` | all |
| 6 | bit 3 | WASH_FLUID_LO | b | `(d[6] >> 3) & 0x1` | 5 |
| 7 | bits 0-4 | GlobalDriveModeStatus | b | `d[7] & 0x1F` | 6 |

## 0x2FF  ·  bytes 0-7 used  ·  PPS: vehstat

| bytes | bits | signal | type | decode | tables |
|---|---|---|---|---|---|
| 4 | bits 0-7 | LTR_CoolantTemp | b | `d[4] & 0xFF` | 1,2,3,4,5,8 |
| 5 | bits 0-7 | IntkAirTempIntrClr | b | `d[5] & 0xFF` | 1,2,3,4,5,8 |
| 6 | bits 0-7 | AirFuelRatio | b | `d[6] & 0xFF` | all |
| 7 | bits 0-7 | BoostVacGauge | b | `d[7] & 0xFF` | all |

## 0x304  ·  bytes 0-7 used  ·  PPS: can_c

| bytes | bits | signal | type | decode | tables |
|---|---|---|---|---|---|
| 0 | bits 0-1 | TPM_IndLmp_On_Rq | b | `d[0] & 0x3` | 0,1,2,3,4,6,7,8 |
| 0 | bit 2 | Type | b | `(d[0] >> 2) & 0x1` | all |
| 1 | bits 0-1 | TireFL | b | `d[1] & 0x3` | all |
| 1 | bits 2-3 | TireFR | b | `(d[1] >> 2) & 0x3` | all |
| 1 | bits 6-7 | TireRL | b | `(d[1] >> 6) & 0x3` | all |
| 1 | bits 4-5 | TireRR | b | `(d[1] >> 4) & 0x3` | all |
| 3 | bits 0-7 | TirePressFL | b | `d[3] & 0xFF` | 0,1,2,3,4,6,7,8 |
| 4 | bits 0-7 | TirePressFR | b | `d[4] & 0xFF` | 0,1,2,3,4,6,7,8 |
| 5 | bits 0-7 | TirePressRL | b | `d[5] & 0xFF` | 0,1,2,3,4,6,7,8 |
| 6 | bits 0-7 | TirePressRR | b | `d[6] & 0xFF` | 0,1,2,3,4,6,7,8 |
| 7 | bit 0 | SensorFailSts | b | `d[7] & 0x1` | 0 |

## 0x305  ·  bytes 0-7 used  ·  PPS: personal, vehstat

| bytes | bits | signal | type | decode | tables |
|---|---|---|---|---|---|
| 1 | bit 6 | DrvMdHMI_1 | b | `(d[1] >> 6) & 0x1` | 6 |
| 1 | bit 7 | DrvMdHMI_2 | b | `(d[1] >> 7) & 0x1` | 6 |
| 2 | bit 0 | DrvMdHMI_3 | b | `d[2] & 0x1` | 6 |
| 2 | bit 1 | DrvMdHMI_4 | b | `(d[2] >> 1) & 0x1` | 6 |
| 2 | bits 4-7 | TerAWD_DrvMd_CfgSts | b | `(d[2] >> 4) & 0xF` | 6 |
| 3 | bits 0-7 | Trans_DrvMd_CfgSts | b | `d[3] & 0xFF` | 6 |
| 4 | bits 6-7 | ADC_DrvMd_CfgSts | b | `(d[4] >> 6) & 0x3` | 6 |
| 4 | bits 0-2 | EPS_DrvMd_CfgSts | b | `d[4] & 0x7` | 6 |
| 4 | bits 3-5 | ESC_DrvMd_CfgSts | b | `(d[4] >> 3) & 0x7` | 6 |
| 5 | bits 3-5 | Eng_DrvMd_CfgSts | b | `(d[5] >> 3) & 0x7` | 6 |
| 5 | bits 0-2 | HP_DrvMd_CfgSts | b | `d[5] & 0x7` | 6 |
| 5 | bits 6-7 | Paddles_DrvMd_CfgSts | b | `(d[5] >> 6) & 0x3` | 6 |
| 6 | bits 6-8 | E_Mode_Sts | b | `(d[6] >> 6) & 0x7` | 0,6 |
| 6 | bits 1-2 | SettingsPaddleModeCfgStat | b | `(d[6] >> 1) & 0x3` | 6 |
| 7 | bit 0 | ErrSys_1 | b | `d[7] & 0x1` | 6 |
| 7 | bit 1 | ErrSys_2 | b | `(d[7] >> 1) & 0x1` | 6 |
| 7 | bit 2 | ErrSys_3 | b | `(d[7] >> 2) & 0x1` | 6 |
| 7 | bit 3 | ErrSys_4 | b | `(d[7] >> 3) & 0x1` | 6 |
| 7 | bit 4 | ErrSys_5 | b | `(d[7] >> 4) & 0x1` | 6 |
| 7 | bit 5 | ErrSys_6 | b | `(d[7] >> 5) & 0x1` | 6 |
| 7 | bit 6 | ErrSys_7 | b | `(d[7] >> 6) & 0x1` | 6 |
| 7 | bit 7 | ErrSys_8 | b | `(d[7] >> 7) & 0x1` | 6 |

## 0x306  ·  bytes 0-1 used  ·  PPS: can_c

| bytes | bits | signal | type | decode | tables |
|---|---|---|---|---|---|
| 0 | bits 0-7 | TirePrssRL2 | b | `d[0] & 0xFF` | all |
| 1 | bits 0-7 | TirePrssRR2 | b | `d[1] & 0xFF` | all |

## 0x307  ·  bytes 0-1 used  ·  PPS: ves

| bytes | bits | signal | type | decode | tables |
|---|---|---|---|---|---|
| 0 | bit 3 | VES3_CTRL_LK | b | `(d[0] >> 3) & 0x1` | all |
| 0 | bit 1 | VES3_IR1_MUTED | b | `(d[0] >> 1) & 0x1` | all |
| 0 | bit 2 | VES3_IR2_MUTED | b | `(d[0] >> 2) & 0x1` | all |
| 0 | bit 0 | VES3_PWR_ON | b | `d[0] & 0x1` | all |
| 1 | bits 0-3 | VES3_DISP_STAT | b | `d[1] & 0xF` | all |

## 0x308  ·  bytes 0-3 used  ·  PPS: can_c

| bytes | bits | signal | type | decode | tables |
|---|---|---|---|---|---|
| 0 | bit 0 | TCASE_FAIL | b | `d[0] & 0x1` | all |
| 0 | bit 1 | TCASE_INHBT | b | `(d[0] >> 1) & 0x1` | all |
| 0 | bits 2-3 | TCASE_SRV_RQ | b | `(d[0] >> 2) & 0x3` | all |
| 0 | bits 4-5 | Tcase4Lock | b | `(d[0] >> 4) & 0x3` | all |
| 0 | bits 6-7 | Tcase4Low | b | `(d[0] >> 6) & 0x3` | all |
| 1 | bits 2-3 | TcaseAWD | b | `(d[1] >> 2) & 0x3` | all |
| 1 | bits 0-1 | TcaseNtrlStat | b | `d[1] & 0x3` | all |
| 2 | bits 2-3 | TerSt_LED1 | b | `(d[2] >> 2) & 0x3` | all |
| 2 | bits 4-5 | TerSt_LED2 | b | `(d[2] >> 4) & 0x3` | all |
| 2 | bits 0-1 | TerSt_LED3 | b | `d[2] & 0x3` | all |
| 2 | bits 6-7 | TerSt_LED5 | b | `(d[2] >> 6) & 0x3` | all |
| 3 | bit 6 | TerMdInhbt | b | `(d[3] >> 6) & 0x1` | all |
| 3 | bits 0-1 | TerSt_LED4 | b | `d[3] & 0x3` | all |

## 0x30A  ·  bytes 0-8 used  ·  PPS: audioctl, personal, suspension, unknown, vehcfg, vehstat

| bytes | bits | signal | type | decode | tables |
|---|---|---|---|---|---|
| 0 | bit 7 | AFLS_ENBL | b | `(d[0] >> 7) & 0x1` | all |
| 0 | bit 0 | AutoOilChg | b | `d[0] & 0x1` | all |
| 0 | bit 6 | FullOFC_Actv | b | `(d[0] >> 6) & 0x1` | all |
| 0 | bits 4-5 | HILL_DES_STAT | b | `(d[0] >> 4) & 0x3` | all |
| 0 | bit 2 | HSA_EN | b | `(d[0] >> 2) & 0x1` | all |
| 0 | bit 3 | HSA_SUPP | b | `(d[0] >> 3) & 0x1` | all |
| 0 | bit 1 | WarnPrio1_Mute_Rq | b | `(d[0] >> 1) & 0x1` | all |
| 1 | bit 7 | ASCM_AeroDsbl | b | `(d[1] >> 7) & 0x1` | all |
| 1 | bit 6 | ASCM_TJM | b | `(d[1] >> 6) & 0x1` | all |
| 1 | bit 0 | FCW_Sensitivity | b | `d[1] & 0x1` | all |
| 1 | bit 1 | FuelSavDispEnbl | b | `(d[1] >> 1) & 0x1` | all |
| 1 | bits 4-5 | HLDrpStat | b | `(d[1] >> 4) & 0x3` | all |
| 1 | bit 2 | Radio_Strng_Rq | b | `(d[1] >> 2) & 0x1` | all |
| 3 | bits 0-7 | EngCoolTemp | b | `d[3] & 0xFF` | all |
| 4 | bits 0-7 | SHFT_PROG | b | `d[4] & 0xFF` | all |
| 5 | bit 7 | FCW_Stat | b | `(d[5] >> 7) & 0x1` | all |
| 5 | bits 4-6 | FUEL_TYPE | b | `(d[5] >> 4) & 0x7` | all |
| 5 | bit 0 | TRANS_TYPE | b | `d[5] & 0x1` | all |
| 6 | bits 5-6 | ESC_LnchMd | b | `(d[6] >> 5) & 0x3` | all |
| 6 | bit 0 | ESP_DSBL | b | `d[6] & 0x1` | all |
| 6 | bits 2-3 | EmodeBtnSts | b | `(d[6] >> 2) & 0x3` | 6 |
| 6 | bit 7 | OilLifeLeftRst | b | `(d[6] >> 7) & 0x1` | all |
| 6 | bit 4 | SpStPrsnt | b | `(d[6] >> 4) & 0x1` | 6 |
| 7-8 | 16-bit | AvgFuelLvl | y | `d[8]<<8 \| d[7]` | all |

## 0x30B  ·  bytes 0-5 used  ·  PPS: can_c

| bytes | bits | signal | type | decode | tables |
|---|---|---|---|---|---|
| 0-1 | 16-bit | DisOilLifeRst | y | `d[1]<<8 \| d[0]` | all |
| 2 | bits 0-7 | OilLifeLeft | b | `d[2] & 0xFF` | all |
| 3-4 | 16-bit | HoursOilLifeRst | y | `d[4]<<8 \| d[3]` | all |
| 5 | bits 1-2 | MntncSts | b | `(d[5] >> 1) & 0x3` | all |

## 0x30E  ·  bytes 0-5 used  ·  PPS: comfortstat

| bytes | bits | signal | type | decode | tables |
|---|---|---|---|---|---|
| 0 | bits 6-7 | AUTO_STAT | b | `(d[0] >> 6) & 0x3` | all |
| 0 | bits 0-1 | EBL_Stat | b | `d[0] & 0x3` | all |
| 0 | bits 4-5 | RECIRC_STAT | b | `(d[0] >> 4) & 0x3` | all |
| 0 | bit 2 | SYNC_STAT | b | `(d[0] >> 2) & 0x1` | all |
| 1 | bits 0-1 | AC_Stat | b | `d[1] & 0x3` | all |
| 1 | bits 2-4 | AutoDfgStat | b | `(d[1] >> 2) & 0x7` | all |
| 1 | bits 6-7 | MAX_ACSts | b | `(d[1] >> 6) & 0x3` | all |
| 1 | bit 5 | TRAC_PSD | b | `(d[1] >> 5) & 0x1` | all |
| 2-3 | 16-bit | DRV_SUN_SNSR | y | `d[3]<<8 \| d[2]` | all |
| 4-5 | 16-bit | PAS_SUN_SNSR | y | `d[5]<<8 \| d[4]` | all |

## 0x30F  ·  bytes 0-7 used  ·  PPS: can_c

| bytes | bits | signal | type | decode | tables |
|---|---|---|---|---|---|
| 0-1 | 16-bit | VehPerfAccelPeak_X_Pos | y | `d[1]<<8 \| d[0]` | all |
| 2-3 | 16-bit | VehPerfAccelPeak_X_Neg | y | `d[3]<<8 \| d[2]` | all |
| 4-5 | 16-bit | VehPerfAccelPeak_Y_Pos | y | `d[5]<<8 \| d[4]` | all |
| 6-7 | 16-bit | VehPerfAccelPeak_Y_Neg | y | `d[7]<<8 \| d[6]` | all |

## 0x310  ·  bytes 0-2 used  ·  PPS: can_c

| bytes | bits | signal | type | decode | tables |
|---|---|---|---|---|---|
| 0 | bit 6 | FuelLvlLow | b | `(d[0] >> 6) & 0x1` | 0,6 |
| 0 | bits 4-5 | SRS_LMP_STAT | b | `(d[0] >> 4) & 0x3` | 0,1,2,3,4,6,7,8 |
| 2 | bits 0-3 | DPF_DEF_WrnStat | b | `d[2] & 0xF` | all |

## 0x318  ·  bytes 0-5 used  ·  PPS: audioctl

| bytes | bits | signal | type | decode | tables |
|---|---|---|---|---|---|
| 0 | bit 6 | HrnSw_Psd | b | `(d[0] >> 6) & 0x1` | all |
| 3 | bit 0 | AUD_MODE_ADV | b | `d[3] & 0x1` | all |
| 3 | bits 6-7 | PRESET_CFG | b | `(d[3] >> 6) & 0x3` | all |
| 3 | bits 4-5 | SEEK | b | `(d[3] >> 4) & 0x3` | all |
| 3 | bits 2-3 | VOL | b | `(d[3] >> 2) & 0x3` | all |
| 4 | bits 2-3 | DN_ARW_STEP_RQ | b | `(d[4] >> 2) & 0x3` | all |
| 4 | bits 0-1 | MENU_RQ | b | `d[4] & 0x3` | all |
| 4 | bits 6-7 | RT_ARW_RST_RQ | b | `(d[4] >> 6) & 0x3` | all |
| 4 | bits 4-5 | Up_Arw_Rq | b | `(d[4] >> 4) & 0x3` | all |
| 5 | bits 0-1 | CELL_VR | b | `d[5] & 0x3` | all |

## 0x31B  ·  bytes 0-7 used  ·  PPS: ves

| bytes | bits | signal | type | decode | tables |
|---|---|---|---|---|---|
| 0 | bit 3 | VES2_CTRL_LK | b | `(d[0] >> 3) & 0x1` | all |
| 0 | bit 1 | VES2_IR1_MUTED | b | `(d[0] >> 1) & 0x1` | all |
| 0 | bit 2 | VES2_IR2_MUTED | b | `(d[0] >> 2) & 0x1` | all |
| 0 | bit 0 | VES2_PWR_ON | b | `d[0] & 0x1` | all |
| 1 | bits 0-3 | VES2_DISP_STAT | b | `d[1] & 0xF` | all |
| 1 | bits 4-7 | VES2_RDC2_STAT | b | `(d[1] >> 4) & 0xF` | all |
| 2-3 | 16-bit | VES2_H_SIZE | y | `d[3]<<8 \| d[2]` | all |
| 4-5 | 16-bit | VES2_V_SIZE | y | `d[5]<<8 \| d[4]` | all |
| 6 | bits 0-4 | VES2_IR1_AUD_MD | b | `d[6] & 0x1F` | all |
| 7 | bits 0-4 | VES2_IR2_AUD_MD | b | `d[7] & 0x1F` | all |

## 0x31E  ·  bytes 0-1 used  ·  PPS: personal, vehstat

| bytes | bits | signal | type | decode | tables |
|---|---|---|---|---|---|
| 0 | bits 0-1 | FL_HS_STAT | b | `d[0] & 0x3` | all |
| 0 | bit 2 | FL_HS_STATFailSts | b | `(d[0] >> 2) & 0x1` | 5 |
| 0 | bits 2-3 | FL_VS_STAT | b | `(d[0] >> 2) & 0x3` | 0,1,2,3,4,6,7,8 |
| 0 | bits 3-4 | FL_VS_STAT | b | `(d[0] >> 3) & 0x3` | 5 |
| 0 | bit 5 | FL_VS_STATFailSts | b | `(d[0] >> 5) & 0x1` | 5 |
| 0 | bit 7 | HSW_Stat | b | `(d[0] >> 7) & 0x1` | 0,1,2,3,4,6,7,8 |
| 0 | bit 6 | HSW_Stat | b | `(d[0] >> 6) & 0x1` | 5 |
| 0 | bit 7 | HSW_StatFailSts | b | `(d[0] >> 7) & 0x1` | 5 |
| 1 | bits 6-7 | AutoOnComfortStatus | b | `(d[1] >> 6) & 0x3` | all |
| 1 | bits 0-1 | FR_HS_STAT | b | `d[1] & 0x3` | all |
| 1 | bit 2 | FR_HS_STATFailSts | b | `(d[1] >> 2) & 0x1` | 5 |
| 1 | bits 2-3 | FR_VS_STAT | b | `(d[1] >> 2) & 0x3` | 0,1,2,3,4,6,7,8 |
| 1 | bits 3-4 | FR_VS_STAT | b | `(d[1] >> 3) & 0x3` | 5 |
| 1 | bit 5 | FR_VS_STATFailSts | b | `(d[1] >> 5) & 0x1` | 5 |

## 0x31F  ·  bytes 0-7 used  ·  PPS: can_c

| bytes | bits | signal | type | decode | tables |
|---|---|---|---|---|---|
| 7 | bit 7 | RainSensorFailSts | b | `(d[7] >> 7) & 0x1` | all |

## 0x320  ·  bytes 0-0 used  ·  PPS: can_c

| bytes | bits | signal | type | decode | tables |
|---|---|---|---|---|---|
| 0 | bits 3-7 | PSI_Max_RPM | b | `(d[0] >> 3) & 0x1F` | all |

## 0x321  ·  bytes 0-7 used  ·  PPS: ves

| bytes | bits | signal | type | decode | tables |
|---|---|---|---|---|---|
| 0 | bit 6 | VES2_Audio_Active | b | `(d[0] >> 6) & 0x1` | all |
| 0 | bit 4 | VES2_DISP_FLAG | b | `(d[0] >> 4) & 0x1` | all |
| 0 | bit 0 | VES2_PT_CAB_DR | b | `d[0] & 0x1` | all |
| 0 | bit 1 | VES2_PT_FT_PAS | b | `(d[0] >> 1) & 0x1` | all |
| 0 | bit 2 | VES2_PT_IR1 | b | `(d[0] >> 2) & 0x1` | all |
| 0 | bit 3 | VES2_PT_IR2 | b | `(d[0] >> 3) & 0x1` | all |
| 0 | bit 5 | VES2_Video_Active | b | `(d[0] >> 5) & 0x1` | all |
| 1 | bits 0-7 | VES2_RQ1 | b | `d[1] & 0xFF` | all |
| 2 | bits 0-7 | VES2_RQ2 | b | `d[2] & 0xFF` | all |
| 3 | bits 0-7 | VES2_RQ3 | b | `d[3] & 0xFF` | all |
| 4 | bits 0-7 | VES2_RSP | b | `d[4] & 0xFF` | all |
| 5-7 | 24-bit | VES2_JUMP_FUNC | y | `d[7]<<16 \| d[6]<<8 \| d[5]` | all |

## 0x322  ·  bytes 0-7 used  ·  PPS: vehstat

| bytes | bits | signal | type | decode | tables |
|---|---|---|---|---|---|
| 0-1 | 16-bit | EngRPM | y | `d[1]<<8 \| d[0]` | all |
| 2-3 | 16-bit | VEH_SPEED | y | `d[3]<<8 \| d[2]` | all |
| 4 | bits 4-5 | Brk_Stat | b | `(d[4] >> 4) & 0x3` | all |
| 4 | bits 0-3 | Gr | b | `d[4] & 0xF` | 0,1,2,3,4,6,7,8 |
| 5 | bits 0-7 | OIL_PRESS | b | `d[5] & 0xFF` | 1,2,3,4,5,7,8 |
| 6-7 | 16-bit | EngTrqStatic | y | `d[7]<<8 \| d[6]` | all |

## 0x324  ·  bytes 0-0 used  ·  PPS: can_c

| bytes | bits | signal | type | decode | tables |
|---|---|---|---|---|---|
| 0 | bits 0-7 | RemSt_inhibit | b | `d[0] & 0xFF` | all |

## 0x32A  ·  bytes 0-7 used  ·  PPS: camera, personal, vehstat

| bytes | bits | signal | type | decode | tables |
|---|---|---|---|---|---|
| 0 | bits 2-3 | GridStsCHMCM | b | `(d[0] >> 2) & 0x3` | 1,2,3,4,5,6,7,8 |
| 0 | bit 0 | PSI_EnableSts | b | `d[0] & 0x1` | 1,2,3,4,5,6,7,8 |
| 0 | bit 1 | PS_SysType | b | `(d[0] >> 1) & 0x1` | 1,2,3,4,5,6,7,8 |
| 0 | bits 6-7 | ZoomSts | b | `(d[0] >> 6) & 0x3` | all |
| 0 | bits 4-5 | ZoomStsCHMCM | b | `(d[0] >> 4) & 0x3` | 1,2,3,4,5,6,7,8 |
| 1 | bits 6-7 | CapacityUnit | b | `(d[1] >> 6) & 0x3` | 1,2,3,4,5,7,8 |
| 1 | bits 0-4 | ECM_MSG_RQ | b | `d[1] & 0x1F` | 1,2,3,4,5,7,8 |
| 1 | bit 5 | ESC_sftbtn_launch_sel | b | `(d[1] >> 5) & 0x1` | 1,2,3,4,5,7,8 |
| 1 | bits 5-7 | EngDrvMdStat | b | `(d[1] >> 5) & 0x7` | 6 |
| 1 | bit 0 | SBR_MuteRq | b | `d[1] & 0x1` | 6 |
| 2 | bits 3-7 | ECM_MSG_RQ | b | `(d[2] >> 3) & 0x1F` | 6 |
| 2 | bits 0-2 | ESC_OFF_Hrd_Sft_Button_sts | b | `d[2] & 0x7` | 1,2,3,4,5,7,8 |
| 2 | bit 2 | ESP_TRK_MD | b | `(d[2] >> 2) & 0x1` | 6 |
| 2 | bits 3-7 | LaunchRPMsetting_ESC | b | `(d[2] >> 3) & 0x1F` | 1,2,3,4,5,7,8 |
| 2 | bit 1 | RR_PAM_StopControl | b | `(d[2] >> 1) & 0x1` | 6 |
| 3 | bits 5-7 | ESC_OFF_Hrd_Sft_Button_sts | b | `(d[3] >> 5) & 0x7` | 6 |
| 3 | bit 0 | ESC_sftbtn_launch_sel | b | `d[3] & 0x1` | 6 |
| 3 | bit 7 | ESP_TRK_MD | b | `(d[3] >> 7) & 0x1` | 1,2,3,4,5,7,8 |
| 3 | bits 3-5 | HP_MODE_STS | b | `(d[3] >> 3) & 0x7` | 1,2,3,4,5,7,8 |
| 3 | bits 0-2 | PowerSteeringMode | b | `d[3] & 0x7` | 1,2,3,4,5,7,8 |
| 3 | bit 6 | RR_PTS_StopControlSts | b | `(d[3] >> 6) & 0x1` | 1,2,3,4,5,7,8 |
| 3 | bits 3-4 | RadioTractionControl_Ind | b | `(d[3] >> 3) & 0x3` | 6 |
| 4 | bits 0-2 | EPS_MODE_STAT | b | `d[4] & 0x7` | 1,2,3,4,5,7,8 |
| 4 | bits 3-5 | EPS_Warn_Disp_Rq | b | `(d[4] >> 3) & 0x7` | 1,2,3,4,7,8 |
| 4 | bits 0-4 | LaunchRPMsetting_ESC | b | `d[4] & 0x1F` | 6 |
| 4 | bits 5-7 | PowerSteeringMode | b | `(d[4] >> 5) & 0x7` | 6 |
| 4 | bit 7 | TemperatureUnit | b | `(d[4] >> 7) & 0x1` | 1,2,3,4,5,7,8 |
| 4 | bit 6 | TorqueUnit | b | `(d[4] >> 6) & 0x1` | 1,2,3,4,5,7,8 |
| 5 | bit 0 | DistanceUnit | b | `d[5] & 0x1` | 1,7 |
| 5 | bit 0 | DistanceUnit_PNET | b | `d[5] & 0x1` | 8 |
| 5 | bits 5-7 | EPS_MODE_STAT | b | `(d[5] >> 5) & 0x7` | 6 |
| 5 | bits 2-4 | HP_MODE_STS | b | `(d[5] >> 2) & 0x7` | 6 |
| 5 | bits 6-7 | PaddlesModeSts | b | `(d[5] >> 6) & 0x3` | 1,2,3,4,5,7,8 |
| 5 | bits 0-1 | PaddlesModeSts | b | `d[5] & 0x3` | 6 |
| 5 | bits 2-3 | PowerUnit | b | `(d[5] >> 2) & 0x3` | 1,2,3,4,5,7,8 |
| 5 | bits 4-5 | PressureUnit | b | `(d[5] >> 4) & 0x3` | 1,2,3,4,5,7,8 |
| 5 | bit 1 | SpeedUnit | b | `(d[5] >> 1) & 0x1` | 1,2,3,4,5,7,8 |
| 6 | bits 0-2 | ConsumptionUnit | b | `d[6] & 0x7` | 1,2,4,7,8 |
| 6 | bits 3-5 | ConsumptionUnit | b | `(d[6] >> 3) & 0x7` | 6 |
| 6 | bits 0-2 | EPS_Warn_Disp_Rq | b | `d[6] & 0x7` | 6 |
| 6 | bits 6-7 | E_Mode_Sts | b | `(d[6] >> 6) & 0x3` | 1,2,3,4,5,7,8 |
| 6 | bits 3-5 | EngDrvMdStat | b | `(d[6] >> 3) & 0x7` | 1,2,3,4,5,7,8 |
| 6 | bit 7 | TemperatureUnit | b | `(d[6] >> 7) & 0x1` | 6 |
| 6 | bit 6 | TorqueUnit | b | `(d[6] >> 6) & 0x1` | 6 |
| 7 | bits 6-7 | CapacityUnit | b | `(d[7] >> 6) & 0x3` | 6 |
| 7 | bit 0 | DistanceUnit | b | `d[7] & 0x1` | 6 |
| 7 | bits 2-3 | PowerUnit | b | `(d[7] >> 2) & 0x3` | 6 |
| 7 | bits 4-5 | PressureUnit | b | `(d[7] >> 4) & 0x3` | 6 |
| 7 | bit 1 | SpeedUnit | b | `(d[7] >> 1) & 0x1` | 6 |

## 0x32B  ·  bytes 0-1 used  ·  PPS: comfortstat

| bytes | bits | signal | type | decode | tables |
|---|---|---|---|---|---|
| 0 | bits 4-7 | R_HVAC_Mode_2_Status | b | `(d[0] >> 4) & 0xF` | all |
| 1 | bits 1-7 | R_HVAC_Blwr_2_Spd | b | `(d[1] >> 1) & 0x7F` | all |

## 0x32C  ·  bytes 0-6 used  ·  PPS: personal, pto

| bytes | bits | signal | type | decode | tables |
|---|---|---|---|---|---|
| 0 | bits 3-7 | PTO_MaxVehSpd | b | `(d[0] >> 3) & 0x1F` | all |
| 0 | bits 0-2 | PTO_Md | b | `d[0] & 0x7` | all |
| 1 | bits 0-1 | PTO_AutoRsm | b | `d[1] & 0x3` | all |
| 1 | bit 4 | PTO_RmtThrottleSts | b | `(d[1] >> 4) & 0x1` | all |
| 1 | bits 2-3 | PTO_TYPES | b | `(d[1] >> 2) & 0x3` | all |
| 2 | bits 0-7 | PTO_SingleRPM | b | `d[2] & 0xFF` | all |
| 3 | bits 0-7 | PTO_RPM1 | b | `d[3] & 0xFF` | all |
| 4 | bits 0-7 | PTO_RPM2 | b | `d[4] & 0xFF` | all |
| 5 | bits 0-7 | PTO_RPM3 | b | `d[5] & 0xFF` | all |
| 6 | bit 2 | IdleShutDwnApply | b | `(d[6] >> 2) & 0x1` | all |
| 6 | bits 3-4 | LDW_LEDControlSts | b | `(d[6] >> 3) & 0x3` | all |
| 6 | bits 0-1 | PPPA_ControlSts | b | `d[6] & 0x3` | 1,2,3,4,5,7,8 |
| 6 | bits 0-1 | PPPA_STAT | b | `d[6] & 0x3` | 0,6 |
| 6 | bits 5-7 | TorqueIntensitySts | b | `(d[6] >> 5) & 0x7` | 2,3,4,5,6,7,8 |

## 0x331  ·  bytes 0-7 used  ·  PPS: ves

| bytes | bits | signal | type | decode | tables |
|---|---|---|---|---|---|
| 0 | bit 4 | VES3_DISP_FLAG | b | `(d[0] >> 4) & 0x1` | all |
| 0 | bit 0 | VES3_PT_CAB_DR | b | `d[0] & 0x1` | all |
| 0 | bit 1 | VES3_PT_FT_PAS | b | `(d[0] >> 1) & 0x1` | all |
| 0 | bit 2 | VES3_PT_IR1 | b | `(d[0] >> 2) & 0x1` | all |
| 0 | bit 3 | VES3_PT_IR2 | b | `(d[0] >> 3) & 0x1` | all |
| 1 | bits 0-7 | VES3_RQ1 | b | `d[1] & 0xFF` | all |
| 2 | bits 0-7 | VES3_RQ2 | b | `d[2] & 0xFF` | all |
| 3 | bits 0-7 | VES3_RQ3 | b | `d[3] & 0xFF` | all |
| 4 | bits 0-7 | VES3_RSP | b | `d[4] & 0xFF` | all |
| 5-7 | 24-bit | VES3_JUMP_FUNC | y | `d[7]<<16 \| d[6]<<8 \| d[5]` | all |

## 0x332  ·  bytes 0-7 used  ·  PPS: audiostat, personal, suspension, vehstat

| bytes | bits | signal | type | decode | tables |
|---|---|---|---|---|---|
| 0 | bits 0-1 | ITBM_BrkStyle | b | `d[0] & 0x3` | all |
| 0 | bit 2 | MIL_OnRq | b | `(d[0] >> 2) & 0x1` | 1,2,3,4,7,8 |
| 0 | bits 3-4 | PTS_CFG_STAT | b | `(d[0] >> 3) & 0x3` | all |
| 0 | bit 5 | PTS_MUTE_RQ | b | `(d[0] >> 5) & 0x1` | all |
| 0 | bit 6 | PTS_WARN | b | `(d[0] >> 6) & 0x1` | all |
| 1 | bits 0-7 | PRNDL_DISP | b | `d[1] & 0xFF` | all |
| 2 | bits 0-2 | PRND_STAT | b | `d[2] & 0x7` | all |
| 2 | bits 3-5 | TCASE_STAT | b | `(d[2] >> 3) & 0x7` | all |
| 3 | bit 4 | ASCM_WarnOnly | b | `(d[3] >> 4) & 0x1` | all |
| 3 | bit 2 | AudioMuteRq | b | `(d[3] >> 2) & 0x1` | all |
| 3 | bits 5-7 | ConfigSts | b | `(d[3] >> 5) & 0x7` | 2,3,4,5,6,7,8 |
| 3 | bit 1 | TM_Enbl | b | `(d[3] >> 1) & 0x1` | all |
| 3 | bit 3 | WAL_Enbl | b | `(d[3] >> 3) & 0x1` | all |
| 4-5 | 16-bit | R134a_Press_Stat | y | `d[5]<<8 \| d[4]` | all |
| 6 | bits 3-7 | LANG | b | `(d[6] >> 3) & 0x1F` | all |
| 6 | bit 2 | US_METRIC | b | `(d[6] >> 2) & 0x1` | all |
| 7 | bits 0-2 | TrlrNum | b | `d[7] & 0x7` | all |
| 7 | bits 3-7 | TrlrStyle | b | `(d[7] >> 3) & 0x1F` | all |

## 0x333  ·  bytes 0-1 used  ·  PPS: ves

| bytes | bits | signal | type | decode | tables |
|---|---|---|---|---|---|
| 0 | bits 0-3 | VES3_AUX_STAT | b | `d[0] & 0xF` | all |
| 0 | bits 4-7 | VES3_Src_TGW_Stat | b | `(d[0] >> 4) & 0xF` | all |
| 1 | bits 4-7 | VES3_AUX2_STAT | b | `(d[1] >> 4) & 0xF` | all |
| 1 | bits 0-3 | VES3_Src_IR_Stat | b | `d[1] & 0xF` | all |

## 0x334  ·  bytes 0-0 used  ·  PPS: can_c

| bytes | bits | signal | type | decode | tables |
|---|---|---|---|---|---|
| 0 | bit 6 | BRK_FLUID_LO | b | `(d[0] >> 6) & 0x1` | all |
| 0 | bit 4 | ElecDrLkFT_LT | b | `(d[0] >> 4) & 0x1` | all |
| 0 | bit 5 | ElecDrLkFT_RT | b | `(d[0] >> 5) & 0x1` | all |
| 0 | bit 3 | HIBEAM_ON | b | `(d[0] >> 3) & 0x1` | 0,6 |
| 0 | bit 7 | WASH_FLUID_LO | b | `(d[0] >> 7) & 0x1` | 0,1,2,3,4,6,7,8 |

## 0x339  ·  bytes 0-5 used  ·  PPS: notification

| bytes | bits | signal | type | decode | tables |
|---|---|---|---|---|---|
| 0 | bits 4-7 | PTS_CHIME_TYPE | b | `(d[0] >> 4) & 0xF` | all |
| 0 | bit 1 | PTS_LF_CHIME_RQ | b | `(d[0] >> 1) & 0x1` | all |
| 0 | bit 3 | PTS_LR_CHIME_RQ | b | `(d[0] >> 3) & 0x1` | all |
| 0 | bit 0 | PTS_RF_CHIME_RQ | b | `d[0] & 0x1` | all |
| 0 | bit 2 | PTS_RR_CHIME_RQ | b | `(d[0] >> 2) & 0x1` | all |
| 1 | bits 0-3 | PTS_CHIME_REP_RATE | b | `d[1] & 0xF` | all |
| 1 | bits 4-5 | PTS_FT_VOL | b | `(d[1] >> 4) & 0x3` | all |
| 1 | bits 6-7 | PTS_RR_VOL | b | `(d[1] >> 6) & 0x3` | all |
| 2 | bits 0-1 | ChimeTypeFront | b | `d[2] & 0x3` | all |
| 2 | bits 2-3 | ChimeTypeRear | b | `(d[2] >> 2) & 0x3` | all |
| 3 | bits 0-3 | ChimeRepetitionRate_Front | b | `d[3] & 0xF` | all |
| 3 | bits 4-7 | ChimeRepetitionRate_Rear | b | `(d[3] >> 4) & 0xF` | all |
| 4 | bit 0 | SDW_ChimeActivation_LHF | b | `d[4] & 0x1` | all |
| 4 | bit 1 | SDW_ChimeActivation_LHR | b | `(d[4] >> 1) & 0x1` | all |
| 4 | bit 2 | SDW_ChimeActivation_RHF | b | `(d[4] >> 2) & 0x1` | all |
| 4 | bit 3 | SDW_ChimeActivation_RHR | b | `(d[4] >> 3) & 0x1` | all |
| 4 | bits 4-5 | SDW_ChimeType_Front | b | `(d[4] >> 4) & 0x3` | 0,1,2,4,6,7,8 |
| 4 | bits 4-5 | SDW_ChimeType_Left | b | `(d[4] >> 4) & 0x3` | 3,5 |
| 4 | bits 6-7 | SDW_ChimeType_Rear | b | `(d[4] >> 6) & 0x3` | 0,1,2,4,6,7,8 |
| 4 | bits 6-7 | SDW_ChimeType_Right | b | `(d[4] >> 6) & 0x3` | 3,5 |
| 5 | bits 0-3 | SDW_ChimeRepetitionRate_Front | b | `d[5] & 0xF` | 0,1,2,4,6,7,8 |
| 5 | bits 0-3 | SDW_ChimeRepetitionRate_Left | b | `d[5] & 0xF` | 3,5 |
| 5 | bits 4-7 | SDW_ChimeRepetitionRate_Rear | b | `(d[5] >> 4) & 0xF` | 0,1,2,4,6,7,8 |
| 5 | bits 4-7 | SDW_ChimeRepetitionRate_Right | b | `(d[5] >> 4) & 0xF` | 3,5 |

## 0x33A  ·  bytes 0-8 used  ·  PPS: comfortstat

| bytes | bits | signal | type | decode | tables |
|---|---|---|---|---|---|
| 0-1 | 16-bit | VEH_INT_TEMP | y | `d[1]<<8 \| d[0]` | all |
| 2 | bits 0-6 | DRV_TEMP_DR_POS | b | `d[2] & 0x7F` | all |
| 3 | bits 0-6 | PAS_TEMP_DR_POS | b | `d[3] & 0x7F` | all |
| 4 | bits 0-6 | RECIRC_DR_POS | b | `d[4] & 0x7F` | all |
| 5 | bits 0-6 | MD_DR_POS | b | `d[5] & 0x7F` | all |
| 6 | bits 0-6 | R_TEMP_DR_POS | b | `d[6] & 0x7F` | all |
| 7 | bits 0-6 | R_MD_DR_POS | b | `d[7] & 0x7F` | all |
| 8 | bits 0-7 | CLNT_FLWR_FROM_HVAC | b | `d[8] & 0xFF` | all |

## 0x33E  ·  bytes 0-4 used  ·  PPS: notification

| bytes | bits | signal | type | decode | tables |
|---|---|---|---|---|---|
| 0 | bit 1 | BSM_LF_CHIME_RQ | b | `(d[0] >> 1) & 0x1` | all |
| 0 | bit 3 | BSM_LR_CHIME_RQ | b | `(d[0] >> 3) & 0x1` | all |
| 0 | bits 6-7 | BSM_LT_CFG_STAT | b | `(d[0] >> 6) & 0x3` | all |
| 0 | bit 0 | BSM_RF_CHIME_RQ | b | `d[0] & 0x1` | all |
| 0 | bit 2 | BSM_RR_CHIME_RQ | b | `(d[0] >> 2) & 0x1` | all |
| 0 | bits 4-5 | BSM_RT_CFG_STAT | b | `(d[0] >> 4) & 0x3` | all |
| 1 | bits 0-3 | BSM_CHIME_REP_RATE | b | `d[1] & 0xF` | 0,1,2,4,6,7,8 |
| 1 | bits 4-7 | BSM_CHIME_TYPE | b | `(d[1] >> 4) & 0xF` | 0,1,2,4,6,7,8 |
| 1 | bits 0-3 | BSM_RT_CHIME_REP_RATE | b | `d[1] & 0xF` | 3,5 |
| 1 | bits 4-7 | BSM_RT_CHIME_TYPE | b | `(d[1] >> 4) & 0xF` | 3,5 |
| 2 | bits 0-3 | BSM_LT_CHIME_REP_RATE | b | `d[2] & 0xF` | all |
| 2 | bits 4-7 | BSM_LT_CHIME_TYPE | b | `(d[2] >> 4) & 0xF` | all |
| 3 | bit 1 | BSM_LT_Blind_RQ | b | `(d[3] >> 1) & 0x1` | all |
| 3 | bit 0 | BSM_RT_Blind_RQ | b | `d[3] & 0x1` | all |
| 4 | bits 0-1 | BSM_SRV_RQ | b | `d[4] & 0x3` | 5 |
| 4 | bit 0 | BSS_LT_SRV_RQSts | b | `d[4] & 0x1` | 5 |
| 4 | bit 1 | BSS_RT_SRV_RQSts | b | `(d[4] >> 1) & 0x1` | 5 |

## 0x340  ·  bytes 0-7 used  ·  PPS: personal, vehstat

| bytes | bits | signal | type | decode | tables |
|---|---|---|---|---|---|
| 0 | bits 0-7 | VehAccelPeak_X | b | `d[0] & 0xFF` | all |
| 1 | bits 0-7 | VehAccelPeak_Y | b | `d[1] & 0xFF` | all |
| 2 | bits 0-3 | ESS_ENG_ST | b | `d[2] & 0xF` | all |
| 2 | bits 4-7 | Gr_Target | b | `(d[2] >> 4) & 0xF` | all |
| 3 | bit 4 | AS_ChimeRq_LF | b | `(d[3] >> 4) & 0x1` | all |
| 3 | bit 5 | AS_ChimeRq_RF | b | `(d[3] >> 5) & 0x1` | all |
| 3 | bits 0-3 | AS_ChimeTyp | b | `d[3] & 0xF` | all |
| 3 | bit 7 | PTS_FT_Enbl | b | `(d[3] >> 7) & 0x1` | all |
| 3 | bit 6 | PTS_RR_Enbl | b | `(d[3] >> 6) & 0x1` | all |
| 4 | bit 6 | FCW_BrkOn | b | `(d[4] >> 6) & 0x1` | all |
| 4 | bit 7 | FCW_SetFar | b | `(d[4] >> 7) & 0x1` | all |
| 4 | bit 4 | LowShftToPark | b | `(d[4] >> 4) & 0x1` | all |
| 4 | bit 5 | RR_PAM_StopControl | b | `(d[4] >> 5) & 0x1` | 0,1,2,3,4,5,7,8 |
| 5 | bit 7 | VehSpd_MPH | b | `(d[5] >> 7) & 0x1` | all |
| 6-7 | 16-bit | VehSpdDisp | y | `d[7]<<8 \| d[6]` | all |

## 0x341  ·  bytes 0-7 used  ·  PPS: dvd

| bytes | bits | signal | type | decode | tables |
|---|---|---|---|---|---|
| 0 | bit 4 | DVD_DISP_FLAG | b | `(d[0] >> 4) & 0x1` | all |
| 0 | bit 0 | DVD_PT_CAB_DR | b | `d[0] & 0x1` | all |
| 0 | bit 1 | DVD_PT_FT_PAS | b | `(d[0] >> 1) & 0x1` | all |
| 0 | bit 2 | DVD_PT_IR1 | b | `(d[0] >> 2) & 0x1` | all |
| 0 | bit 3 | DVD_PT_IR2 | b | `(d[0] >> 3) & 0x1` | all |
| 1 | bits 0-7 | DVD_RQ1 | b | `d[1] & 0xFF` | all |
| 2 | bits 0-7 | DVD_RQ2 | b | `d[2] & 0xFF` | all |
| 3 | bits 0-7 | DVD_RQ3 | b | `d[3] & 0xFF` | all |
| 4 | bits 0-7 | DVD_RSP | b | `d[4] & 0xFF` | all |
| 5-7 | 24-bit | DVD_JUMP_FUNC | y | `d[7]<<16 \| d[6]<<8 \| d[5]` | all |

## 0x344  ·  bytes 0-1 used  ·  PPS: notification

| bytes | bits | signal | type | decode | tables |
|---|---|---|---|---|---|
| 0 | bits 4-7 | SPCR_CHIME_TYPE | b | `(d[0] >> 4) & 0xF` | all |
| 0 | bit 1 | SPCR_LF_CHIME_RQ | b | `(d[0] >> 1) & 0x1` | all |
| 0 | bit 3 | SPCR_LR_CHIME_RQ | b | `(d[0] >> 3) & 0x1` | all |
| 0 | bit 0 | SPCR_RF_CHIME_RQ | b | `d[0] & 0x1` | all |
| 0 | bit 2 | SPCR_RR_CHIME_RQ | b | `(d[0] >> 2) & 0x1` | all |
| 1 | bits 0-3 | SPCR_CHIME_RATE | b | `d[1] & 0xF` | all |

## 0x346  ·  bytes 0-1 used  ·  PPS: notification

| bytes | bits | signal | type | decode | tables |
|---|---|---|---|---|---|
| 0 | bits 4-7 | AS_CHIME_TYPE | b | `(d[0] >> 4) & 0xF` | all |
| 0 | bit 1 | AS_LF_CHIME_RQ | b | `(d[0] >> 1) & 0x1` | all |
| 0 | bit 3 | AS_LR_CHIME_RQ | b | `(d[0] >> 3) & 0x1` | all |
| 0 | bit 0 | AS_RF_CHIME_RQ | b | `d[0] & 0x1` | all |
| 0 | bit 2 | AS_RR_CHIME_RQ | b | `(d[0] >> 2) & 0x1` | all |
| 1 | bits 0-3 | AS_CHIME_REP_RATE | b | `d[1] & 0xF` | all |

## 0x34A  ·  bytes 0-0 used  ·  PPS: personal, vehstat

| bytes | bits | signal | type | decode | tables |
|---|---|---|---|---|---|
| 0 | bit 6 | CSOPlgChimeEnableDisableSts | b | `(d[0] >> 6) & 0x1` | 0,6 |
| 0 | bit 7 | CSOPlgChimeEnableDisableSts | b | `(d[0] >> 7) & 0x1` | 1,2,3,4,5,7,8 |
| 0 | bit 7 | HandsFreeLiftGateStat | b | `(d[0] >> 7) & 0x1` | 6 |
| 0 | bits 3-5 | ShiftLeverPositionReq | b | `(d[0] >> 3) & 0x7` | 0,6 |
| 0 | bits 4-6 | ShiftLeverPositionReq | b | `(d[0] >> 4) & 0x7` | 1,2,3,4,5,7,8 |

## 0x34C  ·  bytes 0-1 used  ·  PPS: suspension

| bytes | bits | signal | type | decode | tables |
|---|---|---|---|---|---|
| 0 | bits 0-3 | ASCM_Stat | b | `d[0] & 0xF` | 6 |
| 1 | bit 4 | ASCM_Srv | b | `(d[1] >> 4) & 0x1` | 6 |
| 1 | bit 5 | ASCM_SysFail | b | `(d[1] >> 5) & 0x1` | 6 |

## 0x34E  ·  bytes 0-6 used  ·  PPS: comfortstat

| bytes | bits | signal | type | decode | tables |
|---|---|---|---|---|---|
| 0 | bits 0-6 | FT_DRV_ATC_TEMP | b | `d[0] & 0x7F` | all |
| 1 | bits 0-6 | FT_DRV_MTC_TEMP | b | `d[1] & 0x7F` | all |
| 2 | bits 0-6 | FT_PSG_ATC_TEMP | b | `d[2] & 0x7F` | all |
| 3 | bits 0-6 | FT_PSG_MTC_TEMP | b | `d[3] & 0x7F` | all |
| 4 | bits 0-6 | FT_HVAC_BLW_FN_SP | b | `d[4] & 0x7F` | all |
| 5 | bits 4-6 | FT_HVAC_CTRL_STAT | b | `(d[5] >> 4) & 0x7` | all |
| 5 | bits 0-3 | FT_HVAC_MD_STAT | b | `d[5] & 0xF` | all |
| 6 | bits 0-6 | MD_DR2_POS | b | `d[6] & 0x7F` | all |

## 0x351  ·  bytes 0-7 used  ·  PPS: vrm

| bytes | bits | signal | type | decode | tables |
|---|---|---|---|---|---|
| 0 | bit 4 | VRM_Audio_Active | b | `(d[0] >> 4) & 0x1` | 6 |
| 0 | bit 0 | VRM_PT_CAB_DR | b | `d[0] & 0x1` | 6 |
| 0 | bit 5 | VRM_Video_Active | b | `(d[0] >> 5) & 0x1` | 6 |
| 1 | bits 0-7 | VRM_RQ1 | b | `d[1] & 0xFF` | 6 |
| 2 | bits 0-7 | VRM_RQ2 | b | `d[2] & 0xFF` | 6 |
| 3 | bits 0-7 | VRM_RQ3 | b | `d[3] & 0xFF` | 6 |
| 4 | bits 0-7 | VRM_RSP | b | `d[4] & 0xFF` | 6 |
| 5-7 | 24-bit | VRM_JUMP_FUNC | y | `d[7]<<16 \| d[6]<<8 \| d[5]` | 6 |

## 0x352  ·  bytes 0-7 used  ·  PPS: vrm

| bytes | bits | signal | type | decode | tables |
|---|---|---|---|---|---|
| 0 | bits 4-7 | VRM_AUD_MD_CAB | b | `(d[0] >> 4) & 0xF` | 6 |
| 0-1 | 16-bit | VRM_H_SIZE | y | `d[1]<<8 \| d[0]` | 6 |
| 0 | bits 0-3 | VRM_RDC2_STAT | b | `d[0] & 0xF` | 6 |
| 2-3 | 16-bit | VRM_V_SIZE | y | `d[3]<<8 \| d[2]` | 6 |
| 5 | bits 0-3 | VRM_IR1_AUD_MD | b | `d[5] & 0xF` | 6 |
| 6 | bits 0-3 | VRM_IR2_AUD_MD | b | `d[6] & 0xF` | 6 |
| 7 | bits 0-3 | VRM_IR3_AUD_MD | b | `d[7] & 0xF` | 6 |

## 0x354  ·  bytes 0-4 used  ·  PPS: audiocfg, audioctl, audiostat, personal

| bytes | bits | signal | type | decode | tables |
|---|---|---|---|---|---|
| 0 | bits 0-7 | AMP_EQ | b | `d[0] & 0xFF` | all |
| 1 | bit 5 | AEL_AVAIL | b | `(d[1] >> 5) & 0x1` | all |
| 1 | bits 6-7 | AEL_STAT | b | `(d[1] >> 6) & 0x3` | all |
| 1 | bits 1-2 | AMP_DSS_STAT | b | `(d[1] >> 1) & 0x3` | all |
| 1 | bit 0 | AMP_MUTED | b | `d[1] & 0x1` | all |
| 1 | bit 3 | ANC_EN | b | `(d[1] >> 3) & 0x1` | all |
| 1 | bit 4 | SURR_AVAIL | b | `(d[1] >> 4) & 0x1` | all |
| 2 | bits 4-7 | Ambient_Light_Level | b | `(d[2] >> 4) & 0xF` | all |
| 2 | bit 1 | SpeakerSTS_LF | b | `(d[2] >> 1) & 0x1` | all |
| 2 | bit 3 | SpeakerSTS_LR | b | `(d[2] >> 3) & 0x1` | all |
| 2 | bit 0 | SpeakerSTS_RF | b | `d[2] & 0x1` | all |
| 2 | bit 2 | SpeakerSTS_RR | b | `(d[2] >> 2) & 0x1` | all |
| 3 | bits 1-2 | AMP_AUDIOSts | b | `(d[3] >> 1) & 0x3` | all |
| 3 | bits 3-4 | AUDIOSts_Telematic | b | `(d[3] >> 3) & 0x3` | all |
| 3 | bit 0 | AudioRepetition | b | `d[3] & 0x1` | all |
| 4 | bit 1 | SpeakerFault_LF | b | `(d[4] >> 1) & 0x1` | 5 |
| 4 | bit 3 | SpeakerFault_LR | b | `(d[4] >> 3) & 0x1` | 5 |
| 4 | bit 0 | SpeakerFault_RF | b | `d[4] & 0x1` | 5 |
| 4 | bit 2 | SpeakerFault_RR | b | `(d[4] >> 2) & 0x1` | 5 |

## 0x358  ·  bytes 0-3 used  ·  PPS: location

| bytes | bits | signal | type | decode | tables |
|---|---|---|---|---|---|
| 0 | bits 0-3 | CMP_DIR | b | `d[0] & 0xF` | all |
| 0 | bits 4-7 | VAR_VAL | b | `(d[0] >> 4) & 0xF` | all |
| 1 | bit 1 | CAL_FAULT | b | `(d[1] >> 1) & 0x1` | all |
| 1 | bit 2 | CAL_REQD | b | `(d[1] >> 2) & 0x1` | all |
| 1 | bit 6 | DISTOR_DETECTED | b | `(d[1] >> 6) & 0x1` | all |
| 1 | bit 5 | ECU_FAULT | b | `(d[1] >> 5) & 0x1` | all |
| 1 | bit 3 | IN_CAL_MD | b | `(d[1] >> 3) & 0x1` | all |
| 1 | bit 7 | NVM_FAULT | b | `(d[1] >> 7) & 0x1` | all |
| 1 | bit 4 | SENSOR_FAULT | b | `(d[1] >> 4) & 0x1` | all |
| 2-3 | 16-bit | CMP_DIR_RAW | y | `d[3]<<8 \| d[2]` | all |

## 0x35F  ·  bytes 0-4 used  ·  PPS: can_c

| bytes | bits | signal | type | decode | tables |
|---|---|---|---|---|---|
| 0 | bits 0-4 | PSI_Gr1_RPM | b | `d[0] & 0x1F` | all |
| 1 | bits 0-4 | PSI_Gr2_RPM | b | `d[1] & 0x1F` | all |
| 2 | bits 0-4 | PSI_Gr3_RPM | b | `d[2] & 0x1F` | all |
| 3 | bits 0-4 | PSI_Gr4_RPM | b | `d[3] & 0x1F` | all |
| 4 | bits 0-4 | PSI_Gr5_RPM | b | `d[4] & 0x1F` | all |

## 0x360  ·  bytes 0-7 used  ·  PPS: dtv

| bytes | bits | signal | type | decode | tables |
|---|---|---|---|---|---|
| 0 | bit 4 | DTV_Audio_Active | b | `(d[0] >> 4) & 0x1` | all |
| 0 | bit 0 | DTV_PT_CAB_DR | b | `d[0] & 0x1` | all |
| 0 | bit 1 | DTV_PT_IR1 | b | `(d[0] >> 1) & 0x1` | 1,2,3,4,5,6,7,8 |
| 0 | bit 2 | DTV_PT_IR2 | b | `(d[0] >> 2) & 0x1` | 1,2,3,4,5,6,7,8 |
| 0 | bit 3 | DTV_Video_Active | b | `(d[0] >> 3) & 0x1` | all |
| 1 | bits 0-7 | DTV_RQ1 | b | `d[1] & 0xFF` | 1,2,3,4,5,6,7,8 |
| 2 | bits 0-7 | DTV_RQ2 | b | `d[2] & 0xFF` | 1,2,3,4,5,6,7,8 |
| 3 | bits 0-7 | DTV_RQ3 | b | `d[3] & 0xFF` | all |
| 4 | bits 0-7 | DTV_RSP | b | `d[4] & 0xFF` | 1,2,3,4,5,6,7,8 |
| 5-7 | 24-bit | DTV_JUMP_FUNC | y | `d[7]<<16 \| d[6]<<8 \| d[5]` | all |

## 0x361  ·  bytes 0-4 used  ·  PPS: dtv

| bytes | bits | signal | type | decode | tables |
|---|---|---|---|---|---|
| 0 | bit 5 | DTV_FrontCamera_Signal | b | `(d[0] >> 5) & 0x1` | all |
| 0 | bits 0-3 | DTV_RDC2_STAT | b | `d[0] & 0xF` | all |
| 0 | bit 6 | DTV_SideCamera_Signal | b | `(d[0] >> 6) & 0x1` | all |
| 0 | bit 4 | DTV_Signal_Available | b | `(d[0] >> 4) & 0x1` | all |
| 0 | bit 7 | LOC_DTV | b | `(d[0] >> 7) & 0x1` | 0,5,6 |
| 1-2 | 16-bit | DTV_H_SIZE | y | `d[2]<<8 \| d[1]` | all |
| 3-4 | 16-bit | DTV_V_SIZE | y | `d[4]<<8 \| d[3]` | all |

## 0x36A  ·  bytes 0-1 used  ·  PPS: vehstat

| bytes | bits | signal | type | decode | tables |
|---|---|---|---|---|---|
| 0 | bits 0-1 | ADC_Stat | b | `d[0] & 0x3` | all |
| 0 | bits 2-3 | ADS_MODE_CFG_Stat | b | `(d[0] >> 2) & 0x3` | all |
| 1 | bit 1 | ADS_RedLmp | b | `(d[1] >> 1) & 0x1` | all |

## 0x36E  ·  bytes 0-7 used  ·  PPS: comfortstat

| bytes | bits | signal | type | decode | tables |
|---|---|---|---|---|---|
| 0-1 | 16-bit | R_DRV_FLR_DUCT_TEMP | y | `d[1]<<8 \| d[0]` | all |
| 2-3 | 16-bit | R_PAS_FLR_DUCT_TEMP | y | `d[3]<<8 \| d[2]` | all |
| 4-5 | 16-bit | R_DRV_PNL_DUCT_TEMP | y | `d[5]<<8 \| d[4]` | all |
| 6-7 | 16-bit | R_PAS_PNL_DUCT_TEMP | y | `d[7]<<8 \| d[6]` | all |

## 0x36F  ·  bytes 0-7 used  ·  PPS: comfortstat

| bytes | bits | signal | type | decode | tables |
|---|---|---|---|---|---|
| 0 | bits 0-7 | HVAC_Amb_FILT | b | `d[0] & 0xFF` | all |
| 1 | bits 0-6 | HVAC_Blwr_Perct | b | `d[1] & 0x7F` | all |
| 2 | bits 0-6 | R_Mode1_Pos | b | `d[2] & 0x7F` | all |
| 3 | bits 0-6 | R_Mode2_Pos | b | `d[3] & 0x7F` | all |
| 4 | bits 0-6 | R_Temp1_Pos | b | `d[4] & 0x7F` | all |
| 5 | bits 0-6 | R_Temp2_Pos | b | `d[5] & 0x7F` | all |
| 6 | bits 0-6 | R_Blw1_Pos | b | `d[6] & 0x7F` | all |
| 6 | bit 7 | R_Sync_State | b | `(d[6] >> 7) & 0x1` | all |
| 7 | bits 0-6 | R_Blw2_Pos | b | `d[7] & 0x7F` | all |
| 7 | bit 7 | R_Lock_State | b | `(d[7] >> 7) & 0x1` | all |

## 0x370  ·  bytes 0-3 used  ·  PPS: comfortstat

| bytes | bits | signal | type | decode | tables |
|---|---|---|---|---|---|
| 0 | bits 0-6 | R_L_ATC_TEMP | b | `d[0] & 0x7F` | all |
| 1 | bits 0-6 | R_R_ATC_TEMP | b | `d[1] & 0x7F` | all |
| 2 | bits 0-6 | R_L_MTC_TEMP | b | `d[2] & 0x7F` | all |
| 3 | bits 0-6 | R_R_MTC_TEMP | b | `d[3] & 0x7F` | all |

## 0x372  ·  bytes 0-4 used  ·  PPS: can_c

| bytes | bits | signal | type | decode | tables |
|---|---|---|---|---|---|
| 0 | bits 0-3 | IC_PP_RQ | b | `d[0] & 0xF` | all |
| 1-2 | 16-bit | VehPerfAccelPeak_X | y | `d[2]<<8 \| d[1]` | all |
| 3-4 | 16-bit | VehPerfAccelPeak_Y | y | `d[4]<<8 \| d[3]` | all |

## 0x373  ·  bytes 0-2 used  ·  PPS: dvd

| bytes | bits | signal | type | decode | tables |
|---|---|---|---|---|---|
| 0 | bits 0-3 | DVD_AUX_STAT | b | `d[0] & 0xF` | all |
| 0 | bits 4-7 | DVD_OUT_STAT | b | `(d[0] >> 4) & 0xF` | all |
| 1 | bits 0-4 | DVD_DISC_STAT | b | `d[1] & 0x1F` | all |
| 1 | bits 5-7 | DVD_DISP_CFG | b | `(d[1] >> 5) & 0x7` | all |
| 2 | bits 0-2 | DISC_VIDEO_OUT | b | `d[2] & 0x7` | all |

## 0x37A  ·  bytes 0-5 used  ·  PPS: comfortstat

| bytes | bits | signal | type | decode | tables |
|---|---|---|---|---|---|
| 0 | bits 0-6 | R_ATC_TEMP | b | `d[0] & 0x7F` | all |
| 0 | bit 7 | R_HVAC_LkOut | b | `(d[0] >> 7) & 0x1` | all |
| 1 | bits 0-6 | R_MTC_TEMP | b | `d[1] & 0x7F` | all |
| 2 | bits 0-6 | R_HVAC_BLW_FN_SP | b | `d[2] & 0x7F` | all |
| 3 | bits 0-2 | R_HVAC_MD_STAT | b | `d[3] & 0x7` | all |
| 4 | bits 0-2 | R_HVAC_CTRL_STAT | b | `d[4] & 0x7` | all |
| 4 | bits 5-7 | R_HVAC_MD_2_STAT | b | `(d[4] >> 5) & 0x7` | all |
| 5 | bits 0-6 | R_HVAC_BLW_FN_2_SP | b | `d[5] & 0x7F` | all |

## 0x381  ·  bytes 0-4 used  ·  PPS: vehcfg, vehcfg0

| bytes | bits | signal | type | decode | tables |
|---|---|---|---|---|---|
| 0 | bit 6 | VC_DampingPrsnt | b | `(d[0] >> 6) & 0x1` | 1,2,3,4,5,7,8 |
| 0 | bit 4 | VC_PdlsMdPrsnt | b | `(d[0] >> 4) & 0x1` | 0,6 |
| 0 | bit 3 | VC_PdlsMdPrsnt | b | `(d[0] >> 3) & 0x1` | 1,2,3,4,5,7,8 |
| 0 | bit 6 | VC_STP_PRSNT | b | `(d[0] >> 6) & 0x1` | 0,6 |
| 0 | bit 4 | VC_STP_PRSNT | b | `(d[0] >> 4) & 0x1` | 1,2,3,4,5,7,8 |
| 0 | bit 7 | VC_Screen_Off | b | `(d[0] >> 7) & 0x1` | 1,2,3,4,5,7,8 |
| 0 | bit 5 | VC_SuspPrsnt | b | `(d[0] >> 5) & 0x1` | 1,2,3,4,5,7,8 |
| 0 | bit 3 | VC_TrnsDrvMdPrsnt | b | `(d[0] >> 3) & 0x1` | 0,6 |
| 0 | bit 2 | VC_TrnsDrvMdPrsnt | b | `(d[0] >> 2) & 0x1` | 1,2,3,4,5,7,8 |
| 0 | bits 0-1 | VC_VehCfg7_Stat | b | `d[0] & 0x3` | all |
| 1 | bits 0-5 | VC_TransType | b | `d[1] & 0x3F` | 0,6 |
| 2 | bit 0 | TeenKeyFeaturePresent | b | `d[2] & 0x1` | 0,6 |
| 2 | bit 6 | VC_DampingPrsnt | b | `(d[2] >> 6) & 0x1` | 0,6 |
| 2 | bit 1 | VC_SVC_Prsnt | b | `(d[2] >> 1) & 0x1` | 0,6 |
| 2 | bit 5 | VC_SuspPrsnt | b | `(d[2] >> 5) & 0x1` | 0,6 |
| 3 | bit 0 | VC_RedKey | b | `d[3] & 0x1` | 0,6 |
| 3 | bit 4 | VC_Trans_Equipped | b | `(d[3] >> 4) & 0x1` | 0,6 |
| 4 | bit 7 | VC_TSBM_Prsnt | b | `(d[4] >> 7) & 0x1` | 0,6 |

## 0x383  ·  bytes 0-0 used  ·  PPS: dvd

| bytes | bits | signal | type | decode | tables |
|---|---|---|---|---|---|
| 0 | ? (raw shift=8 mask=0xFF) | DVD | j | `type j: raw byte 0` | all |

## 0x384  ·  bytes 0-0 used  ·  PPS: dvd

| bytes | bits | signal | type | decode | tables |
|---|---|---|---|---|---|
| 0 | ? (raw shift=8 mask=0xFF) | DVD1 | j | `type j: raw byte 0` | all |

## 0x385  ·  bytes 0-0 used  ·  PPS: dvd

| bytes | bits | signal | type | decode | tables |
|---|---|---|---|---|---|
| 0 | ? (raw shift=8 mask=0xFF) | DVD2 | j | `type j: raw byte 0` | all |

## 0x386  ·  bytes 0-0 used  ·  PPS: dvd

| bytes | bits | signal | type | decode | tables |
|---|---|---|---|---|---|
| 0 | ? (raw shift=8 mask=0xFF) | DVD3 | j | `type j: raw byte 0` | all |

## 0x38F  ·  bytes 0-8 used  ·  PPS: vehstat

| bytes | bits | signal | type | decode | tables |
|---|---|---|---|---|---|
| 0 | bits 0-2 | SelTrlrNum | b | `d[0] & 0x7` | all |
| 0 | bits 3-7 | SelTrlrStyle | b | `(d[0] >> 3) & 0x1F` | all |
| 1-3 | 24-bit | TrlrTripDist | y | `d[3]<<16 \| d[2]<<8 \| d[1]` | all |
| 5 | bits 0-4 | TrlrStyle_1 | b | `d[5] & 0x1F` | all |
| 6 | bits 0-4 | TrlrStyle_2 | b | `d[6] & 0x1F` | all |
| 7 | bits 0-4 | TrlrStyle_3 | b | `d[7] & 0x1F` | all |
| 8 | bits 0-4 | TrlrStyle_4 | b | `d[8] & 0x1F` | all |

## 0x394  ·  bytes 0-0 used  ·  PPS: teenkey

| bytes | bits | signal | type | decode | tables |
|---|---|---|---|---|---|
| 0 | bits 0-2 | TeenKeyMaxSpeedLimit | b | `d[0] & 0x7` | 6 |

## 0x395  ·  bytes 0-0 used  ·  PPS: personal

| bytes | bits | signal | type | decode | tables |
|---|---|---|---|---|---|
| 0 | bit 3 | ReadyToDriveStatus | b | `(d[0] >> 3) & 0x1` | 6 |
| 0 | bits 0-1 | UNIT_SET_CSO | b | `d[0] & 0x3` | 6 |

## 0x3A2  ·  bytes 0-2 used  ·  PPS: vehstat

| bytes | bits | signal | type | decode | tables |
|---|---|---|---|---|---|
| 1-2 | 16-bit | IGN_OFF_TIME_LNG | y | `d[2]<<8 \| d[1]` | all |

## 0x3A7  ·  bytes 0-1 used  ·  PPS: ves

| bytes | bits | signal | type | decode | tables |
|---|---|---|---|---|---|
| 0 | bits 0-3 | VES2_AUX1_STAT | b | `d[0] & 0xF` | all |
| 0 | bits 4-7 | VES2_AUX2_STAT | b | `(d[0] >> 4) & 0xF` | all |
| 1 | bits 4-7 | VES2_Src_IR_Stat | b | `(d[1] >> 4) & 0xF` | all |
| 1 | bits 0-3 | VES2_Src_TGW_Stat | b | `d[1] & 0xF` | all |

## 0x3B2  ·  bytes 0-7 used  ·  PPS: comfortstat, personal, vehstat

| bytes | bits | signal | type | decode | tables |
|---|---|---|---|---|---|
| 0 | bit 6 | AHB_ENBL | b | `(d[0] >> 6) & 0x1` | all |
| 0 | bits 0-1 | EC_MirrStat | b | `d[0] & 0x3` | all |
| 0 | bit 5 | INVERTER_ON | b | `(d[0] >> 5) & 0x1` | all |
| 0 | bit 2 | PNC_ALM_ACT | b | `(d[0] >> 2) & 0x1` | all |
| 0 | bit 3 | TurnInd_LT_ON | b | `(d[0] >> 3) & 0x1` | 0,6 |
| 0 | bit 4 | TurnInd_RT_ON | b | `(d[0] >> 4) & 0x1` | 0,6 |
| 1 | bits 0-7 | AirTemp_Outsd | b | `d[1] & 0xFF` | 1,2,3,4,5,7,8 |
| 1 | bits 5-7 | CUSTOM_HK_RQ | b | `(d[1] >> 5) & 0x7` | 6 |
| 1 | bits 3-4 | SRT_HK_RQ | b | `(d[1] >> 3) & 0x3` | 6 |
| 1 | bit 2 | VALET_LK_OUT | b | `(d[1] >> 2) & 0x1` | 6 |
| 2 | bits 0-7 | AirTemp_Outsd | b | `d[2] & 0xFF` | 0,6 |
| 2 | bits 2-3 | AutoVehHoldSts | b | `(d[2] >> 2) & 0x3` | 1,2,3,4,5,7,8 |
| 2 | bits 4-5 | E_CALL_BtnStat | b | `(d[2] >> 4) & 0x3` | 1,2,3,4,5,7,8 |
| 2 | bits 6-7 | U_CALL_BtnStat | b | `(d[2] >> 6) & 0x3` | 1,2,3,4,5,7,8 |
| 3-4 | 16-bit | INST_FUEL_ECO | y | `d[4]<<8 \| d[3]` | 1,2,3,4,5,7,8 |
| 4 | bits 2-3 | AutoVehHoldSts | b | `(d[4] >> 2) & 0x3` | 0,6 |
| 4 | bits 4-5 | E_CALL_BtnStat | b | `(d[4] >> 4) & 0x3` | 0,6 |
| 4 | bits 6-7 | U_CALL_BtnStat | b | `(d[4] >> 6) & 0x3` | 0,6 |
| 5-6 | 16-bit | INST_FUEL_ECO | y | `d[6]<<8 \| d[5]` | 0,6 |
| 5 | bits 6-7 | SHIP_STAT | b | `(d[5] >> 6) & 0x3` | 1,2,3,4,5,7,8 |
| 7 | bits 6-7 | SHIP_STAT | b | `(d[7] >> 6) & 0x3` | 0,6 |

## 0x3B3  ·  bytes 0-8 used  ·  PPS: vehcfg, vehcfg0

| bytes | bits | signal | type | decode | tables |
|---|---|---|---|---|---|
| 0 | bit 7 | ElectPowerSteering | b | `(d[0] >> 7) & 0x1` | all |
| 0 | bits 2-3 | ParkAssist | b | `(d[0] >> 2) & 0x3` | all |
| 0 | bit 4 | ParkAssistBraking | b | `(d[0] >> 4) & 0x1` | all |
| 0 | bit 5 | ParkAssistFrontVolume | b | `(d[0] >> 5) & 0x1` | all |
| 0 | bit 6 | ParkAssistRearVolume | b | `(d[0] >> 6) & 0x1` | all |
| 0 | bits 0-1 | VehCfgCS01_Stat | b | `d[0] & 0x3` | all |
| 1 | bit 7 | CHMSL_CameraGuidelines | b | `(d[1] >> 7) & 0x1` | 0,6 |
| 1 | bit 2 | ForwardCollisionBraking | b | `(d[1] >> 2) & 0x1` | all |
| 1 | bits 0-1 | ForwardCollisionWarning | b | `d[1] & 0x3` | all |
| 1 | bits 3-4 | HornWithRemoteLock | b | `(d[1] >> 3) & 0x3` | all |
| 1 | bit 6 | HornWithRemoteLower | b | `(d[1] >> 6) & 0x1` | all |
| 1 | bit 5 | HornWithRemoteStart | b | `(d[1] >> 5) & 0x1` | all |
| 1 | bit 7 | VC_CHMSL_LINE_CSO | b | `(d[1] >> 7) & 0x1` | 1,2,3,4,5,7,8 |
| 2 | bits 0-1 | AutoDriverComfort | b | `d[2] & 0x3` | all |
| 2 | bits 2-3 | AuxillarySwitches | b | `(d[2] >> 2) & 0x3` | all |
| 2 | bits 4-5 | RearCameraGridlines | b | `(d[2] >> 4) & 0x3` | all |
| 2 | bit 6 | VC_UNIT_SET_CSO | b | `(d[2] >> 6) & 0x1` | 6 |
| 3 | bit 0 | AccessoryDelay | b | `d[3] & 0x1` | all |
| 3 | bit 1 | AdaptiveFrontLightSystem | b | `(d[3] >> 1) & 0x1` | all |
| 3 | bit 4 | AirSuspensionWarning | b | `(d[3] >> 4) & 0x1` | all |
| 3 | bit 2 | AmbientDimmer | b | `(d[3] >> 2) & 0x1` | all |
| 3 | bit 5 | AutoAeroMode | b | `(d[3] >> 5) & 0x1` | all |
| 3 | bit 6 | AutoHighBeam | b | `(d[3] >> 6) & 0x1` | all |
| 3 | bit 7 | AutoPark | b | `(d[3] >> 7) & 0x1` | all |
| 3 | bit 3 | TireJackMode | b | `(d[3] >> 3) & 0x1` | all |
| 4 | bit 7 | AutoDoorLock | b | `(d[4] >> 7) & 0x1` | all |
| 4 | bit 0 | BlindSpot | b | `d[4] & 0x1` | all |
| 4 | bit 1 | CapacityUnits | b | `(d[4] >> 1) & 0x1` | all |
| 4 | bit 3 | CompassCalibration | b | `(d[4] >> 3) & 0x1` | all |
| 4 | bit 4 | CompassVariance | b | `(d[4] >> 4) & 0x1` | all |
| 4 | bit 5 | ConsumptionUnits | b | `(d[4] >> 5) & 0x1` | all |
| 4 | bit 2 | DigitalClock | b | `(d[4] >> 2) & 0x1` | all |
| 4 | bit 6 | DistanceUnits | b | `(d[4] >> 6) & 0x1` | all |
| 5 | bit 0 | AutoDoorUnlock | b | `d[5] & 0x1` | all |
| 5 | bit 3 | AutoEntryExit | b | `(d[5] >> 3) & 0x1` | all |
| 5 | bit 1 | DaytimeRunningLights | b | `(d[5] >> 1) & 0x1` | all |
| 5 | bit 2 | EasySeatExit | b | `(d[5] >> 2) & 0x1` | all |
| 5 | bit 4 | ElectronicParkBrake | b | `(d[5] >> 4) & 0x1` | all |
| 5 | bit 5 | FlashLampWithLock | b | `(d[5] >> 5) & 0x1` | all |
| 5 | bit 6 | HeadlampDrop | b | `(d[5] >> 6) & 0x1` | all |
| 5 | bit 7 | HeadlampOffDelay | b | `(d[5] >> 7) & 0x1` | all |
| 6 | bit 5 | FlashLightsWithRemoteLower | b | `(d[6] >> 5) & 0x1` | all |
| 6 | bit 0 | HeadlampWithWiper | b | `d[6] & 0x1` | all |
| 6 | bit 1 | HillStartAssist | b | `(d[6] >> 1) & 0x1` | all |
| 6 | bit 2 | IlluminatedApproach | b | `(d[6] >> 2) & 0x1` | all |
| 6 | bit 3 | LaneDepartureTorque | b | `(d[6] >> 3) & 0x1` | all |
| 6 | bit 4 | LaneDepartureWarning | b | `(d[6] >> 4) & 0x1` | all |
| 6 | bit 6 | NavigationTurnByTurn | b | `(d[6] >> 6) & 0x1` | all |
| 6 | bit 7 | PassiveEntry | b | `(d[6] >> 7) & 0x1` | all |
| 7 | bit 0 | PerformanceShiftEnable | b | `d[7] & 0x1` | all |
| 7 | bit 1 | PerformanceShiftRPM | b | `(d[7] >> 1) & 0x1` | all |
| 7 | bit 2 | PowerLiftGate | b | `(d[7] >> 2) & 0x1` | all |
| 7 | bit 5 | PowerTakeOff | b | `(d[7] >> 5) & 0x1` | all |
| 7 | bit 3 | PowerUnits | b | `(d[7] >> 3) & 0x1` | all |
| 7 | bit 4 | PressureUnits | b | `(d[7] >> 4) & 0x1` | all |
| 7 | bit 6 | RainSensitiveWipers | b | `(d[7] >> 6) & 0x1` | all |
| 7 | bit 7 | RearCamera | b | `(d[7] >> 7) & 0x1` | all |
| 8 | bit 0 | VC_Police_PE_CSO | b | `d[8] & 0x1` | 6,7 |

## 0x3B4  ·  bytes 0-7 used  ·  PPS: vehcfg, vehcfg0

| bytes | bits | signal | type | decode | tables |
|---|---|---|---|---|---|
| 0 | bit 3 | RKELinkedToMemory | b | `(d[0] >> 3) & 0x1` | all |
| 0 | bit 4 | RKEUnlock | b | `(d[0] >> 4) & 0x1` | all |
| 0 | bit 2 | RearCameraDelay | b | `(d[0] >> 2) & 0x1` | all |
| 0 | bit 5 | SpeedUnits | b | `(d[0] >> 5) & 0x1` | all |
| 0 | bit 6 | TiltMirrorInReverse | b | `(d[0] >> 6) & 0x1` | all |
| 0 | bit 7 | TorqueUnits | b | `(d[0] >> 7) & 0x1` | all |
| 0 | bits 0-1 | VehCfgCS02_Stat | b | `d[0] & 0x3` | all |
| 1 | bit 6 | FuelSaver | b | `(d[1] >> 6) & 0x1` | all |
| 1 | bit 7 | TemperatureUnits | b | `(d[1] >> 7) & 0x1` | all |
| 1 | bit 0 | TrailerName | b | `d[1] & 0x1` | all |
| 1 | bit 1 | TrailerNumber | b | `(d[1] >> 1) & 0x1` | all |
| 1 | bit 2 | TrailerType | b | `(d[1] >> 2) & 0x1` | all |
| 1 | bit 3 | TransportMode | b | `(d[1] >> 3) & 0x1` | all |
| 1 | bit 4 | USMetric | b | `(d[1] >> 4) & 0x1` | all |
| 1 | bit 5 | WheelAlignment | b | `(d[1] >> 5) & 0x1` | all |
| 2 | bit 2 | HandsFreeLiftGatePresent | b | `(d[2] >> 2) & 0x1` | 0,6 |
| 2 | bit 3 | HandsFreeSlidingDoorPresent | b | `(d[2] >> 3) & 0x1` | 0,6 |
| 2 | bit 1 | PowerFoldingMirrorPresent | b | `(d[2] >> 1) & 0x1` | 0,6 |
| 2 | bit 4 | SVCGridlines | b | `(d[2] >> 4) & 0x1` | 0,6 |
| 2 | bit 5 | SVC_Delay | b | `(d[2] >> 5) & 0x1` | 0,6 |
| 2 | bit 6 | SliderDoorAlert | b | `(d[2] >> 6) & 0x1` | 0,6 |
| 2 | bit 7 | TeenKeyFCWSensitivityPresent | b | `(d[2] >> 7) & 0x1` | 0,6 |
| 2 | bit 0 | VC_AutoOnFeatureMethod | b | `d[2] & 0x1` | 1,7,8 |
| 3 | bit 7 | TeenKeyBlindSpotPresent | b | `(d[3] >> 7) & 0x1` | 0,6 |
| 3 | bit 0 | TeenKeyFCWBrakingPresent | b | `d[3] & 0x1` | 0,6 |
| 3 | bit 2 | TeenKeyFTParkAssistVolPresent | b | `(d[3] >> 2) & 0x1` | 0,6 |
| 3 | bit 6 | TeenKeyFuelPopupPresent | b | `(d[3] >> 6) & 0x1` | 0,6 |
| 3 | bit 5 | TeenKeyFuelWarningPresent | b | `(d[3] >> 5) & 0x1` | 0,6 |
| 3 | bit 4 | TeenKeyMaxSpeedLimitPresent | b | `(d[3] >> 4) & 0x1` | 0,6 |
| 3 | bit 1 | TeenKeyParkAssistPresent | b | `(d[3] >> 1) & 0x1` | 0,6 |
| 3 | bit 3 | TeenKeyRRParkAssistVolPresent | b | `(d[3] >> 3) & 0x1` | 0,6 |
| 4 | bit 7 | SettingsPaddleModePresent | b | `(d[4] >> 7) & 0x1` | 0,6 |
| 4 | bit 1 | TeenKeyAutoHighBeamsPresent | b | `(d[4] >> 1) & 0x1` | 0,6 |
| 4 | bit 2 | TeenKeyHLsWithWipersPresent | b | `(d[4] >> 2) & 0x1` | 0,6 |
| 4 | bit 0 | TeenKeyRainSenseWipersPresent | b | `d[4] & 0x1` | 0,6 |
| 5 | bit 0 | FlashLightSlideDoorPresent | b | `d[5] & 0x1` | 0,6 |
| 5 | bit 0 | VC_AutoOnFeatureMethod | b | `d[5] & 0x1` | 2,3,4,5 |
| 5 | bit 7 | VC_FCW_SW_CSO | b | `(d[5] >> 7) & 0x1` | 0,6 |
| 6 | bit 7 | ReadyToDrivePresent | b | `(d[6] >> 7) & 0x1` | 6 |
| 6 | bit 7 | VC_RDY_DRV_CSO | b | `(d[6] >> 7) & 0x1` | 0 |
| 7 | bit 0 | VC_AutoOnFeatureMethod | b | `d[7] & 0x1` | 0,6 |

## 0x3C7  ·  bytes 0-7 used  ·  PPS: dvd

| bytes | bits | signal | type | decode | tables |
|---|---|---|---|---|---|
| 0 | bits 2-5 | DVD_DISC_NUM | b | `(d[0] >> 2) & 0xF` | all |
| 0 | bit 0 | DVD_DISC_TYPE | b | `d[0] & 0x1` | all |
| 0 | bit 1 | DVD_DISP_MD | b | `(d[0] >> 1) & 0x1` | all |
| 1-2 | 16-bit | DVD_TRK_FILE | y | `d[2]<<8 \| d[1]` | all |
| 3 | bits 0-2 | DVD_MEDIA_PT | b | `d[3] & 0x7` | all |
| 4 | bit 7 | DVD_NEG_TIME | b | `(d[4] >> 7) & 0x1` | all |
| 4 | bit 0 | DVD_RND_MD | b | `d[4] & 0x1` | all |
| 4 | bit 1 | DVD_RPT_MD | b | `(d[4] >> 1) & 0x1` | all |
| 5 | bits 0-7 | DVD_HOUR | b | `d[5] & 0xFF` | all |
| 6 | bits 0-7 | DVD_MINUTE | b | `d[6] & 0xFF` | all |
| 7 | bits 0-7 | DVD_SECOND | b | `d[7] & 0xFF` | all |

## 0x3C9  ·  bytes 0-1 used  ·  PPS: comfortstat

| bytes | bits | signal | type | decode | tables |
|---|---|---|---|---|---|
| 0 | bits 0-7 | AMB_TEMP_AVG_F | b | `d[0] & 0xFF` | all |
| 1 | bits 0-7 | AMB_TEMP_AVG_C | b | `d[1] & 0xFF` | all |

## 0x3CF  ·  bytes 0-7 used  ·  PPS: srt

| bytes | bits | signal | type | decode | tables |
|---|---|---|---|---|---|
| 1 | bits 0-7 | SRT_60mphTmC | b | `d[1] & 0xFF` | all |
| 2 | bits 0-7 | SRT_eighthTmC | b | `d[2] & 0xFF` | all |
| 3 | bits 0-7 | SRT_quarterTmC | b | `d[3] & 0xFF` | all |
| 4 | bits 0-7 | SRT_EthSpdC_M | b | `d[4] & 0xFF` | all |
| 5 | bits 0-7 | SRT_QrtSpdC_M | b | `d[5] & 0xFF` | all |
| 6 | bits 0-7 | SRT_BrkSpdC_M | b | `d[6] & 0xFF` | all |
| 7 | bits 0-7 | SRT_BrkDistC_M | b | `d[7] & 0xFF` | all |

## 0x3D2  ·  bytes 0-2 used  ·  PPS: vehstat

| bytes | bits | signal | type | decode | tables |
|---|---|---|---|---|---|
| 0-2 | 24-bit | ODO | y | `d[2]<<16 \| d[1]<<8 \| d[0]` | all |

## 0x3DE  ·  bytes 0-7 used  ·  PPS: audioctl, compact, personal

| bytes | bits | signal | type | decode | tables |
|---|---|---|---|---|---|
| 0 | bit 4 | AUTO_LK | b | `(d[0] >> 4) & 0x1` | all |
| 0 | bit 5 | AUTO_UNLK | b | `(d[0] >> 5) & 0x1` | all |
| 0 | bit 7 | CFG_AUTO_WPR | b | `(d[0] >> 7) & 0x1` | all |
| 0 | bit 6 | DR_ALR | b | `(d[0] >> 6) & 0x1` | all |
| 0 | bit 2 | FLASH_LK | b | `(d[0] >> 2) & 0x1` | all |
| 0 | bit 3 | HL_WPR | b | `(d[0] >> 3) & 0x1` | all |
| 0 | bit 0 | RKE_ONE_PRESS_ENBL | b | `d[0] & 0x1` | all |
| 0 | bit 1 | SOUND_LK | b | `(d[0] >> 1) & 0x1` | all |
| 1 | bits 0-7 | ILL_APRCH_TIME | b | `d[1] & 0xFF` | all |
| 2 | bits 0-7 | HL_DLY_TIME | b | `d[2] & 0xFF` | all |
| 3-4 | 16-bit | ACC_DLY_TIME | y | `d[4]<<8 \| d[3]` | all |
| 5 | bits 4-5 | AutoSwitch | b | `(d[5] >> 4) & 0x3` | 5 |
| 5 | bit 0 | DRL_ON | b | `d[5] & 0x1` | all |
| 5 | bit 1 | ECM_Enbl | b | `(d[5] >> 1) & 0x1` | all |
| 5 | bit 2 | HandsFreeSlidingDoorStat | b | `(d[5] >> 2) & 0x1` | 6 |
| 5 | bit 6 | OffWithDoorOpen | b | `(d[5] >> 6) & 0x1` | 5 |
| 5 | bit 3 | SLD_DR_Chime_Enbl | b | `(d[5] >> 3) & 0x1` | 6 |
| 6 | bit 0 | ACC_DLY_ACT | b | `d[6] & 0x1` | all |
| 6 | bit 5 | AUTO_RELK | b | `(d[6] >> 5) & 0x1` | all |
| 6 | bit 7 | DynamicGridResp | b | `(d[6] >> 7) & 0x1` | all |
| 6 | bit 2 | RemLoHrnEnbl | b | `(d[6] >> 2) & 0x1` | all |
| 6 | bit 3 | RemLoLgtEnbl | b | `(d[6] >> 3) & 0x1` | all |
| 6 | bit 4 | SOUND_RS | b | `(d[6] >> 4) & 0x1` | all |
| 6 | bit 6 | StaticGridResp | b | `(d[6] >> 6) & 0x1` | all |
| 7 | bit 2 | DynamicGridRespFail | b | `(d[7] >> 2) & 0x1` | all |
| 7 | bits 0-1 | SOUND_LK_1ST_2ND | b | `d[7] & 0x3` | all |
| 7 | bit 3 | SWSError | b | `(d[7] >> 3) & 0x1` | all |

## 0x3E0  ·  bytes 0-16 used  ·  PPS: vehcfg

| bytes | bits | signal | type | decode | tables |
|---|---|---|---|---|---|
| 0-16 | 17 chars | VIN | s | `ascii(d[0..16])` | all |

## 0x3E1  ·  bytes 0-1 used  ·  PPS: can_c

| bytes | bits | signal | type | decode | tables |
|---|---|---|---|---|---|
| 0 | bits 0-7 | DISPLACEMENT | b | `d[0] & 0xFF` | all |
| 1 | bits 5-7 | ENG_ASP | b | `(d[1] >> 5) & 0x7` | all |

## 0x3E3  ·  bytes 0-5 used  ·  PPS: vehcfg, vehcfg0

| bytes | bits | signal | type | decode | tables |
|---|---|---|---|---|---|
| 0 | bits 0-1 | NET_CFG_STAT_INT | b | `d[0] & 0x3` | 0,6 |
| 0 | bit 3 | NetCfg_BSM | b | `(d[0] >> 3) & 0x1` | 1,2,3,4,5,7,8 |
| 0 | bit 4 | NetCfg_CBC_IN | b | `(d[0] >> 4) & 0x1` | 1,2,3,4,5,7,8 |
| 0 | bit 5 | NetCfg_CSWM | b | `(d[0] >> 5) & 0x1` | 1,2,3,4,5,7,8 |
| 0 | bit 6 | NetCfg_DCM_DR | b | `(d[0] >> 6) & 0x1` | 1,2,3,4,5,7,8 |
| 0 | bit 7 | NetCfg_DCM_PASS | b | `(d[0] >> 7) & 0x1` | 1,2,3,4,5,7,8 |
| 0 | bit 2 | NetCfg_RBSS | b | `(d[0] >> 2) & 0x1` | 1,2,3,4,5,7,8 |
| 1 | bit 3 | NetCfg_BSM | b | `(d[1] >> 3) & 0x1` | 0,6 |
| 1 | bit 4 | NetCfg_CBC_IN | b | `(d[1] >> 4) & 0x1` | 0,6 |
| 1 | bit 5 | NetCfg_CSWM | b | `(d[1] >> 5) & 0x1` | 0,6 |
| 1 | bit 6 | NetCfg_DCM_DR | b | `(d[1] >> 6) & 0x1` | 0,6 |
| 1 | bit 7 | NetCfg_DCM_PASS | b | `(d[1] >> 7) & 0x1` | 0,6 |
| 1 | bit 0 | NetCfg_DCM_RL | b | `d[1] & 0x1` | 1,2,3,4,5,7,8 |
| 1 | bit 1 | NetCfg_DCM_RR | b | `(d[1] >> 1) & 0x1` | 1,2,3,4,5,7,8 |
| 1 | bit 2 | NetCfg_HVAC | b | `(d[1] >> 2) & 0x1` | 1,2,3,4,5,7,8 |
| 1 | bit 3 | NetCfg_MSM | b | `(d[1] >> 3) & 0x1` | 1,2,3,4,5,7,8 |
| 1 | bit 4 | NetCfg_PLG | b | `(d[1] >> 4) & 0x1` | 1,2,3,4,5,7,8 |
| 1 | bit 6 | NetCfg_PSD_LT | b | `(d[1] >> 6) & 0x1` | 1,2,3,4,5,7,8 |
| 1 | bit 7 | NetCfg_PSD_RT | b | `(d[1] >> 7) & 0x1` | 1,2,3,4,5,7,8 |
| 1 | bit 2 | NetCfg_RBSS | b | `(d[1] >> 2) & 0x1` | 0,6 |
| 2 | bit 5 | NetCfg_CLOCK | b | `(d[2] >> 5) & 0x1` | 1,2,3,4,5,7,8 |
| 2 | bit 0 | NetCfg_DCM_RL | b | `d[2] & 0x1` | 0,6 |
| 2 | bit 1 | NetCfg_DCM_RR | b | `(d[2] >> 1) & 0x1` | 0,6 |
| 2 | bit 3 | NetCfg_DTV | b | `(d[2] >> 3) & 0x1` | 1,2,3,4,5,7,8 |
| 2 | bit 0 | NetCfg_FSM | b | `d[2] & 0x1` | 1,2,3,4,5,7,8 |
| 2 | bit 2 | NetCfg_HVAC | b | `(d[2] >> 2) & 0x1` | 0,6 |
| 2 | bit 7 | NetCfg_ITM | b | `(d[2] >> 7) & 0x1` | 1,2,3,4,5,7,8 |
| 2 | bit 3 | NetCfg_MSM | b | `(d[2] >> 3) & 0x1` | 0,6 |
| 2 | bit 4 | NetCfg_PLG | b | `(d[2] >> 4) & 0x1` | 0,6 |
| 2 | bit 6 | NetCfg_PSD_LT | b | `(d[2] >> 6) & 0x1` | 0,6 |
| 2 | bit 7 | NetCfg_PSD_RT | b | `(d[2] >> 7) & 0x1` | 0,6 |
| 2 | bit 1 | NetCfg_PTCM | b | `(d[2] >> 1) & 0x1` | 1,2,3,4,5,7,8 |
| 2 | bit 2 | NetCfg_RBC | b | `(d[2] >> 2) & 0x1` | 1,2,3,4,5,7,8 |
| 2 | bit 4 | NetCfg_TGW | b | `(d[2] >> 4) & 0x1` | 1,2,3,4,5,7,8 |
| 2 | bit 6 | NetCfg_VSIM | b | `(d[2] >> 6) & 0x1` | 1,2,3,4,5,7,8 |
| 3 | bit 0 | NetCfg_AMP_I | b | `d[3] & 0x1` | 1,2,3,4,5,7,8 |
| 3 | bit 5 | NetCfg_CLOCK | b | `(d[3] >> 5) & 0x1` | 0,6 |
| 3 | bit 6 | NetCfg_CRSM | b | `(d[3] >> 6) & 0x1` | 1,2,3,4,5,7,8 |
| 3 | bit 3 | NetCfg_DTV | b | `(d[3] >> 3) & 0x1` | 0,6 |
| 3 | bit 1 | NetCfg_DVD_CDM | b | `(d[3] >> 1) & 0x1` | 1,2,3,4,5,7,8 |
| 3 | bit 0 | NetCfg_FSM | b | `d[3] & 0x1` | 0,6 |
| 3 | bit 2 | NetCfg_HFM_CTM | b | `(d[3] >> 2) & 0x1` | 1,2,3,4,5,7,8 |
| 3 | bit 7 | NetCfg_HVAC_R | b | `(d[3] >> 7) & 0x1` | 1,2,3,4,5,7,8 |
| 3 | bit 3 | NetCfg_ICS_I | b | `(d[3] >> 3) & 0x1` | 1,2,3,4,5,7,8 |
| 3 | bit 7 | NetCfg_ITM | b | `(d[3] >> 7) & 0x1` | 0,6 |
| 3 | bit 1 | NetCfg_PTCM | b | `(d[3] >> 1) & 0x1` | 0,6 |
| 3 | bit 2 | NetCfg_RBC | b | `(d[3] >> 2) & 0x1` | 0,6 |
| 3 | bit 4 | NetCfg_TGW | b | `(d[3] >> 4) & 0x1` | 0,6 |
| 3 | bit 4 | NetCfg_VES2_I | b | `(d[3] >> 4) & 0x1` | 1,2,3,4,5,7,8 |
| 3 | bit 5 | NetCfg_VES3_I | b | `(d[3] >> 5) & 0x1` | 1,2,3,4,5,7,8 |
| 3 | bit 6 | NetCfg_VSIM | b | `(d[3] >> 6) & 0x1` | 0,6 |
| 4 | bit 0 | NetCfg_AMP_I | b | `d[4] & 0x1` | 0,6 |
| 4 | bit 6 | NetCfg_CRSM | b | `(d[4] >> 6) & 0x1` | 0,6 |
| 4 | bit 0 | NetCfg_CVPM | b | `d[4] & 0x1` | 1,2,3,4,5,7,8 |
| 4 | bit 1 | NetCfg_DVD_CDM | b | `(d[4] >> 1) & 0x1` | 0,6 |
| 4 | bit 2 | NetCfg_HFM_CTM | b | `(d[4] >> 2) & 0x1` | 0,6 |
| 4 | bit 7 | NetCfg_HVAC_R | b | `(d[4] >> 7) & 0x1` | 0,6 |
| 4 | bit 3 | NetCfg_ICS_I | b | `(d[4] >> 3) & 0x1` | 0,6 |
| 4 | bit 4 | NetCfg_VES2_I | b | `(d[4] >> 4) & 0x1` | 0,6 |
| 4 | bit 5 | NetCfg_VES3_I | b | `(d[4] >> 5) & 0x1` | 0,6 |
| 5 | bit 0 | NetCfg_CVPM | b | `d[5] & 0x1` | 0,6 |
| 5 | bit 5 | NetCfg_DCSD | b | `(d[5] >> 5) & 0x1` | 6 |
| 5 | bit 6 | NetCfg_TBM | b | `(d[5] >> 6) & 0x1` | 6 |
| 5 | bit 4 | NetCfg_VRM | b | `(d[5] >> 4) & 0x1` | 6 |

## 0x3E4  ·  bytes 0-5 used  ·  PPS: vehcfg, vehcfg0

| bytes | bits | signal | type | decode | tables |
|---|---|---|---|---|---|
| 0 | bits 0-1 | NET_CFG_STAT_PT | b | `d[0] & 0x3` | 0,6 |
| 0 | bit 2 | NetCfg_ACC | b | `(d[0] >> 2) & 0x1` | 1,2,3,4,5,7,8 |
| 0 | bit 3 | NetCfg_ADCM | b | `(d[0] >> 3) & 0x1` | 1,2,3,4,5,7,8 |
| 0 | bit 4 | NetCfg_AHLM | b | `(d[0] >> 4) & 0x1` | 1,2,3,4,5,7,8 |
| 0 | bit 6 | NetCfg_ASCM | b | `(d[0] >> 6) & 0x1` | 1,2,3,4,5,7,8 |
| 0 | bit 7 | NetCfg_CBC_PT | b | `(d[0] >> 7) & 0x1` | 1,2,3,4,5,7,8 |
| 0 | bit 5 | NetCfg_VSIM_C | b | `(d[0] >> 5) & 0x1` | 1,2,3,4,5,7,8 |
| 1 | bit 2 | NetCfg_ACC | b | `(d[1] >> 2) & 0x1` | 0,6 |
| 1 | bit 3 | NetCfg_ADCM | b | `(d[1] >> 3) & 0x1` | 0,6 |
| 1 | bit 4 | NetCfg_AHLM | b | `(d[1] >> 4) & 0x1` | 0,6 |
| 1 | bit 6 | NetCfg_ASCM | b | `(d[1] >> 6) & 0x1` | 0,6 |
| 1 | bit 7 | NetCfg_CBC_PT | b | `(d[1] >> 7) & 0x1` | 0,6 |
| 1 | bit 0 | NetCfg_DTCM | b | `d[1] & 0x1` | 1,2,3,4,5,7,8 |
| 1 | bit 1 | NetCfg_ECM | b | `(d[1] >> 1) & 0x1` | 1,2,3,4,5,7,8 |
| 1 | bit 5 | NetCfg_EPB | b | `(d[1] >> 5) & 0x1` | 1,2,3,4,5,7,8 |
| 1 | bit 2 | NetCfg_EPS | b | `(d[1] >> 2) & 0x1` | 1,2,3,4,5,7,8 |
| 1 | bit 4 | NetCfg_ESC | b | `(d[1] >> 4) & 0x1` | 1,2,3,4,5,7,8 |
| 1 | bit 3 | NetCfg_ESM | b | `(d[1] >> 3) & 0x1` | 1,2,3,4,5,7,8 |
| 1 | bit 7 | NetCfg_IC | b | `(d[1] >> 7) & 0x1` | 1,2,3,4,5,7,8 |
| 1 | bit 6 | NetCfg_RF_HUB | b | `(d[1] >> 6) & 0x1` | 1,2,3,4,5,7,8 |
| 1 | bit 5 | NetCfg_VSIM_C | b | `(d[1] >> 5) & 0x1` | 0,6 |
| 2 | bit 0 | NetCfg_DASM | b | `d[2] & 0x1` | 1,2,3,4,5,7,8 |
| 2 | bit 0 | NetCfg_DTCM | b | `d[2] & 0x1` | 0,6 |
| 2 | bit 1 | NetCfg_ECM | b | `(d[2] >> 1) & 0x1` | 0,6 |
| 2 | bit 5 | NetCfg_EPB | b | `(d[2] >> 5) & 0x1` | 0,6 |
| 2 | bit 2 | NetCfg_EPPM | b | `(d[2] >> 2) & 0x1` | 1,2,3,4,5,7,8 |
| 2 | bit 2 | NetCfg_EPS | b | `(d[2] >> 2) & 0x1` | 0,6 |
| 2 | bit 4 | NetCfg_ESC | b | `(d[2] >> 4) & 0x1` | 0,6 |
| 2 | bit 3 | NetCfg_ESM | b | `(d[2] >> 3) & 0x1` | 0,6 |
| 2 | bit 1 | NetCfg_FDCM | b | `(d[2] >> 1) & 0x1` | 1,2,3,4,5,7,8 |
| 2 | bit 7 | NetCfg_IC | b | `(d[2] >> 7) & 0x1` | 0,6 |
| 2 | bit 3 | NetCfg_ORC | b | `(d[2] >> 3) & 0x1` | 1,2,3,4,5,7,8 |
| 2 | bit 4 | NetCfg_PTS | b | `(d[2] >> 4) & 0x1` | 1,2,3,4,5,7,8 |
| 2 | bit 5 | NetCfg_RBT_DR | b | `(d[2] >> 5) & 0x1` | 1,2,3,4,5,7,8 |
| 2 | bit 6 | NetCfg_RBT_PASS | b | `(d[2] >> 6) & 0x1` | 1,2,3,4,5,7,8 |
| 2 | bit 6 | NetCfg_RF_HUB | b | `(d[2] >> 6) & 0x1` | 0,6 |
| 2 | bit 7 | NetCfg_SCCM | b | `(d[2] >> 7) & 0x1` | 1,2,3,4,5,7,8 |
| 3 | bit 4 | NetCfg_AFLS | b | `(d[3] >> 4) & 0x1` | 1,2,3,4,5,7,8 |
| 3 | bit 0 | NetCfg_DASM | b | `d[3] & 0x1` | 0,6 |
| 3 | bit 0 | NetCfg_ELSD | b | `d[3] & 0x1` | 1,2,3,4,5,7,8 |
| 3 | bit 2 | NetCfg_EPPM | b | `(d[3] >> 2) & 0x1` | 0,6 |
| 3 | bit 1 | NetCfg_FDCM | b | `(d[3] >> 1) & 0x1` | 0,6 |
| 3 | bit 7 | NetCfg_HaLF | b | `(d[3] >> 7) & 0x1` | 1,2,3,4,5,7,8 |
| 3 | bit 5 | NetCfg_ITBM | b | `(d[3] >> 5) & 0x1` | 1,2,3,4,5,7,8 |
| 3 | bit 6 | NetCfg_OCM | b | `(d[3] >> 6) & 0x1` | 1,2,3,4,5,7,8 |
| 3 | bit 3 | NetCfg_ORC | b | `(d[3] >> 3) & 0x1` | 0,6 |
| 3 | bit 3 | NetCfg_PASS_PT | b | `(d[3] >> 3) & 0x1` | 1,2,3,4,5,7,8 |
| 3 | bit 4 | NetCfg_PTS | b | `(d[3] >> 4) & 0x1` | 0,6 |
| 3 | bit 5 | NetCfg_RBT_DR | b | `(d[3] >> 5) & 0x1` | 0,6 |
| 3 | bit 6 | NetCfg_RBT_PASS | b | `(d[3] >> 6) & 0x1` | 0,6 |
| 3 | bit 7 | NetCfg_SCCM | b | `(d[3] >> 7) & 0x1` | 0,6 |
| 3 | bit 1 | NetCfg_TCM | b | `(d[3] >> 1) & 0x1` | 1,2,3,4,5,7,8 |
| 3 | bit 2 | NetCfg_TPM | b | `(d[3] >> 2) & 0x1` | 1,2,3,4,5,7,8 |
| 4 | bit 4 | NetCfg_AFLS | b | `(d[4] >> 4) & 0x1` | 0,6 |
| 4 | bit 7 | NetCfg_ANC | b | `(d[4] >> 7) & 0x1` | 1,2,3,4,5,7,8 |
| 4 | bit 0 | NetCfg_ELSD | b | `d[4] & 0x1` | 0,6 |
| 4 | bit 7 | NetCfg_HaLF | b | `(d[4] >> 7) & 0x1` | 0,6 |
| 4 | bit 5 | NetCfg_ITBM | b | `(d[4] >> 5) & 0x1` | 0,6 |
| 4 | bit 6 | NetCfg_OCM | b | `(d[4] >> 6) & 0x1` | 0,6 |
| 4 | bit 3 | NetCfg_PASS_PT | b | `(d[4] >> 3) & 0x1` | 0,6 |
| 4 | bit 1 | NetCfg_TCM | b | `(d[4] >> 1) & 0x1` | 0,6 |
| 4 | bit 2 | NetCfg_TPM | b | `(d[4] >> 2) & 0x1` | 0,6 |
| 5 | bit 7 | NetCfg_ANC | b | `(d[5] >> 7) & 0x1` | 0,6 |
| 5 | bit 6 | NetCfg_HCP | b | `(d[5] >> 6) & 0x1` | 6 |

## 0x3E5  ·  bytes 0-9 used  ·  PPS: vehcfg0

| bytes | bits | signal | type | decode | tables |
|---|---|---|---|---|---|
| 0 | bit 0 | Proxi_BCM | b | `d[0] & 0x1` | all |
| 0 | bit 6 | Proxi_BSM | b | `(d[0] >> 6) & 0x1` | all |
| 0 | bit 1 | Proxi_ECM | b | `(d[0] >> 1) & 0x1` | all |
| 0 | bit 2 | Proxi_EPS | b | `(d[0] >> 2) & 0x1` | all |
| 0 | bit 3 | Proxi_IPC | b | `(d[0] >> 3) & 0x1` | all |
| 1 | bit 0 | Proxi_DDM_DMM_FDM_UDM | b | `d[1] & 0x1` | all |
| 1 | bit 2 | Proxi_ECC_ACM_MCM_MHM | b | `(d[1] >> 2) & 0x1` | all |
| 1 | bit 5 | Proxi_EPB | b | `(d[1] >> 5) & 0x1` | all |
| 1 | bit 3 | Proxi_MTA_TCM_DCTM | b | `(d[1] >> 3) & 0x1` | all |
| 2 | bit 2 | Proxi_DSM | b | `(d[2] >> 2) & 0x1` | all |
| 2 | bit 5 | Proxi_ESL | b | `(d[2] >> 5) & 0x1` | 0,1 |
| 2 | bit 6 | Proxi_GSM_STM | b | `(d[2] >> 6) & 0x1` | all |
| 2 | bit 1 | Proxi_PDM | b | `(d[2] >> 1) & 0x1` | all |
| 3 | bit 6 | Proxi_HALF | b | `(d[3] >> 6) & 0x1` | all |
| 3 | bit 0 | Proxi_PAM | b | `d[3] & 0x1` | all |
| 3 | bit 2 | Proxi_SDM_ORC | b | `(d[3] >> 2) & 0x1` | all |
| 4 | bit 4 | Proxi_LTM_ETM_HTM | b | `(d[4] >> 4) & 0x1` | all |
| 5 | bit 6 | Proxi_AMP | b | `(d[5] >> 6) & 0x1` | all |
| 5 | bit 7 | Proxi_CDM | b | `(d[5] >> 7) & 0x1` | 0,1 |
| 6 | bit 0 | Proxi_CSWM | b | `d[6] & 0x1` | all |
| 6 | bit 2 | Proxi_ICS_HCPM | b | `(d[6] >> 2) & 0x1` | all |
| 6 | bit 3 | Proxi_LBSS | b | `(d[6] >> 3) & 0x1` | all |
| 6 | bit 4 | Proxi_RBSS | b | `(d[6] >> 4) & 0x1` | all |
| 6 | bit 5 | Proxi_SCCM | b | `(d[6] >> 5) & 0x1` | all |
| 7 | bit 1 | Proxi_DASM | b | `(d[7] >> 1) & 0x1` | all |
| 8 | bit 3 | Proxi_DTCM | b | `(d[8] >> 3) & 0x1` | all |
| 8 | bit 5 | Proxi_PLGM | b | `(d[8] >> 5) & 0x1` | 0,1 |
| 8 | bit 1 | Proxi_RFHM | b | `(d[8] >> 1) & 0x1` | all |
| 9 | bit 4 | Proxi_AHLM | b | `(d[9] >> 4) & 0x1` | 0,1 |
| 9 | bit 6 | Proxi_OCM | b | `(d[9] >> 6) & 0x1` | all |

## 0x3E8  ·  bytes 0-8 used  ·  PPS: vehcfg, vehcfg0

| bytes | bits | signal | type | decode | tables |
|---|---|---|---|---|---|
| 0 | bit 6 | VC_HdRstPrsnt | b | `(d[0] >> 6) & 0x1` | 1,2,3,4,5,7,8 |
| 0 | bits 2-7 | VC_MODEL_YEAR | b | `(d[0] >> 2) & 0x3F` | 0,6 |
| 0 | bits 0-5 | VC_MODEL_YEAR | b | `d[0] & 0x3F` | 1,2,3,4,5,7,8 |
| 0 | bit 7 | VC_PP_Prsnt | b | `(d[0] >> 7) & 0x1` | 1,2,3,4,5,7,8 |
| 0 | bits 0-1 | VC_VehCfg1_Stat | b | `d[0] & 0x3` | 0,6 |
| 1 | bits 0-7 | VC_VEH_LINE | b | `d[1] & 0xFF` | all |
| 2 | bits 0-4 | VC_COUNTRY | b | `d[2] & 0x1F` | all |
| 2 | bits 5-6 | VC_LHD_RHD | b | `(d[2] >> 5) & 0x3` | all |
| 2 | bit 7 | VC_RemStPrsnt | b | `(d[2] >> 7) & 0x1` | all |
| 3 | bit 3 | VC_AUTO_HB | b | `(d[3] >> 3) & 0x1` | all |
| 3 | bits 4-7 | VC_BODY_STYLE | b | `(d[3] >> 4) & 0xF` | all |
| 3 | bit 2 | VC_EmodePrsnt | b | `(d[3] >> 2) & 0x1` | all |
| 3 | bits 0-1 | VC_XWD | b | `d[3] & 0x3` | all |
| 4 | bits 0-7 | VC_SpecialPKG | b | `d[4] & 0xFF` | 1,2,3,4,5,7,8 |
| 5 | bit 0 | VC_CHMCM_Prsnt | b | `d[5] & 0x1` | 1,2,3,4,5,7,8 |
| 5 | bits 6-7 | VC_CmfrtFeatMethod | b | `(d[5] >> 6) & 0x3` | 1,2,3,4,5,7,8 |
| 5 | bit 4 | VC_HDC_Prsnt | b | `(d[5] >> 4) & 0x1` | 1,7,8 |
| 5 | bit 5 | VC_HDC_Prsnt | b | `(d[5] >> 5) & 0x1` | 2,3,4,5 |
| 5 | bit 7 | VC_PP_Prsnt | b | `(d[5] >> 7) & 0x1` | 0,6 |
| 5 | bits 2-3 | VC_PTS_Config | b | `(d[5] >> 2) & 0x3` | 1,2,3,4,5,7,8 |
| 5 | bit 1 | VC_RVCM_Prsnt | b | `(d[5] >> 1) & 0x1` | 1,2,3,4,5,7,8 |
| 5 | bit 5 | VC_SSC_Prsnt | b | `(d[5] >> 5) & 0x1` | 1,7,8 |
| 5 | bit 4 | VC_SSC_Prsnt | b | `(d[5] >> 4) & 0x1` | 2,3,4,5 |
| 6 | bits 0-7 | VC_SpecialPKG | b | `d[6] & 0xFF` | 0,6 |
| 7 | bit 5 | VC_CHMCM_Prsnt | b | `(d[7] >> 5) & 0x1` | 0,6 |
| 7 | bit 6 | VC_HDC_Prsnt | b | `(d[7] >> 6) & 0x1` | 0,6 |
| 7 | bit 0 | VC_HdRstPrsnt | b | `d[7] & 0x1` | 0,6 |
| 7 | bits 2-3 | VC_PTS_Config | b | `(d[7] >> 2) & 0x3` | 0,6 |
| 7 | bit 4 | VC_RVCM_Prsnt | b | `(d[7] >> 4) & 0x1` | 0,6 |
| 7 | bit 7 | VC_SSC_Prsnt | b | `(d[7] >> 7) & 0x1` | 0,6 |
| 8 | bits 0-1 | VC_CmfrtFeatMethod | b | `d[8] & 0x3` | 0,6 |

## 0x3E9  ·  bytes 0-8 used  ·  PPS: vehcfg, vehcfg0

| bytes | bits | signal | type | decode | tables |
|---|---|---|---|---|---|
| 0 | bit 4 | VC_ECO_MODE_PRESENCE | b | `(d[0] >> 4) & 0x1` | 1,2,3,4,5,7,8 |
| 0 | bits 2-3 | VC_PwrIvtrTyp | b | `(d[0] >> 2) & 0x3` | all |
| 0 | bit 1 | VC_RainSnsPrsnt | b | `(d[0] >> 1) & 0x1` | 1,2,3,4,5,7,8 |
| 0 | bits 0-1 | VC_VehCfg2_Stat | b | `d[0] & 0x3` | 0,6 |
| 1 | bits 0-7 | VC_MaxLdPressRrTr | b | `d[1] & 0xFF` | 1,2,3,4,5,7,8 |
| 1 | bit 1 | VC_RainSnsPrsnt | b | `(d[1] >> 1) & 0x1` | 0,6 |
| 2 | bits 0-7 | VC_MaxLdPressFtTr | b | `d[2] & 0xFF` | 1,2,3,4,5,7,8 |
| 2 | bits 0-7 | VC_SpecialPKG_IC | b | `d[2] & 0xFF` | 0,6 |
| 3 | bit 1 | VC_DRVMD_Prsnt | b | `(d[3] >> 1) & 0x1` | 0,6 |
| 3 | bit 0 | VC_ECO_Indicator | b | `d[3] & 0x1` | 0,6 |
| 3 | bit 3 | VC_ESCDrvMd_Prsnt | b | `(d[3] >> 3) & 0x1` | 0,6 |
| 3 | bit 4 | VC_EngPowerDrvMd_Prsnt | b | `(d[3] >> 4) & 0x1` | 0,6 |
| 3 | bits 0-7 | VC_LgtLdPressRrTr | b | `d[3] & 0xFF` | 1,2,3,4,5,7,8 |
| 3 | bit 2 | VC_MemoryDRVMD_Prsnt | b | `(d[3] >> 2) & 0x1` | 0,6 |
| 3 | bit 5 | VC_SecPrkPrsnt | b | `(d[3] >> 5) & 0x1` | 0,6 |
| 3 | bits 6-7 | VC_ShftInd_Prsnt | b | `(d[3] >> 6) & 0x3` | 0,6 |
| 4 | bits 0-7 | VC_LgtldPressFtTr | b | `d[4] & 0xFF` | 1,2,3,4,5,7,8 |
| 4 | bits 0-7 | VC_MaxLdPressRrTr | b | `d[4] & 0xFF` | 0,6 |
| 5 | bit 1 | VC_DRVMD_Prsnt | b | `(d[5] >> 1) & 0x1` | 1,2,3,4,5,7,8 |
| 5 | bit 0 | VC_ECO_Indicator | b | `d[5] & 0x1` | 1,2,3,4,5,7,8 |
| 5 | bit 3 | VC_ESCDrvMd_Prsnt | b | `(d[5] >> 3) & 0x1` | 1,2,3,4,5,7,8 |
| 5 | bit 4 | VC_EngPowerDrvMd_Prsnt | b | `(d[5] >> 4) & 0x1` | 1,2,3,4,5,7,8 |
| 5 | bits 0-7 | VC_MaxLdPressFtTr | b | `d[5] & 0xFF` | 0,6 |
| 5 | bit 2 | VC_MemoryDRVMD_Prsnt | b | `(d[5] >> 2) & 0x1` | 1,2,3,4,5,7,8 |
| 5 | bit 5 | VC_SecPrkPrsnt | b | `(d[5] >> 5) & 0x1` | 1,2,3,4,5,7,8 |
| 5 | bits 6-7 | VC_ShftInd_Prsnt | b | `(d[5] >> 6) & 0x3` | 1,2,3,4,5,7,8 |
| 6 | bits 0-7 | VC_LgtLdPressRrTr | b | `d[6] & 0xFF` | 0,6 |
| 7 | bits 0-7 | VC_LgtldPressFtTr | b | `d[7] & 0xFF` | 0,6 |
| 8 | bit 0 | VC_ECO_MODE_PRESENCE | b | `d[8] & 0x1` | 0,6 |

## 0x3EA  ·  bytes 0-9 used  ·  PPS: vehcfg, vehcfg0

| bytes | bits | signal | type | decode | tables |
|---|---|---|---|---|---|
| 0 | bits 2-3 | VC_HALF_Sensitivity | b | `(d[0] >> 2) & 0x3` | 1,2,3,4,5,7,8 |
| 0 | bits 4-5 | VC_HALF_Torque | b | `(d[0] >> 4) & 0x3` | 1,2,3,4,5,7,8 |
| 0 | bit 2 | VC_POLICE | b | `(d[0] >> 2) & 0x1` | 6 |
| 0 | bit 6 | VC_RKE_PRSNT | b | `(d[0] >> 6) & 0x1` | all |
| 0 | bit 7 | VC_SunShade_Present | b | `(d[0] >> 7) & 0x1` | all |
| 0 | bits 0-1 | VC_VehCfg3_Stat | b | `d[0] & 0x3` | all |
| 1 | bit 0 | CUSW | b | `d[1] & 0x1` | 1,2,4,8 |
| 1 | bits 1-2 | DEFROST_MODE | b | `(d[1] >> 1) & 0x3` | 1,7 |
| 1 | bit 0 | VC_SPORT_PRSNT | b | `d[1] & 0x1` | 7 |
| 1 | bits 0-3 | VC_TcaseTyp | b | `d[1] & 0xF` | 0,6 |
| 2 | bits 0-7 | VC_FUEL_CAP | b | `d[2] & 0xFF` | all |
| 3 | bit 3 | VC_AUTO_HL | b | `(d[3] >> 3) & 0x1` | all |
| 3 | bit 7 | VC_DSBL_CLK_DISP | b | `(d[3] >> 7) & 0x1` | all |
| 3 | bit 4 | VC_DrAlrPrsnt | b | `(d[3] >> 4) & 0x1` | all |
| 3 | bit 6 | VC_SRT_PRSNT | b | `(d[3] >> 6) & 0x1` | all |
| 4 | bit 7 | VC_TEMP_DISP | b | `(d[4] >> 7) & 0x1` | all |
| 5 | bits 0-3 | VC_HVAC_Config | b | `d[5] & 0xF` | all |
| 5 | bits 4-7 | VC_VEH_BRAND | b | `(d[5] >> 4) & 0xF` | all |
| 6 | bit 0 | VC_CMP_DISP | b | `d[6] & 0x1` | all |
| 6 | bit 7 | VC_CMS | b | `(d[6] >> 7) & 0x1` | all |
| 6 | bit 6 | VC_Hold_N_Go | b | `(d[6] >> 6) & 0x1` | 1,2,3,4,5,7,8 |
| 6 | bit 1 | VC_IntEC_MIRR | b | `(d[6] >> 1) & 0x1` | all |
| 7 | bit 0 | VC_FCW | b | `d[7] & 0x1` | all |
| 7 | bit 6 | VC_PE_Prsnt | b | `(d[7] >> 6) & 0x1` | 0,6 |
| 7 | bit 7 | VC_PE_Prsnt | b | `(d[7] >> 7) & 0x1` | 1,2,3,4,5,7,8 |
| 7 | bit 4 | VC_SPORT_PRSNT | b | `(d[7] >> 4) & 0x1` | 0,6 |
| 8 | bits 0-3 | VC_Audio_Lay_Out | b | `d[8] & 0xF` | all |
| 8 | bit 6 | VC_AutoCloseMenu | b | `(d[8] >> 6) & 0x1` | all |
| 8 | bit 4 | VC_HeadlampOffDelay | b | `(d[8] >> 4) & 0x1` | all |
| 8 | bit 5 | VC_HornChirpMenu | b | `(d[8] >> 5) & 0x1` | all |
| 9 | mask 0x05<<4 | DEFROST_MODE | b | `(d[9] >> 4) & 0x5` | 0 |
| 9 | bit 5 | ParkWithStop | b | `(d[9] >> 5) & 0x1` | 0,6 |
| 9 | bit 6 | RearHeatedWindow | b | `(d[9] >> 6) & 0x1` | 6 |
| 9 | bits 0-1 | VC_HALF_Sensitivity | b | `d[9] & 0x3` | 0,6 |
| 9 | bits 2-3 | VC_HALF_Torque | b | `(d[9] >> 2) & 0x3` | 0,6 |
| 9 | bit 7 | VC_Hold_N_Go | b | `(d[9] >> 7) & 0x1` | 0,6 |

## 0x3EB  ·  bytes 0-2 used  ·  PPS: vehcfg, vehcfg0

| bytes | bits | signal | type | decode | tables |
|---|---|---|---|---|---|
| 0-1 | 16-bit | VC_TIRE_CIRCUMF | y | `d[1]<<8 \| d[0]` | 1,2,3,4,5,7,8 |
| 0 | bits 0-1 | VC_VehCfg4_Stat | b | `d[0] & 0x3` | 0,6 |
| 1-2 | 16-bit | VC_TIRE_CIRCUMF | y | `d[2]<<8 \| d[1]` | 0,6 |

## 0x3F2  ·  bytes 0-7 used  ·  PPS: vehcfg, vehcfg0

| bytes | bits | signal | type | decode | tables |
|---|---|---|---|---|---|
| 0 | bit 3 | DRL_Prsnt | b | `(d[0] >> 3) & 0x1` | all |
| 0 | bits 0-1 | EC_ECUCfg3_Stat | b | `d[0] & 0x3` | all |
| 0 | bit 5 | FT_PTS_Prsnt | b | `(d[0] >> 5) & 0x1` | all |
| 0 | bit 6 | HS_PRSNT | b | `(d[0] >> 6) & 0x1` | all |
| 0 | bit 4 | PWR_INV_PRSNT | b | `(d[0] >> 4) & 0x1` | all |
| 0 | bit 2 | RrCameraPrsnt | b | `(d[0] >> 2) & 0x1` | all |
| 0 | bit 7 | VENT_ST_PRSNT | b | `(d[0] >> 7) & 0x1` | all |
| 1 | bits 0-7 | DEST | b | `d[1] & 0xFF` | all |
| 2 | bits 0-7 | CABIN_EQ | b | `d[2] & 0xFF` | all |
| 3 | bit 3 | APPS_PRSNT | b | `(d[3] >> 3) & 0x1` | all |
| 3 | bit 6 | DAB_PRSNT | b | `(d[3] >> 6) & 0x1` | all |
| 3 | bit 5 | SDAR_TRL_LNK_PRSNT | b | `(d[3] >> 5) & 0x1` | all |
| 3 | bits 0-2 | VC_EXT_PORT_TYPE | b | `d[3] & 0x7` | all |
| 3 | bit 7 | VTA_PRSNT | b | `(d[3] >> 7) & 0x1` | all |
| 3 | bit 4 | WiFi_Cfg | b | `(d[3] >> 4) & 0x1` | 0,3,5 |
| 4 | bits 4-5 | ANT_TYP | b | `(d[4] >> 4) & 0x3` | all |
| 4 | bit 0 | HSW_PRSNT | b | `d[4] & 0x1` | all |
| 4 | bit 7 | HYBRID_PT | b | `(d[4] >> 7) & 0x1` | all |
| 4 | bit 1 | OD_SW_PRSNT | b | `(d[4] >> 1) & 0x1` | 8 |
| 4 | bit 3 | PWR_DR_LK_PRSNT | b | `(d[4] >> 3) & 0x1` | all |
| 4 | bit 2 | SURR_PRSNT | b | `(d[4] >> 2) & 0x1` | all |
| 4 | bit 1 | VIN_ChkDgt_Dsbl | b | `(d[4] >> 1) & 0x1` | 0,1,2,3,4,5,6,7 |
| 5 | bit 6 | ConnectedServicesPresent | b | `(d[5] >> 6) & 0x1` | 3,5 |
| 5 | bit 0 | DSBL_CD_EJECT | b | `d[5] & 0x1` | all |
| 5 | bit 1 | DTV_FRNTCAM_PRSNT | b | `(d[5] >> 1) & 0x1` | 0,5,6,7 |
| 5 | bit 2 | DTV_SIDECAM_PRSNT | b | `(d[5] >> 2) & 0x1` | 0,5,6,7 |
| 5 | bit 7 | DisplayOnOffSKPresent | b | `(d[5] >> 7) & 0x1` | all |
| 5 | bit 4 | HILL_DES_PRSNT | b | `(d[5] >> 4) & 0x1` | all |
| 5 | bit 3 | TOW_HAUL_PRSNT | b | `(d[5] >> 3) & 0x1` | all |
| 5 | bit 5 | VC_AUD_SWS_CF | b | `(d[5] >> 5) & 0x1` | all |
| 6 | bits 1-2 | Microphone_Type_PNET | b | `(d[6] >> 1) & 0x3` | all |
| 6 | bit 0 | NumberOfMics_PNET | b | `d[6] & 0x1` | all |
| 6 | bits 3-7 | Splashscreen_Type | b | `(d[6] >> 3) & 0x1F` | all |
| 7 | bit 4 | ECSB_PRSNT | b | `(d[7] >> 4) & 0x1` | 3,5 |
| 7 | bits 0-3 | MicTuningParam_PNET | b | `d[7] & 0xF` | all |
| 7 | bit 5 | NAV_Presence | b | `(d[7] >> 5) & 0x1` | 5 |

## 0x44A  ·  bytes 0-1 used  ·  PPS: vehcfg, vehcfg0

| bytes | bits | signal | type | decode | tables |
|---|---|---|---|---|---|
| 0 | bits 0-1 | VC_VehCfg5_Stat | b | `d[0] & 0x3` | all |
| 1 | bit 5 | VC_AmbLtgPrsnt | b | `(d[1] >> 5) & 0x1` | 0,6 |
| 1 | bit 6 | VC_AmbLtgPrsnt | b | `(d[1] >> 6) & 0x1` | 1,2,3,4,5,7,8 |
| 1 | bit 4 | VC_OffRoadPg | b | `(d[1] >> 4) & 0x1` | 0,6 |
| 1 | bit 5 | VC_OffRoadPg | b | `(d[1] >> 5) & 0x1` | 1,2,3,4,5,7,8 |
| 1 | bit 7 | VC_ParkStopPrsnt | b | `(d[1] >> 7) & 0x1` | all |

## 0x44C  ·  bytes 0-2 used  ·  PPS: vehcfg, vehcfg0

| bytes | bits | signal | type | decode | tables |
|---|---|---|---|---|---|
| 0-1 | 16-bit | VC_TireCircumfFT | y | `d[1]<<8 \| d[0]` | 1,2,3,4,5,7,8 |
| 0 | bits 0-1 | VC_VehCfg6_Stat | b | `d[0] & 0x3` | 0,6 |
| 1-2 | 16-bit | VC_TireCircumfFT | y | `d[2]<<8 \| d[1]` | 0,6 |

## 0x4B1  ·  bytes 0-2 used  ·  PPS: can_c

| bytes | bits | signal | type | decode | tables |
|---|---|---|---|---|---|
| 0 | bit 3 | BonnetSts | b | `(d[0] >> 3) & 0x1` | 3,5 |
| 0 | bit 7 | DriverDoorSts_C | b | `(d[0] >> 7) & 0x1` | 3,5 |
| 1 | bit 1 | LHRDoorSts | b | `(d[1] >> 1) & 0x1` | 3,5 |
| 1 | bit 0 | PsngrDoorSts | b | `d[1] & 0x1` | 3,5 |
| 1 | bit 2 | RHRDoorSts | b | `(d[1] >> 2) & 0x1` | 3,5 |
| 2 | bits 1-3 | TheftAlarmStatus | b | `(d[2] >> 1) & 0x7` | 3,5 |

## 0x52D  ·  bytes 0-1 used  ·  PPS: notification, vehstat

| bytes | bits | signal | type | decode | tables |
|---|---|---|---|---|---|
| 0 | bits 0-3 | HALF_CHIME_REP_RATE | b | `d[0] & 0xF` | 0,1,2,3,4,5,8 |
| 0 | bits 4-7 | HALF_CHIME_TYPE | b | `(d[0] >> 4) & 0xF` | 0,1,2,3,4,5,8 |
| 1 | bit 4 | AHBFault | b | `(d[1] >> 4) & 0x1` | 5 |
| 1 | bits 2-3 | EngineSts | b | `(d[1] >> 2) & 0x3` | all |
| 1 | bit 0 | HALF_LF_CHIME_RQ | b | `d[1] & 0x1` | 0,1,2,3,4,5,8 |
| 1 | bit 1 | HALF_RF_CHIME_RQ | b | `(d[1] >> 1) & 0x1` | 0,1,2,3,4,5,8 |

## 0x52E  ·  bytes 0-0 used  ·  PPS: personal

| bytes | bits | signal | type | decode | tables |
|---|---|---|---|---|---|
| 0 | bits 3-5 | ConfigSts | b | `(d[0] >> 3) & 0x7` | 0,1 |
| 0 | bits 0-2 | TorqueIntensitySts | b | `d[0] & 0x7` | 0,1 |

## 0x550  ·  bytes 0-2 used  ·  PPS: audiostat, personal, vehstat

| bytes | bits | signal | type | decode | tables |
|---|---|---|---|---|---|
| 0 | bits 1-2 | AutoParkSts | b | `(d[0] >> 1) & 0x3` | 0,1,2,3,4,5,7,8 |
| 0 | bit 6 | ServiceModeSts | b | `(d[0] >> 6) & 0x1` | 0,1,2,3,4,5,7,8 |
| 2 | bits 0-2 | EPBChimeReq | b | `d[2] & 0x7` | all |
| 2 | bits 3-7 | TextDisplay | b | `(d[2] >> 3) & 0x1F` | all |

## 0x600  ·  bytes 0-0 used  ·  PPS: roe

| bytes | bits | signal | type | decode | tables |
|---|---|---|---|---|---|
| 0 | ? (raw shift=8 mask=0xFF) | SD_RS_RF_HUB | j | `type j: raw byte 0` | all |

## 0x601  ·  bytes 0-0 used  ·  PPS: roe

| bytes | bits | signal | type | decode | tables |
|---|---|---|---|---|---|
| 0 | ? (raw shift=8 mask=0xFF) | SD_RS_CBC | j | `type j: raw byte 0` | all |

## 0x602  ·  bytes 0-0 used  ·  PPS: roe

| bytes | bits | signal | type | decode | tables |
|---|---|---|---|---|---|
| 0 | ? (raw shift=8 mask=0xFF) | SD_RS_IC | j | `type j: raw byte 0` | all |

## 0x603  ·  bytes 0-0 used  ·  PPS: roe

| bytes | bits | signal | type | decode | tables |
|---|---|---|---|---|---|
| 0 | ? (raw shift=8 mask=0xFF) | SD_RS_TPM | j | `type j: raw byte 0` | all |

## 0x604  ·  bytes 0-0 used  ·  PPS: roe

| bytes | bits | signal | type | decode | tables |
|---|---|---|---|---|---|
| 0 | ? (raw shift=8 mask=0xFF) | SD_RS_ORC | j | `type j: raw byte 0` | all |

## 0x605  ·  bytes 0-0 used  ·  PPS: roe

| bytes | bits | signal | type | decode | tables |
|---|---|---|---|---|---|
| 0 | ? (raw shift=8 mask=0xFF) | SD_RS_RBT_DR | j | `type j: raw byte 0` | all |

## 0x606  ·  bytes 0-0 used  ·  PPS: roe

| bytes | bits | signal | type | decode | tables |
|---|---|---|---|---|---|
| 0 | ? (raw shift=8 mask=0xFF) | SD_RS_RBT_PASS | j | `type j: raw byte 0` | all |

## 0x607  ·  bytes 0-0 used  ·  PPS: roe

| bytes | bits | signal | type | decode | tables |
|---|---|---|---|---|---|
| 0 | ? (raw shift=8 mask=0xFF) | SD_RS_ESC | j | `type j: raw byte 0` | all |

## 0x609  ·  bytes 0-0 used  ·  PPS: roe

| bytes | bits | signal | type | decode | tables |
|---|---|---|---|---|---|
| 0 | ? (raw shift=8 mask=0xFF) | SD_RS_ESM | j | `type j: raw byte 0` | all |

## 0x60B  ·  bytes 0-0 used  ·  PPS: roe

| bytes | bits | signal | type | decode | tables |
|---|---|---|---|---|---|
| 0 | ? (raw shift=8 mask=0xFF) | SD_RS_DTCM | j | `type j: raw byte 0` | all |

## 0x60C  ·  bytes 0-0 used  ·  PPS: roe

| bytes | bits | signal | type | decode | tables |
|---|---|---|---|---|---|
| 0 | ? (raw shift=8 mask=0xFF) | SD_RS_FDCM | j | `type j: raw byte 0` | all |

## 0x613  ·  bytes 0-0 used  ·  PPS: roe

| bytes | bits | signal | type | decode | tables |
|---|---|---|---|---|---|
| 0 | ? (raw shift=8 mask=0xFF) | SD_RS_DASM | j | `type j: raw byte 0` | all |

## 0x614  ·  bytes 0-0 used  ·  PPS: roe

| bytes | bits | signal | type | decode | tables |
|---|---|---|---|---|---|
| 0 | ? (raw shift=8 mask=0xFF) | SD_RS_ITBM | j | `type j: raw byte 0` | all |

## 0x617  ·  bytes 0-0 used  ·  PPS: roe

| bytes | bits | signal | type | decode | tables |
|---|---|---|---|---|---|
| 0 | ? (raw shift=8 mask=0xFF) | SD_RS_ADCM | j | `type j: raw byte 0` | all |

## 0x619  ·  bytes 0-0 used  ·  PPS: roe

| bytes | bits | signal | type | decode | tables |
|---|---|---|---|---|---|
| 0 | ? (raw shift=8 mask=0xFF) | SD_RS_EPB | j | `type j: raw byte 0` | all |

## 0x61A  ·  bytes 0-0 used  ·  PPS: roe

| bytes | bits | signal | type | decode | tables |
|---|---|---|---|---|---|
| 0 | ? (raw shift=8 mask=0xFF) | SD_RS_EPS | j | `type j: raw byte 0` | all |

## 0x61E  ·  bytes 0-0 used  ·  PPS: roe

| bytes | bits | signal | type | decode | tables |
|---|---|---|---|---|---|
| 0 | ? (raw shift=8 mask=0xFF) | SD_RS_OCM | j | `type j: raw byte 0` | all |

## 0x61F  ·  bytes 0-0 used  ·  PPS: roe

| bytes | bits | signal | type | decode | tables |
|---|---|---|---|---|---|
| 0 | ? (raw shift=8 mask=0xFF) | SD_RS_EPPM | j | `type j: raw byte 0` | all |

## 0x622  ·  bytes 0-0 used  ·  PPS: roe

| bytes | bits | signal | type | decode | tables |
|---|---|---|---|---|---|
| 0 | ? (raw shift=8 mask=0xFF) | SD_RS_PTS | j | `type j: raw byte 0` | all |

## 0x623  ·  bytes 0-0 used  ·  PPS: roe

| bytes | bits | signal | type | decode | tables |
|---|---|---|---|---|---|
| 0 | ? (raw shift=8 mask=0xFF) | SD_RS_SCCM | j | `type j: raw byte 0` | all |

## 0x624  ·  bytes 0-0 used  ·  PPS: roe

| bytes | bits | signal | type | decode | tables |
|---|---|---|---|---|---|
| 0 | ? (raw shift=8 mask=0xFF) | SD_RS_HaLF | j | `type j: raw byte 0` | all |

## 0x626  ·  bytes 0-0 used  ·  PPS: roe

| bytes | bits | signal | type | decode | tables |
|---|---|---|---|---|---|
| 0 | ? (raw shift=8 mask=0xFF) | SD_RS_ASCM | j | `type j: raw byte 0` | all |

## 0x628  ·  bytes 0-0 used  ·  PPS: roe

| bytes | bits | signal | type | decode | tables |
|---|---|---|---|---|---|
| 0 | ? (raw shift=8 mask=0xFF) | SD_RS_AFLS | j | `type j: raw byte 0` | all |

## 0x629  ·  bytes 0-0 used  ·  PPS: roe

| bytes | bits | signal | type | decode | tables |
|---|---|---|---|---|---|
| 0 | ? (raw shift=8 mask=0xFF) | SD_RS_AHLM | j | `type j: raw byte 0` | all |

## 0x630  ·  bytes 0-0 used  ·  PPS: roe

| bytes | bits | signal | type | decode | tables |
|---|---|---|---|---|---|
| 0 | ? (raw shift=8 mask=0xFF) | SD_RS_ELSD | j | `type j: raw byte 0` | all |

## 0x638  ·  bytes 0-0 used  ·  PPS: roe

| bytes | bits | signal | type | decode | tables |
|---|---|---|---|---|---|
| 0 | ? (raw shift=8 mask=0xFF) | SD_RS_ECM | j | `type j: raw byte 0` | all |

## 0x639  ·  bytes 0-0 used  ·  PPS: roe

| bytes | bits | signal | type | decode | tables |
|---|---|---|---|---|---|
| 0 | ? (raw shift=8 mask=0xFF) | SD_RS_TCM | j | `type j: raw byte 0` | all |

## 0x643  ·  bytes 0-0 used  ·  PPS: roe

| bytes | bits | signal | type | decode | tables |
|---|---|---|---|---|---|
| 0 | ? (raw shift=8 mask=0xFF) | SD_RS_HVAC | j | `type j: raw byte 0` | all |

## 0x644  ·  bytes 0-0 used  ·  PPS: roe

| bytes | bits | signal | type | decode | tables |
|---|---|---|---|---|---|
| 0 | ? (raw shift=8 mask=0xFF) | SD_RS_DCM_DR | j | `type j: raw byte 0` | all |

## 0x645  ·  bytes 0-0 used  ·  PPS: roe

| bytes | bits | signal | type | decode | tables |
|---|---|---|---|---|---|
| 0 | ? (raw shift=8 mask=0xFF) | SD_RS_DCM_PASS | j | `type j: raw byte 0` | all |

## 0x646  ·  bytes 0-0 used  ·  PPS: roe

| bytes | bits | signal | type | decode | tables |
|---|---|---|---|---|---|
| 0 | ? (raw shift=8 mask=0xFF) | SD_RS_DCM_RL | j | `type j: raw byte 0` | all |

## 0x647  ·  bytes 0-0 used  ·  PPS: roe

| bytes | bits | signal | type | decode | tables |
|---|---|---|---|---|---|
| 0 | ? (raw shift=8 mask=0xFF) | SD_RS_DCM_RR | j | `type j: raw byte 0` | all |

## 0x648  ·  bytes 0-0 used  ·  PPS: roe

| bytes | bits | signal | type | decode | tables |
|---|---|---|---|---|---|
| 0 | ? (raw shift=8 mask=0xFF) | SD_RS_PSD_LT | j | `type j: raw byte 0` | all |

## 0x649  ·  bytes 0-0 used  ·  PPS: roe

| bytes | bits | signal | type | decode | tables |
|---|---|---|---|---|---|
| 0 | ? (raw shift=8 mask=0xFF) | SD_RS_PSD_RT | j | `type j: raw byte 0` | all |

## 0x64A  ·  bytes 0-0 used  ·  PPS: roe

| bytes | bits | signal | type | decode | tables |
|---|---|---|---|---|---|
| 0 | ? (raw shift=8 mask=0xFF) | SD_RS_MSM | j | `type j: raw byte 0` | all |

## 0x64C  ·  bytes 0-0 used  ·  PPS: roe

| bytes | bits | signal | type | decode | tables |
|---|---|---|---|---|---|
| 0 | ? (raw shift=8 mask=0xFF) | SD_RS_PLG | j | `type j: raw byte 0` | all |

## 0x64D  ·  bytes 0-0 used  ·  PPS: roe

| bytes | bits | signal | type | decode | tables |
|---|---|---|---|---|---|
| 0 | ? (raw shift=8 mask=0xFF) | SD_RS_FSM | j | `type j: raw byte 0` | all |

## 0x64E  ·  bytes 0-0 used  ·  PPS: roe

| bytes | bits | signal | type | decode | tables |
|---|---|---|---|---|---|
| 0 | ? (raw shift=8 mask=0xFF) | SD_RS_VSIM | j | `type j: raw byte 0` | all |

## 0x64F  ·  bytes 0-0 used  ·  PPS: roe

| bytes | bits | signal | type | decode | tables |
|---|---|---|---|---|---|
| 0 | ? (raw shift=8 mask=0xFF) | SD_RS_ITM | j | `type j: raw byte 0` | all |

## 0x650  ·  bytes 0-0 used  ·  PPS: roe

| bytes | bits | signal | type | decode | tables |
|---|---|---|---|---|---|
| 0 | ? (raw shift=8 mask=0xFF) | SD_RS_AHBM | j | `type j: raw byte 0` | all |

## 0x651  ·  bytes 0-0 used  ·  PPS: roe

| bytes | bits | signal | type | decode | tables |
|---|---|---|---|---|---|
| 0 | ? (raw shift=8 mask=0xFF) | SD_RS_BSM | j | `type j: raw byte 0` | all |

## 0x652  ·  bytes 0-0 used  ·  PPS: roe

| bytes | bits | signal | type | decode | tables |
|---|---|---|---|---|---|
| 0 | ? (raw shift=8 mask=0xFF) | SD_RS_CSWM | j | `type j: raw byte 0` | all |

## 0x654  ·  bytes 0-0 used  ·  PPS: roe

| bytes | bits | signal | type | decode | tables |
|---|---|---|---|---|---|
| 0 | ? (raw shift=8 mask=0xFF) | SD_RS_CVPM | j | `type j: raw byte 0` | 6 |

## 0x655  ·  bytes 0-0 used  ·  PPS: roe

| bytes | bits | signal | type | decode | tables |
|---|---|---|---|---|---|
| 0 | ? (raw shift=8 mask=0xFF) | SD_RS_MSM_PASS | j | `type j: raw byte 0` | 6 |

## 0x656  ·  bytes 0-0 used  ·  PPS: roe

| bytes | bits | signal | type | decode | tables |
|---|---|---|---|---|---|
| 0 | ? (raw shift=8 mask=0xFF) | SD_RS_CRSM | j | `type j: raw byte 0` | all |

## 0x657  ·  bytes 0-0 used  ·  PPS: roe

| bytes | bits | signal | type | decode | tables |
|---|---|---|---|---|---|
| 0 | ? (raw shift=8 mask=0xFF) | SD_RS_CLOCK | j | `type j: raw byte 0` | all |

## 0x658  ·  bytes 0-0 used  ·  PPS: roe

| bytes | bits | signal | type | decode | tables |
|---|---|---|---|---|---|
| 0 | ? (raw shift=8 mask=0xFF) | SD_RS_HVAC_R | j | `type j: raw byte 0` | all |

## 0x659  ·  bytes 0-0 used  ·  PPS: roe

| bytes | bits | signal | type | decode | tables |
|---|---|---|---|---|---|
| 0 | ? (raw shift=8 mask=0xFF) | SD_RS_RBSS | j | `type j: raw byte 0` | all |

## 0x665  ·  bytes 0-0 used  ·  PPS: roe

| bytes | bits | signal | type | decode | tables |
|---|---|---|---|---|---|
| 0 | ? (raw shift=8 mask=0xFF) | SD_RS_ANC_I | j | `type j: raw byte 0` | 6 |

## 0x66C  ·  bytes 0-0 used  ·  PPS: roe

| bytes | bits | signal | type | decode | tables |
|---|---|---|---|---|---|
| 0 | ? (raw shift=8 mask=0xFF) | SD_RS_DCSD | j | `type j: raw byte 0` | 6 |

## 0x66D  ·  bytes 0-0 used  ·  PPS: roe

| bytes | bits | signal | type | decode | tables |
|---|---|---|---|---|---|
| 0 | ? (raw shift=8 mask=0xFF) | SD_RS_VRM | j | `type j: raw byte 0` | 6 |

## 0x66E  ·  bytes 0-0 used  ·  PPS: roe

| bytes | bits | signal | type | decode | tables |
|---|---|---|---|---|---|
| 0 | ? (raw shift=8 mask=0xFF) | SD_RS_ICS_R | j | `type j: raw byte 0` | 6 |

## 0x674  ·  bytes 0-0 used  ·  PPS: dtv

| bytes | bits | signal | type | decode | tables |
|---|---|---|---|---|---|
| 0 | ? (raw shift=8 mask=0xFF) | SD_RS_DTV | j | `type j: raw byte 0` | all |

## 0x676  ·  bytes 0-0 used  ·  PPS: roe

| bytes | bits | signal | type | decode | tables |
|---|---|---|---|---|---|
| 0 | ? (raw shift=8 mask=0xFF) | SD_RS_DVD | j | `type j: raw byte 0` | all |

## 0x677  ·  bytes 0-0 used  ·  PPS: roe

| bytes | bits | signal | type | decode | tables |
|---|---|---|---|---|---|
| 0 | ? (raw shift=8 mask=0xFF) | SD_RS_VES2 | j | `type j: raw byte 0` | all |

## 0x679  ·  bytes 0-0 used  ·  PPS: roe

| bytes | bits | signal | type | decode | tables |
|---|---|---|---|---|---|
| 0 | ? (raw shift=8 mask=0xFF) | SD_RS_HFM | j | `type j: raw byte 0` | all |

## 0x67A  ·  bytes 0-0 used  ·  PPS: roe

| bytes | bits | signal | type | decode | tables |
|---|---|---|---|---|---|
| 0 | ? (raw shift=8 mask=0xFF) | SD_RS_SDARV | j | `type j: raw byte 0` | all |

## 0x67B  ·  bytes 0-0 used  ·  PPS: roe

| bytes | bits | signal | type | decode | tables |
|---|---|---|---|---|---|
| 0 | ? (raw shift=8 mask=0xFF) | SD_RS_VES3 | j | `type j: raw byte 0` | all |

## 0x67C  ·  bytes 0-0 used  ·  PPS: roe

| bytes | bits | signal | type | decode | tables |
|---|---|---|---|---|---|
| 0 | ? (raw shift=8 mask=0xFF) | SD_RS_ICS | j | `type j: raw byte 0` | all |

## 0x67E  ·  bytes 0-0 used  ·  PPS: roe

| bytes | bits | signal | type | decode | tables |
|---|---|---|---|---|---|
| 0 | ? (raw shift=8 mask=0xFF) | SD_RS_AMP | j | `type j: raw byte 0` | all |

## 0x67F  ·  bytes 0-0 used  ·  PPS: roe

| bytes | bits | signal | type | decode | tables |
|---|---|---|---|---|---|
| 0 | ? (raw shift=8 mask=0xFF) | SD_RS_TGW | j | `type j: raw byte 0` | 6 |

## 0x9AB  ·  bytes 0-0 used  ·  PPS: vehstat

| bytes | bits | signal | type | decode | tables |
|---|---|---|---|---|---|
| 0 | bits 0-7 | resumeModeTimeout | b | `d[0] & 0xFF` | 0,1,5,6,7 |

## 0xAAA  ·  bytes 0-0 used  ·  PPS: vehcfg, vehcfg0

| bytes | bits | signal | type | decode | tables |
|---|---|---|---|---|---|
| 0 | bits 0-3 | PROXI | b | `d[0] & 0xF` | all |

## 0x1000  ·  bytes 0-9 used  ·  PPS: compact

| bytes | bits | signal | type | decode | tables |
|---|---|---|---|---|---|
| 0 | bits 0-3 | IstantaneusFuelConsumption1 | b | `d[0] & 0xF` | all |
| 0 | bits 4-7 | IstantaneusFuelConsumption2 | b | `(d[0] >> 4) & 0xF` | all |
| 1 | bits 0-3 | IstantaneusFuelConsumption3 | b | `d[1] & 0xF` | all |
| 2 | bit 7 | AutonomyDistanceValidData | b | `(d[2] >> 7) & 0x1` | all |
| 2 | bit 3 | IstantFuelConsumptionValidData | b | `(d[2] >> 3) & 0x1` | all |
| 3-4 | 16-bit | AutonomyDistance | y | `d[4]<<8 \| d[3]` | all |
| 5-9 | 40-bit | TotalOdometer | y | `d[9]<<32 \| d[8]<<24 \| d[7]<<16 \| d[6]<<8 \| d[5]` | all |

## 0x1001  ·  bytes 0-9 used  ·  PPS: compact

| bytes | bits | signal | type | decode | tables |
|---|---|---|---|---|---|
| 0-1 | 16-bit | AverageFuelConsumptionAPlus | y | `d[1]<<8 \| d[0]` | all |
| 1 | bit 7 | AverageFuelConsumptionAPlusValidData | b | `(d[1] >> 7) & 0x1` | all |
| 2 | bits 0-7 | AverageSpeedAPlus | b | `d[2] & 0xFF` | all |
| 3 | bit 7 | AverageSpeedAPlusValidData | b | `(d[3] >> 7) & 0x1` | all |
| 4-5 | 16-bit | TravelingTimeAPlus_Hour | y | `d[5]<<8 \| d[4]` | all |
| 5 | bits 2-7 | TravellingTimeAPlus_Minute | b | `(d[5] >> 2) & 0x3F` | all |
| 6 | bits 6-7 | ResetTripAPlusACK | b | `(d[6] >> 6) & 0x3` | all |
| 6 | bits 0-5 | TravelTimeAPlus_SEC | b | `d[6] & 0x3F` | all |
| 7-9 | 24-bit | PartialOdometerAPlus | y | `d[9]<<16 \| d[8]<<8 \| d[7]` | all |
| 9 | bit 7 | PartialOdometerAPlusValidData | b | `(d[9] >> 7) & 0x1` | all |

## 0x1002  ·  bytes 0-9 used  ·  PPS: compact

| bytes | bits | signal | type | decode | tables |
|---|---|---|---|---|---|
| 0-1 | 16-bit | AverageFuelConsumptionBPlus | y | `d[1]<<8 \| d[0]` | all |
| 1 | bit 7 | AverageFuelConsumptionBPlusValidData | b | `(d[1] >> 7) & 0x1` | all |
| 2 | bits 0-7 | AverageSpeedBPlus | b | `d[2] & 0xFF` | all |
| 3 | bit 7 | AverageSpeedBPlusValidData | b | `(d[3] >> 7) & 0x1` | all |
| 4-5 | 16-bit | TravelingTimeBPlus_Hour | y | `d[5]<<8 \| d[4]` | all |
| 5 | bits 2-7 | TravellingTimeBPlus_Minute | b | `(d[5] >> 2) & 0x3F` | all |
| 6 | bits 6-7 | ResetTripBPlusACK | b | `(d[6] >> 6) & 0x3` | all |
| 6 | bits 0-5 | TravelTimeBPlus_SEC | b | `d[6] & 0x3F` | all |
| 7-9 | 24-bit | PartialOdometerBPlus | y | `d[9]<<16 \| d[8]<<8 \| d[7]` | all |
| 9 | bit 7 | PartialOdometerBPlusValidData | b | `(d[9] >> 7) & 0x1` | all |

## 0x1003  ·  bytes 0-8 used  ·  PPS: compact, vehstat

| bytes | bits | signal | type | decode | tables |
|---|---|---|---|---|---|
| 0-1 | 16-bit | LatAcceleration | y | `d[1]<<8 \| d[0]` | all |
| 2-3 | 16-bit | LongAcceleration | y | `d[3]<<8 \| d[2]` | all |
| 4-5 | 16-bit | YawRate | y | `d[5]<<8 \| d[4]` | all |
| 6 | bits 0-1 | AXSStat | b | `d[6] & 0x3` | all |
| 6 | bits 2-3 | AYSStat | b | `(d[6] >> 2) & 0x3` | all |
| 6 | bits 4-5 | YRSStat | b | `(d[6] >> 4) & 0x3` | all |
| 7 | bits 0-7 | GasPedalPosition | b | `d[7] & 0xFF` | all |
| 8 | bit 1 | BrakePedalSwitchNOSts | b | `(d[8] >> 1) & 0x1` | all |
| 8 | bit 6 | FuelLvlLow | b | `(d[8] >> 6) & 0x1` | 5 |
| 8 | bit 0 | GasPedalPositionValidData | b | `d[8] & 0x1` | all |
| 8 | bits 2-5 | OperationalModeSts | b | `(d[8] >> 2) & 0xF` | 5 |

## 0x1004  ·  bytes 0-5 used  ·  PPS: compact

| bytes | bits | signal | type | decode | tables |
|---|---|---|---|---|---|
| 0-2 | 24-bit | DistanceToService | y | `d[2]<<16 \| d[1]<<8 \| d[0]` | all |
| 2 | bit 7 | DistanceToServiceValidData | b | `(d[2] >> 7) & 0x1` | 0,1,2,4,6,7,8 |
| 2 | bit 1 | DistanceToServiceValidData | b | `(d[2] >> 1) & 0x1` | 3,5 |
| 2 | bit 2 | TyrePressureSystemFailSts | b | `(d[2] >> 2) & 0x1` | 3,5 |
| 4 | bits 0-2 | InflationState_LHF_Tyre | b | `d[4] & 0x7` | 3,5 |
| 4 | bits 3-5 | InflationState_LHR_Tyre | b | `(d[4] >> 3) & 0x7` | 3,5 |
| 5 | bits 0-2 | InflationState_RHF_Tyre | b | `d[5] & 0x7` | 3,5 |
| 5 | bits 3-5 | InflationState_RHR_Tyre | b | `(d[5] >> 3) & 0x7` | 3,5 |

## 0x1006  ·  bytes 0-7 used  ·  PPS: compact

| bytes | bits | signal | type | decode | tables |
|---|---|---|---|---|---|
| 0 | bits 0-7 | BoostPressureIndication | b | `d[0] & 0xFF` | all |
| 1 | bits 2-6 | DriveStyleSts | b | `(d[1] >> 2) & 0x1F` | 3,5 |
| 1 | bits 0-1 | GearShiftIndiciation | b | `d[1] & 0x3` | all |
| 2 | bits 0-3 | ActualGearForDisplay | b | `d[2] & 0xF` | all |
| 2 | bits 4-6 | ShiftLeverPosition | b | `(d[2] >> 4) & 0x7` | 0,1,2,4,6,7,8 |
| 2 | bit 7 | ShiftModeSts | b | `(d[2] >> 7) & 0x1` | all |
| 3 | mask 0xEF<<0 | AlternativeFuelFillingTank | b | `d[3] & 0xEF` | all |
| 3 | bit 7 | ExternalTemperatureFailSts | b | `(d[3] >> 7) & 0x1` | all |
| 4-5 | 16-bit | ExternalTemperatureC | y | `d[5]<<8 \| d[4]` | all |
| 6-7 | 16-bit | ExternalTemperatureF | y | `d[7]<<8 \| d[6]` | all |

## 0x1007  ·  bytes 0-7 used  ·  PPS: compact

| bytes | bits | signal | type | decode | tables |
|---|---|---|---|---|---|
| 0 | bit 4 | DPFSts | b | `(d[0] >> 4) & 0x1` | all |
| 0 | bit 2 | EngineSpeedValidData | b | `(d[0] >> 2) & 0x1` | all |
| 0 | bits 5-6 | EngineSts | b | `(d[0] >> 5) & 0x3` | all |
| 0 | bit 1 | EngineWaterTempFailSts | b | `(d[0] >> 1) & 0x1` | all |
| 0 | bit 3 | FuelConsumptionValidData | b | `(d[0] >> 3) & 0x1` | all |
| 0 | bit 0 | GPLGasolineMode | b | `d[0] & 0x1` | all |
| 1 | bits 0-1 | CompressorSts | b | `d[1] & 0x3` | all |
| 1 | bits 2-3 | OilLifeSts | b | `(d[1] >> 2) & 0x3` | all |
| 1 | bit 4 | VehicleSpeedVSOSigFailSts | b | `(d[1] >> 4) & 0x1` | all |
| 2 | bits 0-7 | EngineWaterTemp | b | `d[2] & 0xFF` | all |
| 3 | bits 0-7 | EngineSpeed | b | `d[3] & 0xFF` | 0,1,2,4,6,7,8 |
| 4-5 | 16-bit | FuelConsumption | y | `d[5]<<8 \| d[4]` | all |
| 6-7 | 16-bit | VehicleSpeedVSOSig | y | `d[7]<<8 \| d[6]` | all |

## 0x100A  ·  bytes 0-7 used  ·  PPS: compact, personal, vehctl

| bytes | bits | signal | type | decode | tables |
|---|---|---|---|---|---|
| 0 | bits 0-2 | ConsumptionUnit | b | `d[0] & 0x7` | 1,2,3,4,5,7,8 |
| 0 | bit 5 | CorneringEnable | b | `(d[0] >> 5) & 0x1` | 1,2,3,4,5,7,8 |
| 0 | bit 6 | DistanceUnit | b | `(d[0] >> 6) & 0x1` | 2,3,4,5,8 |
| 0 | bits 3-4 | ETMSetupAckCntrl | b | `(d[0] >> 3) & 0x3` | 1,2,3,4,5,7,8 |
| 0 | bit 7 | SpeedLockDoorEnable | b | `(d[0] >> 7) & 0x1` | 1,2,3,4,5,7,8 |
| 1 | bit 5 | EPB_MaintenanceMode | b | `(d[1] >> 5) & 0x1` | 1,2,3,4,5,7,8 |
| 1 | bits 3-4 | ExternalLightSensorLevel | b | `(d[1] >> 3) & 0x3` | 1,2,3,4,5,7,8 |
| 1 | bits 6-7 | HeadlightsOffDelay | b | `(d[1] >> 6) & 0x3` | 1,2,3,4,5,7,8 |
| 1 | bits 0-1 | RainSensorLevel | b | `d[1] & 0x3` | 1,2,3,4,5,7,8 |
| 1 | bit 2 | TemperatureUnit | b | `(d[1] >> 2) & 0x1` | 1,2,3,4,5,7,8 |
| 2 | bit 0 | AFSEnable | b | `d[2] & 0x1` | 1,2,3,4,5,7,8 |
| 2 | bits 4-5 | AutomaticResetTripB | b | `(d[2] >> 4) & 0x3` | 1,2,3,4,5,7,8 |
| 2 | bits 6-7 | BSDEnable | b | `(d[2] >> 6) & 0x3` | 1,2,3,4,5,7,8 |
| 2 | bit 1 | GreetingLightsEnable | b | `(d[2] >> 1) & 0x1` | 1,2,3,4,5,7,8 |
| 3 | bit 0 | NavRepetition | b | `d[3] & 0x1` | 1,2,3,4,5,7,8 |
| 3 | bits 1-2 | Pam4Ch | b | `(d[3] >> 1) & 0x3` | 1,2,3,4,5,7,8 |
| 3 | bits 3-4 | Pam8ChChimeVolume | b | `(d[3] >> 3) & 0x3` | 1,2,3,4,5,7,8 |
| 3 | bits 5-6 | PamAlertMode | b | `(d[3] >> 5) & 0x3` | 1,2,3,4,5,7,8 |
| 3 | bit 7 | PhoneRepetition | b | `(d[3] >> 7) & 0x1` | 1,2,3,4,5,7,8 |
| 4 | bit 5 | AutoParkBrake | b | `(d[4] >> 5) & 0x1` | 1,2,3,4,5,7,8 |
| 4 | bit 6 | AutoRelock | b | `(d[4] >> 6) & 0x1` | 1,2,3,4,5,7,8 |
| 4 | bit 7 | AutoUnlockDoorExit | b | `(d[4] >> 7) & 0x1` | 1,2,3,4,5,7,8 |
| 4 | bit 4 | RemoteDoorUnlock | b | `(d[4] >> 4) & 0x1` | 1,2,3,4,5,7,8 |
| 4 | bits 0-1 | Sdw | b | `d[4] & 0x3` | 1,2,3,4,5,7,8 |
| 4 | bits 2-3 | SdwChimeVolume | b | `(d[4] >> 2) & 0x3` | 1,2,3,4,5,7,8 |
| 5 | bit 0 | FlashLightWLock | b | `d[5] & 0x1` | 1,2,3,4,5,7,8 |
| 5 | bits 1-2 | LDW_Intensity | b | `(d[5] >> 1) & 0x3` | 1,2,3,4,5,7,8 |
| 5 | bits 3-4 | LDW_Sensibility | b | `(d[5] >> 3) & 0x3` | 1,2,3,4,5,7,8 |
| 5 | bit 7 | Trip_B_Enable | b | `(d[5] >> 7) & 0x1` | 1,2,3,4,5,7,8 |
| 5 | bits 5-6 | TyrePressureUnit | b | `(d[5] >> 5) & 0x3` | 1,2,3,4,5,7,8 |
| 6 | bit 0 | AutoHighBeamEnable | b | `d[6] & 0x1` | 3,5 |
| 6 | bits 1-5 | EPB_Maintenance_Fdbk | b | `(d[6] >> 1) & 0x1F` | 3,5 |
| 6 | bits 6-7 | FSFCWPlusActivationMode | b | `(d[6] >> 6) & 0x3` | 3,5 |
| 7 | bits 0-2 | FSFCWPlusSetting | b | `d[7] & 0x7` | 3,5 |
| 7 | bit 7 | RKEMemoryLinkEnable | b | `(d[7] >> 7) & 0x1` | 5 |
| 7 | bits 5-6 | RemStNrmlStEnbl | b | `(d[7] >> 5) & 0x3` | 5 |
| 7 | bits 3-4 | Units | b | `(d[7] >> 3) & 0x3` | 3,5 |

## 0x100B  ·  bytes 0-6 used  ·  PPS: compact

| bytes | bits | signal | type | decode | tables |
|---|---|---|---|---|---|
| 0 | bits 0-3 | Day1 | b | `d[0] & 0xF` | all |
| 0 | bits 4-7 | Day2 | b | `(d[0] >> 4) & 0xF` | all |
| 1 | bits 0-3 | Hour1 | b | `d[1] & 0xF` | all |
| 1 | bits 4-7 | Hour2 | b | `(d[1] >> 4) & 0xF` | all |
| 2 | bits 0-3 | Minute1 | b | `d[2] & 0xF` | all |
| 2 | bits 4-7 | Minute2 | b | `(d[2] >> 4) & 0xF` | all |
| 3 | bits 0-3 | Month1 | b | `d[3] & 0xF` | all |
| 3 | bits 4-7 | Month2 | b | `(d[3] >> 4) & 0xF` | all |
| 4 | bits 0-3 | Year1 | b | `d[4] & 0xF` | all |
| 4 | bits 4-7 | Year2 | b | `(d[4] >> 4) & 0xF` | all |
| 5 | bits 0-3 | Year3 | b | `d[5] & 0xF` | all |
| 5 | bits 4-7 | Year4 | b | `(d[5] >> 4) & 0xF` | all |
| 6 | bit 0 | HourMode | b | `d[6] & 0x1` | all |

## 0x12A0  ·  bytes 0-3 used  ·  PPS: can_c

| bytes | bits | signal | type | decode | tables |
|---|---|---|---|---|---|
| 0 | bits 2-3 | ETC_IND_LMP | b | `(d[0] >> 2) & 0x3` | 0,6 |
| 0 | bit 0 | MIL_OnRq | b | `d[0] & 0x1` | 0,6 |
| 0 | bits 4-5 | MZR_MODE_ACT | b | `(d[0] >> 4) & 0x3` | 0 |
| 0 | bit 4 | MZR_MODE_ACT | b | `(d[0] >> 4) & 0x1` | 6 |
| 1 | bit 7 | ChkFuelCap | b | `(d[1] >> 7) & 0x1` | 0,6 |
| 1 | bit 2 | EngOilIndLmp_On_Rq | b | `(d[1] >> 2) & 0x1` | 0,6 |
| 1 | bits 5-6 | OIL_TEMP_CHM_RQ | b | `(d[1] >> 5) & 0x3` | 0,6 |
| 1 | bits 3-4 | OIL_TEMP_IND_RQ | b | `(d[1] >> 3) & 0x3` | 0,6 |
| 2 | bits 0-7 | OIL_PRESS | b | `d[2] & 0xFF` | 0,6 |
| 3 | bits 0-2 | EngRun_Stat | b | `d[3] & 0x7` | 6 |

## 0x12E0  ·  bytes 0-1 used  ·  PPS: can_c

| bytes | bits | signal | type | decode | tables |
|---|---|---|---|---|---|
| 0 | bit 6 | ESP_Off_IndLmp_On_Rq | b | `(d[0] >> 6) & 0x1` | 0,1,2,3,4,5,6,7 |
| 1 | bits 2-3 | ABS_IndLmp_On_Rq | b | `(d[1] >> 2) & 0x3` | 0,1,2,3,4,6,7 |
| 1 | bits 4-5 | BrkIndLmp_On_Rq_ESC | b | `(d[1] >> 4) & 0x3` | 0,1,2,3,4,6,7 |
| 1 | bits 0-1 | ESC_CtrlLmp_Info | b | `d[1] & 0x3` | 0,1,2,3,4,6,7 |
| 1 | bits 6-7 | SelSpdLmp | b | `(d[1] >> 6) & 0x3` | 6 |

## 0x1305  ·  bytes 0-6 used  ·  PPS: can_c

| bytes | bits | signal | type | decode | tables |
|---|---|---|---|---|---|
| 0 | bits 0-1 | TPM_IndLmpOnRq | b | `d[0] & 0x3` | 6,7 |
| 1 | bits 0-1 | Tire_FL | b | `d[1] & 0x3` | 6,7 |
| 1 | bits 2-3 | Tire_FR | b | `(d[1] >> 2) & 0x3` | 6,7 |
| 1 | bits 6-7 | Tire_RL | b | `(d[1] >> 6) & 0x3` | 6,7 |
| 1 | bits 4-5 | Tire_RR | b | `(d[1] >> 4) & 0x3` | 6,7 |
| 3 | bits 0-7 | TirePrssFL | b | `d[3] & 0xFF` | 6,7 |
| 4 | bits 0-7 | TirePrssFR | b | `d[4] & 0xFF` | 6,7 |
| 5 | bits 0-7 | TirePrssRL | b | `d[5] & 0xFF` | 6,7 |
| 6 | bits 0-7 | TirePrssRR | b | `d[6] & 0xFF` | 6,7 |

## 0x13CF  ·  bytes 0-7 used  ·  PPS: srt

| bytes | bits | signal | type | decode | tables |
|---|---|---|---|---|---|
| 1 | bits 0-7 | SRT_60mphTmB | b | `d[1] & 0xFF` | all |
| 2 | bits 0-7 | SRT_eighthTmB | b | `d[2] & 0xFF` | all |
| 3 | bits 0-7 | SRT_quarterTmB | b | `d[3] & 0xFF` | all |
| 4 | bits 0-7 | SRT_EthSpdB_M | b | `d[4] & 0xFF` | all |
| 5 | bits 0-7 | SRT_QrtSpdB_M | b | `d[5] & 0xFF` | all |
| 6 | bits 0-7 | SRT_BrkSpdB_M | b | `d[6] & 0xFF` | all |
| 7 | bits 0-7 | SRT_BrkDistB_M | b | `d[7] & 0xFF` | all |

## 0x20DE  ·  bytes 0-4 used  ·  PPS: vehstat

| bytes | bits | signal | type | decode | tables |
|---|---|---|---|---|---|
| 4 | bit 7 | EPS_Warn_Disp_Rq | b | `(d[4] >> 7) & 0x1` | 5 |

## 0x20FB  ·  bytes 0-0 used  ·  PPS: can_c

| bytes | bits | signal | type | decode | tables |
|---|---|---|---|---|---|
| 0 | 8-bit | EngTrq_Rq_ESC | y | `d[0]` | 5 |

## 0x20FC  ·  bytes 0-2 used  ·  PPS: can_c

| bytes | bits | signal | type | decode | tables |
|---|---|---|---|---|---|
| 2 | bit 1 | CHRG_FAIL | b | `(d[2] >> 1) & 0x1` | 5 |

## 0x21F5  ·  bytes 0-6 used  ·  PPS: can_c

| bytes | bits | signal | type | decode | tables |
|---|---|---|---|---|---|
| 6 | bit 2 | ACCFaulted | b | `(d[6] >> 2) & 0x1` | 0,6 |
| 6 | bit 0 | ACConlyNA_DASMSts | b | `d[6] & 0x1` | 0,6 |

## 0x21F8  ·  bytes 0-0 used  ·  PPS: can_c

| bytes | bits | signal | type | decode | tables |
|---|---|---|---|---|---|
| 0 | bit 1 | CCMFailSts | b | `(d[0] >> 1) & 0x1` | 5 |

## 0x2214  ·  bytes 0-4 used  ·  PPS: can_c

| bytes | bits | signal | type | decode | tables |
|---|---|---|---|---|---|
| 0-1 | 16-bit | IBS_V_BATT | y | `d[1]<<8 \| d[0]` | 0,6 |
| 4 | bits 0-7 | IBS_T_BATT | b | `d[4] & 0xFF` | 0,6 |

## 0x2248  ·  bytes 0-7 used  ·  PPS: can_c

| bytes | bits | signal | type | decode | tables |
|---|---|---|---|---|---|
| 2 | bits 0-7 | IBS_SOC | b | `d[2] & 0xFF` | 0,1,6,7 |
| 7 | bits 0-1 | IBS_SOC_Accuracy | b | `d[7] & 0x3` | 0,1,6,7 |

## 0x2256  ·  bytes 0-0 used  ·  PPS: can_c

| bytes | bits | signal | type | decode | tables |
|---|---|---|---|---|---|
| 0 | bits 4-5 | SRS_LMP_STAT | b | `(d[0] >> 4) & 0x3` | 5 |

## 0x2257  ·  bytes 0-3 used  ·  PPS: can_c

| bytes | bits | signal | type | decode | tables |
|---|---|---|---|---|---|
| 0 | bits 6-7 | SRS_IndLmp_Rq | b | `(d[0] >> 6) & 0x3` | 5 |
| 2 | bits 5-6 | DRV_SEATBELT | b | `(d[2] >> 5) & 0x3` | 5 |
| 3 | bits 5-7 | PSG_SEATBELT | b | `(d[3] >> 5) & 0x7` | 5 |

## 0x228F  ·  bytes 0-6 used  ·  PPS: hev

| bytes | bits | signal | type | decode | tables |
|---|---|---|---|---|---|
| 0-1 | 16-bit | EstTimeofChrg_Lv2 | y | `d[1]<<8 \| d[0]` | 6 |
| 1 | bits 4-7 | ChargingLevel | b | `(d[1] >> 4) & 0xF` | 6 |
| 1 | bit 3 | ChrgSysFault | b | `(d[1] >> 3) & 0x1` | 6 |
| 2-3 | 16-bit | EstTimeofChrg_Lv1 | y | `d[3]<<8 \| d[2]` | 6 |
| 3 | bit 7 | PrplsnSysAtv | b | `(d[3] >> 7) & 0x1` | 6 |
| 5 | bits 5-7 | ChargingSysSts | b | `(d[5] >> 5) & 0x7` | 6 |
| 6 | bits 4-7 | CabinPreCondReqStat | b | `(d[6] >> 4) & 0xF` | 6 |

## 0x22BD  ·  bytes 0-5 used  ·  PPS: hev

| bytes | bits | signal | type | decode | tables |
|---|---|---|---|---|---|
| 0 | bits 0-1 | HEV_LMP_RQ | b | `d[0] & 0x3` | 6 |
| 2 | bit 3 | HEV_EVT_MD | b | `(d[2] >> 3) & 0x1` | 6 |
| 5 | bits 0-7 | Est_Range | b | `d[5] & 0xFF` | 6 |

## 0x22EF  ·  bytes 0-1 used  ·  PPS: vehstat

| bytes | bits | signal | type | decode | tables |
|---|---|---|---|---|---|
| 0 | bits 4-7 | Gr | b | `(d[0] >> 4) & 0xF` | 5 |
| 1 | bits 0-2 | EngineOilTemp | b | `d[1] & 0x7` | 5 |
| 1 | bits 0-2 | OIL_TEMP_IND_RQ | b | `d[1] & 0x7` | 5 |

## 0x230E  ·  bytes 0-3 used  ·  PPS: hev

| bytes | bits | signal | type | decode | tables |
|---|---|---|---|---|---|
| 0-1 | 16-bit | Gas_Range | y | `d[1]<<8 \| d[0]` | 6 |
| 2-3 | 16-bit | Total_Range | y | `d[3]<<8 \| d[2]` | 6 |

## 0x233A  ·  bytes 0-0 used  ·  PPS: can_c

| bytes | bits | signal | type | decode | tables |
|---|---|---|---|---|---|
| 0 | bit 0 | PTS_FT_SRV | b | `d[0] & 0x1` | 6 |
| 0 | bit 1 | PTS_RR_SRV | b | `(d[0] >> 1) & 0x1` | 6 |

## 0x2340  ·  bytes 0-4 used  ·  PPS: hev

| bytes | bits | signal | type | decode | tables |
|---|---|---|---|---|---|
| 4 | bits 0-7 | Est_Range_Disp | b | `d[4] & 0xFF` | 6 |

## 0x236A  ·  bytes 0-1 used  ·  PPS: can_c

| bytes | bits | signal | type | decode | tables |
|---|---|---|---|---|---|
| 1 | bit 2 | ADS_SrvSys | b | `(d[1] >> 2) & 0x1` | 6 |

## 0x236E  ·  bytes 0-7 used  ·  PPS: hev

| bytes | bits | signal | type | decode | tables |
|---|---|---|---|---|---|
| 1 | bits 0-7 | BatPwrUsageDisp | b | `d[1] & 0xFF` | 6 |
| 3 | bits 0-6 | HVACPwrUsageDisp | b | `d[3] & 0x7F` | 6 |
| 4 | bits 0-7 | HVBatSOC_HC | b | `d[4] & 0xFF` | 6 |
| 5 | bit 4 | BatPwrUsageDisp_V | b | `(d[5] >> 4) & 0x1` | 6 |
| 5 | bit 5 | EngPwrUsageDisp_V | b | `(d[5] >> 5) & 0x1` | 6 |
| 5 | bit 6 | HVACPwrUsageDisp_V | b | `(d[5] >> 6) & 0x1` | 6 |
| 5 | bit 7 | HVBatSOCV_HCP | b | `(d[5] >> 7) & 0x1` | 6 |
| 6-7 | 16-bit | EngPwrUsageDisp | y | `d[7]<<8 \| d[6]` | 6 |

## 0x23AA  ·  bytes 0-8 used  ·  PPS: hev

| bytes | bits | signal | type | decode | tables |
|---|---|---|---|---|---|
| 0-1 | 16-bit | A_MPG | y | `d[1]<<8 \| d[0]` | 6 |
| 2-4 | 24-bit | A_EV_Miles | y | `d[4]<<16 \| d[3]<<8 \| d[2]` | 6 |
| 6-8 | 24-bit | A_EV_Kilometers | y | `d[8]<<16 \| d[7]<<8 \| d[6]` | 6 |

## 0x23AB  ·  bytes 0-8 used  ·  PPS: hev

| bytes | bits | signal | type | decode | tables |
|---|---|---|---|---|---|
| 0-1 | 16-bit | A_KMpL | y | `d[1]<<8 \| d[0]` | 6 |
| 2-4 | 24-bit | A_Hybrid_Miles | y | `d[4]<<16 \| d[3]<<8 \| d[2]` | 6 |
| 6-8 | 24-bit | A_Hybrid_Kilometers | y | `d[8]<<16 \| d[7]<<8 \| d[6]` | 6 |

## 0x23AC  ·  bytes 0-8 used  ·  PPS: hev

| bytes | bits | signal | type | decode | tables |
|---|---|---|---|---|---|
| 2-4 | 24-bit | A_Total_Dist_Miles | y | `d[4]<<16 \| d[3]<<8 \| d[2]` | 6 |
| 6-8 | 24-bit | A_Total_Dist_Kilometers | y | `d[8]<<16 \| d[7]<<8 \| d[6]` | 6 |

## 0x23AD  ·  bytes 0-8 used  ·  PPS: hev

| bytes | bits | signal | type | decode | tables |
|---|---|---|---|---|---|
| 0-1 | 16-bit | B_MPG | y | `d[1]<<8 \| d[0]` | 6 |
| 2-4 | 24-bit | B_EV_Miles | y | `d[4]<<16 \| d[3]<<8 \| d[2]` | 6 |
| 6-8 | 24-bit | B_EV_Kilometers | y | `d[8]<<16 \| d[7]<<8 \| d[6]` | 6 |

## 0x23AE  ·  bytes 0-8 used  ·  PPS: hev

| bytes | bits | signal | type | decode | tables |
|---|---|---|---|---|---|
| 0-1 | 16-bit | B_KMpL | y | `d[1]<<8 \| d[0]` | 6 |
| 2-4 | 24-bit | B_Hybrid_Miles | y | `d[4]<<16 \| d[3]<<8 \| d[2]` | 6 |
| 6-8 | 24-bit | B_Hybrid_Kilometers | y | `d[8]<<16 \| d[7]<<8 \| d[6]` | 6 |

## 0x23AF  ·  bytes 0-8 used  ·  PPS: hev

| bytes | bits | signal | type | decode | tables |
|---|---|---|---|---|---|
| 2-4 | 24-bit | B_Total_Dist_Miles | y | `d[4]<<16 \| d[3]<<8 \| d[2]` | 6 |
| 6-8 | 24-bit | B_Total_Dist_Kilometers | y | `d[8]<<16 \| d[7]<<8 \| d[6]` | 6 |

## 0x23BE  ·  bytes 0-5 used  ·  PPS: hev

| bytes | bits | signal | type | decode | tables |
|---|---|---|---|---|---|
| 0-1 | 16-bit | Electric_Dist_Miles | y | `d[1]<<8 \| d[0]` | 6 |
| 2-3 | 16-bit | Hybrid_Dist_Miles | y | `d[3]<<8 \| d[2]` | 6 |
| 4-5 | 16-bit | MPG_combined | y | `d[5]<<8 \| d[4]` | 6 |

## 0x23BF  ·  bytes 0-5 used  ·  PPS: hev

| bytes | bits | signal | type | decode | tables |
|---|---|---|---|---|---|
| 0-1 | 16-bit | Electric_Dist_Kilometers | y | `d[1]<<8 \| d[0]` | 6 |
| 2-3 | 16-bit | Hybrid_Dist_Kilometers | y | `d[3]<<8 \| d[2]` | 6 |
| 4-5 | 16-bit | KMpL_combined | y | `d[5]<<8 \| d[4]` | 6 |

## 0x23CF  ·  bytes 0-7 used  ·  PPS: srt

| bytes | bits | signal | type | decode | tables |
|---|---|---|---|---|---|
| 1 | bits 0-7 | SRT_60mphTmL | b | `d[1] & 0xFF` | all |
| 2 | bits 0-7 | SRT_eighthTmL | b | `d[2] & 0xFF` | all |
| 3 | bits 0-7 | SRT_quarterTmL | b | `d[3] & 0xFF` | all |
| 4 | bits 0-7 | SRT_EthSpdL_M | b | `d[4] & 0xFF` | all |
| 5 | bits 0-7 | SRT_QrtSpdL_M | b | `d[5] & 0xFF` | all |
| 6 | bits 0-7 | SRT_BrkSpdL_M | b | `d[6] & 0xFF` | all |
| 7 | bits 0-7 | SRT_BrkDistL_M | b | `d[7] & 0xFF` | all |

## 0x23DE  ·  bytes 0-0 used  ·  PPS: compact

| bytes | bits | signal | type | decode | tables |
|---|---|---|---|---|---|
| 0 | bits 0-7 | TravelDistance | b | `d[0] & 0xFF` | 3,5 |

## 0x23E6  ·  bytes 0-2 used  ·  PPS: compact

| bytes | bits | signal | type | decode | tables |
|---|---|---|---|---|---|
| 0 | bits 0-3 | ShiftLeverPosition | b | `d[0] & 0xF` | 5 |
| 1-2 | 16-bit | EngineSpeed | y | `d[2]<<8 \| d[1]` | 3,5 |
| 1-0 | 0-bit | ShiftLeverPosition | y | `` | 3 |
| 2 | bit 6 | EngineSpeedFailSts | b | `(d[2] >> 6) & 0x1` | 3,5 |

## 0x241E  ·  bytes 0-3 used  ·  PPS: can_c

| bytes | bits | signal | type | decode | tables |
|---|---|---|---|---|---|
| 0-1 | 16-bit | IBS_V_BATT | y | `d[1]<<8 \| d[0]` | 5 |
| 3 | bits 0-7 | IBS_T_BATT | b | `d[3] & 0xFF` | 5 |

## 0x2420  ·  bytes 0-0 used  ·  PPS: can_c

| bytes | bits | signal | type | decode | tables |
|---|---|---|---|---|---|
| 0 | bits 0-7 | IBS_SOC | b | `d[0] & 0xFF` | 5 |

## 0x246A  ·  bytes 0-0 used  ·  PPS: comfortstat

| bytes | bits | signal | type | decode | tables |
|---|---|---|---|---|---|
| 0 | bit 1 | PTCFailSts | b | `(d[0] >> 1) & 0x1` | 5 |

## 0x24AC  ·  bytes 0-5 used  ·  PPS: can_c

| bytes | bits | signal | type | decode | tables |
|---|---|---|---|---|---|
| 0 | bits 2-7 | TirePressFL | b | `(d[0] >> 2) & 0x3F` | 5 |
| 1 | bits 2-7 | TirePressRL | b | `(d[1] >> 2) & 0x3F` | 5 |
| 2 | bits 2-7 | TirePressFR | b | `(d[2] >> 2) & 0x3F` | 5 |
| 3 | bits 2-7 | TirePressRR | b | `(d[3] >> 2) & 0x3F` | 5 |
| 5 | bit 1 | TPM_IndLmp_On_Rq | b | `(d[5] >> 1) & 0x1` | 5 |

## 0x24AF  ·  bytes 0-1 used  ·  PPS: can_c

| bytes | bits | signal | type | decode | tables |
|---|---|---|---|---|---|
| 0 | bit 7 | ABS_IndLmp_On_Rq | b | `(d[0] >> 7) & 0x1` | 5 |
| 0 | bit 2 | ESC_CtrlLmp_Info | b | `(d[0] >> 2) & 0x1` | 5 |
| 1 | bit 0 | BrkIndLmp_On_Rq_ESC | b | `d[1] & 0x1` | 5 |

## 0x2545  ·  bytes 0-0 used  ·  PPS: can_c

| bytes | bits | signal | type | decode | tables |
|---|---|---|---|---|---|
| 0 | bits 0-2 | ChkFuelLevelSts | b | `d[0] & 0x7` | 5 |

## 0x25A8  ·  bytes 0-3 used  ·  PPS: can_c

| bytes | bits | signal | type | decode | tables |
|---|---|---|---|---|---|
| 1 | bit 4 | MIL_OnRq_TCM | b | `(d[1] >> 4) & 0x1` | 5 |
| 2 | bit 4 | TxTemp_Excess | b | `(d[2] >> 4) & 0x1` | 5 |
| 3 | bits 0-5 | TransmissionWarnings | b | `d[3] & 0x3F` | 5 |

## 0x25AE  ·  bytes 0-4 used  ·  PPS: can_c, vehstat

| bytes | bits | signal | type | decode | tables |
|---|---|---|---|---|---|
| 2 | bits 2-3 | ETC_IND_LMP | b | `(d[2] >> 2) & 0x3` | 5 |
| 3 | bit 6 | EngOilIndLmp_On_Rq | b | `(d[3] >> 6) & 0x1` | 5 |
| 4 | bit 0 | ChkFuelCap | b | `d[4] & 0x1` | 5 |
| 4 | bit 5 | EngineWaterTempWarningLightSts | b | `(d[4] >> 5) & 0x1` | 5 |
| 4 | bit 2 | FuelWaterPresentFailSts | b | `(d[4] >> 2) & 0x1` | 5 |
| 4 | bits 3-4 | MIL_OnRq | b | `(d[4] >> 3) & 0x3` | 5 |
| 4 | bit 1 | WtrFuelIndLmp_On_Rq | b | `(d[4] >> 1) & 0x1` | 5 |

## 0x25E0  ·  bytes 0-0 used  ·  PPS: can_c

| bytes | bits | signal | type | decode | tables |
|---|---|---|---|---|---|
| 0 | bits 3-6 | EPBSts | b | `(d[0] >> 3) & 0xF` | 5 |

## 0x263A  ·  bytes 0-0 used  ·  PPS: roe

| bytes | bits | signal | type | decode | tables |
|---|---|---|---|---|---|
| 0 | ? (raw shift=8 mask=0xFF) | SD_RS_HCP | j | `type j: raw byte 0` | 6 |

## 0x263B  ·  bytes 0-0 used  ·  PPS: roe

| bytes | bits | signal | type | decode | tables |
|---|---|---|---|---|---|
| 0 | ? (raw shift=8 mask=0xFF) | SD_RS_EBCM | j | `type j: raw byte 0` | 6 |

## 0x275C  ·  bytes 0-1 used  ·  PPS: vehstat

| bytes | bits | signal | type | decode | tables |
|---|---|---|---|---|---|
| 0-1 | 16-bit | IgnitionOnCounter | y | `d[1]<<8 \| d[0]` | 5 |

## 0x33CF  ·  bytes 0-7 used  ·  PPS: srt

| bytes | bits | signal | type | decode | tables |
|---|---|---|---|---|---|
| 1 | bits 0-7 | SRT_60mphTm_C | b | `d[1] & 0xFF` | all |
| 2 | bits 0-7 | SRT_eighthTm_C | b | `d[2] & 0xFF` | all |
| 3 | bits 0-7 | SRT_quarterTm_C | b | `d[3] & 0xFF` | all |
| 4 | bits 0-7 | SRT_EthSpdC_US | b | `d[4] & 0xFF` | all |
| 5 | bits 0-7 | SRT_QrtSpdC_US | b | `d[5] & 0xFF` | all |
| 6 | bits 0-7 | SRT_BrkSpdC_US | b | `d[6] & 0xFF` | all |
| 7 | bits 0-7 | SRT_BrkDistC_US | b | `d[7] & 0xFF` | all |

## 0x43CF  ·  bytes 0-7 used  ·  PPS: srt

| bytes | bits | signal | type | decode | tables |
|---|---|---|---|---|---|
| 1 | bits 0-7 | SRT_60mphTm_B | b | `d[1] & 0xFF` | all |
| 2 | bits 0-7 | SRT_eighthTm_B | b | `d[2] & 0xFF` | all |
| 3 | bits 0-7 | SRT_quarterTm_B | b | `d[3] & 0xFF` | all |
| 4 | bits 0-7 | SRT_EthSpdB_US | b | `d[4] & 0xFF` | all |
| 5 | bits 0-7 | SRT_QrtSpdB_US | b | `d[5] & 0xFF` | all |
| 6 | bits 0-7 | SRT_BrkSpdB_US | b | `d[6] & 0xFF` | all |
| 7 | bits 0-7 | SRT_BrkDistB_US | b | `d[7] & 0xFF` | all |

## 0x53CF  ·  bytes 0-7 used  ·  PPS: srt

| bytes | bits | signal | type | decode | tables |
|---|---|---|---|---|---|
| 1 | bits 0-7 | SRT_60mphTm_L | b | `d[1] & 0xFF` | all |
| 2 | bits 0-7 | SRT_eighthTm_L | b | `d[2] & 0xFF` | all |
| 3 | bits 0-7 | SRT_quarterTm_L | b | `d[3] & 0xFF` | all |
| 4 | bits 0-7 | SRT_EthSpdL_US | b | `d[4] & 0xFF` | all |
| 5 | bits 0-7 | SRT_QrtSpdL_US | b | `d[5] & 0xFF` | all |
| 6 | bits 0-7 | SRT_BrkSpdL_US | b | `d[6] & 0xFF` | all |
| 7 | bits 0-7 | SRT_BrkDistL_US | b | `d[7] & 0xFF` | all |

## 0x63CF  ·  bytes 0-5 used  ·  PPS: srt

| bytes | bits | signal | type | decode | tables |
|---|---|---|---|---|---|
| 1 | bits 0-7 | SRT_0C0mphTmC | b | `d[1] & 0xFF` | all |
| 2 | bits 0-7 | SRT_BrkTmC | b | `d[2] & 0xFF` | all |
| 3 | bits 0-7 | SRT_ReactTmC | b | `d[3] & 0xFF` | 0,1,2,4,6,7,8 |
| 4-5 | 16-bit | SRT_60ftTmC | y | `d[5]<<8 \| d[4]` | 0,6 |

## 0x73CF  ·  bytes 0-5 used  ·  PPS: srt

| bytes | bits | signal | type | decode | tables |
|---|---|---|---|---|---|
| 1 | bits 0-7 | SRT_0C0mphTmB | b | `d[1] & 0xFF` | all |
| 2 | bits 0-7 | SRT_BrkTmB | b | `d[2] & 0xFF` | all |
| 3 | bits 0-7 | SRT_ReactTmB | b | `d[3] & 0xFF` | 0,1,2,4,6,7,8 |
| 4-5 | 16-bit | SRT_60ftTmB | y | `d[5]<<8 \| d[4]` | 0,6 |

## 0x83CF  ·  bytes 0-5 used  ·  PPS: srt

| bytes | bits | signal | type | decode | tables |
|---|---|---|---|---|---|
| 1 | bits 0-7 | SRT_0C0mphTmL | b | `d[1] & 0xFF` | all |
| 2 | bits 0-7 | SRT_BrkTmL | b | `d[2] & 0xFF` | all |
| 3 | bits 0-7 | SRT_ReactTmL | b | `d[3] & 0xFF` | 0,1,2,4,6,7,8 |
| 4-5 | 16-bit | SRT_60ftTmL | y | `d[5]<<8 \| d[4]` | 0,6 |

## 0x93CF  ·  bytes 0-5 used  ·  PPS: srt

| bytes | bits | signal | type | decode | tables |
|---|---|---|---|---|---|
| 1 | bits 0-7 | SRT_0C0mphTm_C | b | `d[1] & 0xFF` | all |
| 2 | bits 0-7 | SRT_BrkTm_C | b | `d[2] & 0xFF` | all |
| 3 | bits 0-7 | SRT_ReactTm_C | b | `d[3] & 0xFF` | 0,1,2,4,6,7,8 |
| 4-5 | 16-bit | SRT_60ftTm_C | y | `d[5]<<8 \| d[4]` | 0,6 |

## 0xA3CF  ·  bytes 0-5 used  ·  PPS: srt

| bytes | bits | signal | type | decode | tables |
|---|---|---|---|---|---|
| 1 | bits 0-7 | SRT_0C0mphTm_B | b | `d[1] & 0xFF` | all |
| 2 | bits 0-7 | SRT_BrkTm_B | b | `d[2] & 0xFF` | all |
| 3 | bits 0-7 | SRT_ReactTm_B | b | `d[3] & 0xFF` | 0,1,2,4,6,7,8 |
| 4-5 | 16-bit | SRT_60ftTm_B | y | `d[5]<<8 \| d[4]` | 0,6 |

## 0xB3CF  ·  bytes 0-5 used  ·  PPS: srt

| bytes | bits | signal | type | decode | tables |
|---|---|---|---|---|---|
| 1 | bits 0-7 | SRT_0C0mphTm_L | b | `d[1] & 0xFF` | all |
| 2 | bits 0-7 | SRT_BrkTm_L | b | `d[2] & 0xFF` | all |
| 3 | bits 0-7 | SRT_ReactTm_L | b | `d[3] & 0xFF` | 0,1,2,4,6,7,8 |
| 4-5 | 16-bit | SRT_60ftTm_L | y | `d[5]<<8 \| d[4]` | 0,6 |

## 0xC0C0  ·  bytes 0-8 used  ·  PPS: vehcfg, vehcfg0

| bytes | bits | signal | type | decode | tables |
|---|---|---|---|---|---|
| 0 | bits 0-1 | Audio_System_Type | b | `d[0] & 0x3` | all |
| 0 | bit 4 | CorneringPresent | b | `(d[0] >> 4) & 0x1` | all |
| 0 | bit 6 | GPS_Presence | b | `(d[0] >> 6) & 0x1` | all |
| 0 | bit 2 | Sdars_Presence | b | `(d[0] >> 2) & 0x1` | all |
| 0 | bit 3 | VC_TwilightSnsrPrsnt | b | `(d[0] >> 3) & 0x1` | all |
| 1 | bit 0 | AFSMenu | b | `d[1] & 0x1` | all |
| 1 | bit 2 | AutoCloseMenu | b | `(d[1] >> 2) & 0x1` | all |
| 1 | bit 5 | BrowsingEnable | b | `(d[1] >> 5) & 0x1` | all |
| 1 | bit 6 | DeadReckoningEnable | b | `(d[1] >> 6) & 0x1` | 1,2,3,4,5,6,7,8 |
| 1 | bit 3 | ExternalTempSensor | b | `(d[1] >> 3) & 0x1` | all |
| 1 | bit 4 | InternalLighting | b | `(d[1] >> 4) & 0x1` | all |
| 1 | bit 7 | NumberOfMics | b | `(d[1] >> 7) & 0x1` | all |
| 1 | bit 1 | OdoUnitsChange | b | `(d[1] >> 1) & 0x1` | all |
| 2 | bits 0-7 | AdditionalLanguages | b | `d[2] & 0xFF` | all |
| 3 | bits 0-4 | Turbo_Param_Max | b | `d[3] & 0x1F` | all |
| 3 | bits 5-7 | Turbo_Param_Typ | b | `(d[3] >> 5) & 0x7` | all |
| 4 | bit 0 | GearShiftIndicator | b | `d[4] & 0x1` | all |
| 4 | bit 4 | GreetingLightsMenu | b | `(d[4] >> 4) & 0x1` | all |
| 4 | bits 2-3 | Microphone_Type | b | `(d[4] >> 2) & 0x3` | all |
| 4 | bit 1 | StartAndStop | b | `(d[4] >> 1) & 0x1` | all |
| 4 | bit 5 | can_node_SDU | b | `(d[4] >> 5) & 0x1` | all |
| 5 | bits 0-7 | AcousticConfig | b | `d[5] & 0xFF` | all |
| 6 | bits 0-2 | ExternalPortType | b | `d[6] & 0x7` | all |
| 6 | bits 3-7 | MicTuningParam | b | `(d[6] >> 3) & 0x1F` | all |
| 7 | bits 4-7 | Brand_Configuration_2 | b | `(d[7] >> 4) & 0xF` | all |
| 7 | bits 0-3 | EngineTypeVariant | b | `d[7] & 0xF` | all |
| 8 | bits 0-1 | AdditionalLanguagesDisplay | b | `d[8] & 0x3` | all |

## 0xC0C1  ·  bytes 0-8 used  ·  PPS: vehcfg0

| bytes | bits | signal | type | decode | tables |
|---|---|---|---|---|---|
| 0 | bit 4 | AutoParkBrakeMenu | b | `(d[0] >> 4) & 0x1` | all |
| 0 | bit 3 | CellPresence | b | `(d[0] >> 3) & 0x1` | 1,2,3,4,5,6,7,8 |
| 0 | bit 5 | NavRepetitionMenu | b | `(d[0] >> 5) & 0x1` | all |
| 0 | bits 0-1 | PamConfiguration | b | `d[0] & 0x3` | all |
| 0 | bit 7 | PhoneRepetitionMenu | b | `(d[0] >> 7) & 0x1` | all |
| 0 | bit 6 | RelockStrategy | b | `(d[0] >> 6) & 0x1` | all |
| 0 | bit 2 | VoiceRecActivation | b | `(d[0] >> 2) & 0x1` | all |
| 1 | bits 5-7 | ClusterDispType | b | `(d[1] >> 5) & 0x7` | 1,2,3,4,5,6,7,8 |
| 1 | bits 0-4 | GearBoxTypeVariant | b | `d[1] & 0x1F` | all |
| 2 | bit 1 | AudioRepetitionMenu | b | `(d[2] >> 1) & 0x1` | all |
| 2 | bits 5-7 | FuelType520 | b | `(d[2] >> 5) & 0x7` | all |
| 2 | bits 2-4 | GearBoxType | b | `(d[2] >> 2) & 0x7` | all |
| 2 | bit 0 | SideDistWarn | b | `d[2] & 0x1` | all |
| 3 | bits 0-3 | AudioCarLayOut | b | `d[3] & 0xF` | all |
| 3 | bit 7 | AudioRepetition | b | `(d[3] >> 7) & 0x1` | all |
| 3 | bits 4-6 | DriveTypeVariant | b | `(d[3] >> 4) & 0x7` | all |
| 4 | bits 0-2 | RRMVPxSWCType | b | `d[4] & 0x7` | 1,2,3,4,5,6,7,8 |
| 5 | bits 3-5 | AudioSystemType | b | `(d[5] >> 3) & 0x7` | all |
| 5 | bit 0 | NavRepetition | b | `d[5] & 0x1` | 3,5 |
| 5 | bit 0 | NavRepetitionCfg | b | `d[5] & 0x1` | 0,1,2,4,6,7,8 |
| 5 | bit 1 | PhoneRepetitionCfg | b | `(d[5] >> 1) & 0x1` | all |
| 5 | bit 2 | RemoteDoorUnlockMenu | b | `(d[5] >> 2) & 0x1` | all |
| 6 | bit 2 | AutoResetTripB | b | `(d[6] >> 2) & 0x1` | all |
| 6 | bits 0-1 | SwitchOffTime | b | `d[6] & 0x3` | all |
| 7 | bits 0-7 | AudioBrand | b | `d[7] & 0xFF` | all |
| 8 | bit 0 | Ambient_Dimmer_Switch | b | `d[8] & 0x1` | 3,5 |
| 8 | bit 1 | Ambient_Lighting_Function | b | `(d[8] >> 1) & 0x1` | 3,5 |

## 0xC0C2  ·  bytes 0-1 used  ·  PPS: vehcfg0

| bytes | bits | signal | type | decode | tables |
|---|---|---|---|---|---|
| 0 | bits 4-6 | ClusterDispType | b | `(d[0] >> 4) & 0x7` | 0 |
| 0 | bit 3 | DAB_Disable | b | `(d[0] >> 3) & 0x1` | 0 |
| 0 | bit 7 | Logistic_Mode | b | `(d[0] >> 7) & 0x1` | 0 |
| 0 | bits 1-2 | Main_Ant_Supply_Cfg | b | `(d[0] >> 1) & 0x3` | 0 |
| 0 | bit 0 | Phase_Diversity | b | `d[0] & 0x1` | 0 |
| 1 | bit 2 | CellPresence | b | `(d[1] >> 2) & 0x1` | 0 |
| 1 | bit 0 | DeadReckoningEnable | b | `d[1] & 0x1` | 0 |
| 1 | bit 7 | EC_MIRROR_HK_PRSNT | b | `(d[1] >> 7) & 0x1` | 0,1 |
| 1 | bits 3-5 | RRMVPxSWCType | b | `(d[1] >> 3) & 0x7` | 0 |
| 1 | bit 6 | Sky_Slider | b | `(d[1] >> 6) & 0x1` | 0 |
| 1 | bit 1 | Tip_Start | b | `(d[1] >> 1) & 0x1` | 0 |

## 0xFFFE  ·  bytes 0-0 used  ·  PPS: vehcfg0

| bytes | bits | signal | type | decode | tables |
|---|---|---|---|---|---|
| 0 | bit 0 | DTV_Diag_Cfg | b | `d[0] & 0x1` | 0,1,6,7 |

