package com.harman.navigation.Controller.GeoCoordinate.util
{
   import com.harman.navigation.global.NavigationPackage;
   import com.harman.navigation.utils.GeoCoordinateTransformer;
   import com.nfuzion.framework.global.Framework;
   
   public class GeoFormatDD implements IGeoFormat
   {
      
      private static const DIGIT_0:String = "0";
      
      private static const DIGIT_0_TO_1:String = "01";
      
      private static const DIGIT_0_TO_8:String = "012345678";
      
      private static const DIGIT_0_TO_9:String = "0123456789";
      
      private static const CHAR_POS_NEG:String = "+-";
      
      private var mFormatID:int = -1;
      
      private var mLatitudeStr:String = "+00.000000°";
      
      private var mLongitudeStr:String = "-000.000000°";
      
      private var mCursorPosition:int = 0;
      
      private var mAvailableCharacters:String = "";
      
      private var mCoordinateType:int = 11;
      
      public function GeoFormatDD(formatID:int)
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
         if(lat.indexOf("NaN") != -1)
         {
            Framework.Trace("GeoFormatDD.importGeoEntry bad lat input (" + lat + ")");
            lat = "+00.000000°";
         }
         if(long.indexOf("NaN") != -1)
         {
            Framework.Trace("GeoFormatDD.importGeoEntry  bad long input (" + long + ")");
            long = "+000.000000°";
         }
         Framework.Trace("GeoFormatDD.importGeoEntry " + lat + " " + long);
         this.mLatitudeStr = lat;
         this.mLongitudeStr = long;
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
               Framework.Trace("GeoFormatDD.currentEntry: Unknown type (" + this.mCoordinateType + ")");
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
               if(pos == 3)
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
               else if(pos >= 9)
               {
                  this.mCursorPosition = 9;
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
               if(pos == 4)
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
               else if(pos >= 10)
               {
                  this.mCursorPosition = 10;
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
               Framework.Trace("GeoFormatDD.setCursorPosition: Unknown type (" + this.mCoordinateType + ")");
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
               return this.mLatitudeStr.length - 1;
            case GeoFormats.TYPE_LONGITUDE:
               return this.mLongitudeStr.length - 1;
            default:
               Framework.Trace("GeoFormatDD.maxCursorPosition: Unknown type (" + this.mCoordinateType + ")");
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
               Framework.Trace("GeoFormatDD.enterCharacter: Unknown type (" + this.mCoordinateType + ")");
         }
      }
      
      public function checkIsValid() : Boolean
      {
         switch(this.mCoordinateType)
         {
            case GeoFormats.TYPE_LATITUDE:
               if(this.mLatitudeStr.indexOf("9") == 1)
               {
                  if(this.mLatitudeStr.indexOf("000000°") == 4)
                  {
                     return true;
                  }
                  return false;
               }
               return true;
               break;
            case GeoFormats.TYPE_LONGITUDE:
               if(this.mLongitudeStr.indexOf("18") == 1)
               {
                  if(this.mLongitudeStr.indexOf("000000°") == 5)
                  {
                     return true;
                  }
                  return false;
               }
               return true;
               break;
            default:
               Framework.Trace("GeoFormatDD.maxCursorPosition: Unknown type (" + this.mCoordinateType + ")");
               return false;
         }
      }
      
      public function getDetails() : void
      {
         var tmp:String = "<GEO>" + this.mLongitudeStr.substring(0,11) + " " + this.mLatitudeStr.substring(0,10) + "<*>";
         Framework.Trace("GeoCoordinateController.getDetails( " + tmp + " )");
         NavigationPackage.peripheral.navigation.navLocationInput.liSetGeoCoordinate(tmp,GeoCoordinateTransformer.transformToLanguage(this.mLatitudeStr + " " + this.mLongitudeStr));
      }
      
      public function get latitudeAsDD() : String
      {
         return this.mLatitudeStr;
      }
      
      public function get longitudeAsDD() : String
      {
         return this.mLongitudeStr;
      }
      
      private function calcAvailableCharacters() : void
      {
         this.mAvailableCharacters = "";
         switch(this.mCoordinateType)
         {
            case GeoFormats.TYPE_LATITUDE:
               if(this.mLatitudeStr.indexOf("9") == 1)
               {
                  if(this.mCursorPosition == 0)
                  {
                     this.mAvailableCharacters = CHAR_POS_NEG;
                  }
                  else if(this.mCursorPosition == 1)
                  {
                     this.mAvailableCharacters = DIGIT_0_TO_9;
                  }
                  else
                  {
                     this.mAvailableCharacters = DIGIT_0;
                  }
                  return;
               }
               switch(this.mCursorPosition)
               {
                  case 0:
                     this.mAvailableCharacters = CHAR_POS_NEG;
                     break;
                  case 1:
                  case 2:
                  case 4:
                  case 5:
                  case 6:
                  case 7:
                  case 8:
                  case 9:
                     this.mAvailableCharacters = DIGIT_0_TO_9;
                     break;
                  case 3:
                     Framework.Trace("\'" + this.mCursorPosition + "\' is an illegal position");
                     break;
                  default:
                     Framework.Trace("GeoFormatDD.calcAvailableCharacters(lat) Illegal cursor position( " + this.mCursorPosition + " )");
               }
               break;
            case GeoFormats.TYPE_LONGITUDE:
               if(this.mLongitudeStr.indexOf("18") == 1)
               {
                  if(this.mCursorPosition == 0)
                  {
                     this.mAvailableCharacters = CHAR_POS_NEG;
                  }
                  else if(this.mCursorPosition == 1)
                  {
                     this.mAvailableCharacters = DIGIT_0_TO_1;
                  }
                  else if(this.mCursorPosition == 2)
                  {
                     this.mAvailableCharacters = DIGIT_0_TO_8;
                  }
                  else
                  {
                     this.mAvailableCharacters = DIGIT_0;
                  }
                  return;
               }
               switch(this.mCursorPosition)
               {
                  case 0:
                     this.mAvailableCharacters = CHAR_POS_NEG;
                     break;
                  case 1:
                     this.mAvailableCharacters = DIGIT_0_TO_1;
                     break;
                  case 2:
                     if(this.mLongitudeStr.indexOf("1") == 1)
                     {
                        this.mAvailableCharacters = DIGIT_0_TO_8;
                     }
                     else
                     {
                        this.mAvailableCharacters = DIGIT_0_TO_9;
                     }
                     break;
                  case 3:
                  case 5:
                  case 6:
                  case 7:
                  case 8:
                  case 9:
                  case 10:
                     this.mAvailableCharacters = DIGIT_0_TO_9;
                     break;
                  case 4:
                     Framework.Trace("\'" + this.mCursorPosition + "\' is an illegal position");
                     break;
                  default:
                     Framework.Trace("GeoFormatDD.calcAvailableCharacters(long) Illegal cursor position( " + this.mCursorPosition + " )");
               }
         }
      }
   }
}

