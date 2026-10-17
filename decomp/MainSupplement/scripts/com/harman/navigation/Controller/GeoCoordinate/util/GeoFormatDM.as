package com.harman.navigation.Controller.GeoCoordinate.util
{
   import com.harman.navigation.global.NavigationPackage;
   import com.harman.navigation.utils.GeoCoordinateTransformer;
   import com.nfuzion.framework.global.Framework;
   
   public class GeoFormatDM implements IGeoFormat
   {
      
      private static const DIGIT_0:String = "0";
      
      private static const DIGIT_0_TO_1:String = "01";
      
      private static const DIGIT_0_TO_5:String = "012345";
      
      private static const DIGIT_0_TO_8:String = "012345678";
      
      private static const DIGIT_0_TO_9:String = "0123456789";
      
      private static const CHAR_N_S:String = "NS";
      
      private static const CHAR_E_W:String = "EW";
      
      private var mFormatID:int = -1;
      
      private var mLatitudeStr:String = "00°00.000\' N";
      
      private var mLongitudeStr:String = "000°00.000\' E";
      
      private var mCursorPosition:int = 0;
      
      private var mAvailableCharacters:String = "";
      
      private var mCoordinateType:int = 11;
      
      public function GeoFormatDM(formatID:int)
      {
         super();
         this.mFormatID = formatID;
      }
      
      public function get formatID() : int
      {
         return this.mFormatID;
      }
      
      public function importGeoEntry(lat:String, long:String) : void
      {
         Framework.Trace("GeoFormatDM.importGeoEntry " + lat + " " + long);
         this.mLatitudeStr = GeoCoordinateTransformer.transformDD_Lat_to_DM(lat);
         this.mLongitudeStr = GeoCoordinateTransformer.transformDD_Long_to_DM(long,true);
      }
      
      public function get currentEntry() : String
      {
         switch(this.mCoordinateType)
         {
            case GeoFormats.TYPE_LATITUDE:
               return this.mLatitudeStr;
            case GeoFormats.TYPE_LONGITUDE:
               return this.mLongitudeStr;
            default:
               Framework.Trace("GeoFormatDM.currentEntry: Unknown type (" + this.mCoordinateType + ")");
               return "";
         }
      }
      
      public function setCoordinateType(type:int) : void
      {
         this.mCoordinateType = type;
      }
      
      public function get coordinateType() : int
      {
         return this.mCoordinateType;
      }
      
      public function setCursorPosition(pos:int) : void
      {
         switch(this.mCoordinateType)
         {
            case GeoFormats.TYPE_LATITUDE:
               if(pos == 2 || pos == 5 || pos == 9 || pos == 10)
               {
                  if(pos > this.mCursorPosition)
                  {
                     this.setCursorPosition(pos + 1);
                  }
                  else
                  {
                     this.setCursorPosition(pos - 1);
                  }
               }
               else if(pos >= 11)
               {
                  this.mCursorPosition = 11;
               }
               else if(pos <= 0)
               {
                  this.mCursorPosition = 0;
               }
               else
               {
                  this.mCursorPosition = pos;
               }
               break;
            case GeoFormats.TYPE_LONGITUDE:
               if(pos == 3 || pos == 6 || pos == 10 || pos == 11)
               {
                  if(pos > this.mCursorPosition)
                  {
                     this.setCursorPosition(pos + 1);
                  }
                  else
                  {
                     this.setCursorPosition(pos - 1);
                  }
               }
               else if(pos >= 12)
               {
                  this.mCursorPosition = 12;
               }
               else if(pos <= 0)
               {
                  this.mCursorPosition = 0;
               }
               else
               {
                  this.mCursorPosition = pos;
               }
               break;
            default:
               Framework.Trace("GeoFormatDM.setCursorPosition: Unknown type (" + this.mCoordinateType + ")");
         }
      }
      
      public function get cursorPosition() : int
      {
         return this.mCursorPosition;
      }
      
      public function get maxCursorPosition() : int
      {
         switch(this.mCoordinateType)
         {
            case GeoFormats.TYPE_LATITUDE:
               return this.mLatitudeStr.length;
            case GeoFormats.TYPE_LONGITUDE:
               return this.mLongitudeStr.length;
            default:
               Framework.Trace("GeoFormatDM.maxCursorPosition: Unknown type (" + this.mCoordinateType + ")");
               return 0;
         }
      }
      
      public function get availableCharacters() : String
      {
         this.calcAvailableCharacters();
         return this.mAvailableCharacters;
      }
      
      public function enterCharacter(char:String) : void
      {
         var tmp:String = "";
         var i:int = 0;
         switch(this.mCoordinateType)
         {
            case GeoFormats.TYPE_LATITUDE:
               for(i = 0; i < this.mCursorPosition; i++)
               {
                  tmp = tmp.concat(this.mLatitudeStr.charAt(i));
               }
               tmp = tmp.concat(char);
               for(i = this.mCursorPosition + 1; i < this.mLatitudeStr.length; i++)
               {
                  tmp = tmp.concat(this.mLatitudeStr.charAt(i));
               }
               this.mLatitudeStr = tmp;
               this.setCursorPosition(this.mCursorPosition + 1);
               break;
            case GeoFormats.TYPE_LONGITUDE:
               for(i = 0; i < this.mCursorPosition; i++)
               {
                  tmp = tmp.concat(this.mLongitudeStr.charAt(i));
               }
               tmp = tmp.concat(char);
               for(i = this.mCursorPosition + 1; i < this.mLongitudeStr.length; i++)
               {
                  tmp = tmp.concat(this.mLongitudeStr.charAt(i));
               }
               this.mLongitudeStr = tmp;
               this.setCursorPosition(this.mCursorPosition + 1);
               break;
            default:
               Framework.Trace("GeoFormatDM.enterCharacter: Unknown type (" + this.mCoordinateType + ")");
         }
      }
      
      public function checkIsValid() : Boolean
      {
         switch(this.mCoordinateType)
         {
            case GeoFormats.TYPE_LATITUDE:
               if(this.mLatitudeStr.indexOf("9") == 0)
               {
                  if(this.mLatitudeStr.indexOf("0°00.000\'") == 1)
                  {
                     return true;
                  }
                  return false;
               }
               return true;
               break;
            case GeoFormats.TYPE_LONGITUDE:
               if(this.mLongitudeStr.indexOf("18") == 0)
               {
                  if(this.mLongitudeStr.indexOf("0°00.000\'") == 2)
                  {
                     return true;
                  }
                  return false;
               }
               return true;
               break;
            default:
               Framework.Trace("GeoFormatDM.maxCursorPosition: Unknown type (" + this.mCoordinateType + ")");
               return false;
         }
      }
      
      public function getDetails() : void
      {
         var tmp:String = "<GEO>" + GeoCoordinateTransformer.transformDM_Long_to_DD(this.mLongitudeStr,false) + " " + GeoCoordinateTransformer.transformDM_Lat_to_DD(this.mLatitudeStr,false) + "<*>";
         NavigationPackage.peripheral.navigation.navLocationInput.liSetGeoCoordinate(tmp,GeoCoordinateTransformer.transformToLanguage(this.mLatitudeStr + " " + this.mLongitudeStr));
      }
      
      public function get latitudeAsDD() : String
      {
         return GeoCoordinateTransformer.transformDM_Lat_to_DD(this.mLatitudeStr,true);
      }
      
      public function get longitudeAsDD() : String
      {
         return GeoCoordinateTransformer.transformDM_Long_to_DD(this.mLongitudeStr,true);
      }
      
      private function calcAvailableCharacters() : void
      {
         this.mAvailableCharacters = "";
         switch(this.mCoordinateType)
         {
            case GeoFormats.TYPE_LATITUDE:
               if(this.mLatitudeStr.indexOf("9") == 0)
               {
                  if(this.mCursorPosition == 11)
                  {
                     this.mAvailableCharacters = CHAR_N_S;
                  }
                  else if(this.mCursorPosition > 0)
                  {
                     this.mAvailableCharacters = DIGIT_0;
                  }
                  else
                  {
                     this.mAvailableCharacters = DIGIT_0_TO_9;
                  }
                  return;
               }
               switch(this.mCursorPosition)
               {
                  case 0:
                  case 1:
                  case 4:
                  case 6:
                  case 7:
                  case 8:
                     this.mAvailableCharacters = DIGIT_0_TO_9;
                     break;
                  case 2:
                  case 5:
                  case 9:
                  case 10:
                     Framework.Trace("\'" + this.mCursorPosition + "\' is an illegal position");
                     break;
                  case 3:
                     this.mAvailableCharacters = DIGIT_0_TO_5;
                     break;
                  case 11:
                     this.mAvailableCharacters = CHAR_N_S;
                     break;
                  default:
                     Framework.Trace("GeoFormatDM.calcAvailableCharacters(lat) Illegal cursor position( " + this.mCursorPosition + " )");
               }
               break;
            case GeoFormats.TYPE_LONGITUDE:
               if(this.mLongitudeStr.indexOf("18") == 0)
               {
                  if(this.mCursorPosition == 12)
                  {
                     this.mAvailableCharacters = CHAR_E_W;
                  }
                  else if(this.mCursorPosition == 0)
                  {
                     this.mAvailableCharacters = DIGIT_0_TO_1;
                  }
                  else if(this.mCursorPosition == 1)
                  {
                     this.mAvailableCharacters = DIGIT_0_TO_8;
                  }
                  else if(this.mCursorPosition > 1)
                  {
                     this.mAvailableCharacters = DIGIT_0;
                  }
                  else
                  {
                     this.mAvailableCharacters = DIGIT_0_TO_9;
                  }
                  return;
               }
               switch(this.mCursorPosition)
               {
                  case 0:
                     this.mAvailableCharacters = DIGIT_0_TO_1;
                     break;
                  case 1:
                     if(this.mLongitudeStr.charAt(0) == "1")
                     {
                        this.mAvailableCharacters = DIGIT_0_TO_8;
                     }
                     else
                     {
                        this.mAvailableCharacters = DIGIT_0_TO_9;
                     }
                     break;
                  case 2:
                  case 5:
                  case 7:
                  case 8:
                  case 9:
                     this.mAvailableCharacters = DIGIT_0_TO_9;
                     break;
                  case 3:
                  case 6:
                  case 10:
                  case 11:
                     Framework.Trace("\'" + this.mCursorPosition + "\' is an illegal position");
                     break;
                  case 4:
                     this.mAvailableCharacters = DIGIT_0_TO_5;
                     break;
                  case 12:
                     this.mAvailableCharacters = CHAR_E_W;
                     break;
                  default:
                     Framework.Trace("GeoFormatDM.calcAvailableCharacters(long) Illegal cursor position( " + this.mCursorPosition + " )");
               }
         }
      }
   }
}

