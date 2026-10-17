package com.harman.navigation.utils
{
   import com.harman.navigation.global.vServices.VServiceGlobalSettings;
   
   public class LocationDetails
   {
      
      private static const EIS_END_TAG:String = "<*>";
      
      private var mCustomName:String = "";
      
      private var mStreetNameOriginal:String = "";
      
      private var mStreetNameTexts:Array = new Array();
      
      private var mStreetNameIcons:Array = new Array();
      
      private var mEmptyEisTypes:Array = new Array();
      
      private var locDescArray:Object = {
         "<CTR>":"",
         "<CAB>":"",
         "<STA>":"",
         "<SAB>":"",
         "<CTY>":"",
         "<ZIP>":"",
         "<STR>":"",
         "<HNO>":"",
         "<SUB>":"",
         "<FLO>":"",
         "<APP>":"",
         "<TEL>":"",
         "<FAX>":"",
         "<EML>":"",
         "<WWW>":"",
         "<ITR>":"",
         "<ITRN>":"",
         "<ITRL>":"",
         "<DIR>":"",
         "<GEO>":"",
         "<POI>":"",
         "<CAT>":"",
         "<BND>":"",
         "<CUT>":"",
         "<FUT>":"",
         "<TZO>":"",
         "<SPL>":"",
         "<ICON>":"",
         "<POI_NNG>":"",
         "<CAT_NNG>":"",
         "<CTY_NNG>":"",
         "<STA_NNG>":"",
         "<STR_NNG>":"",
         "<ITR_NNG>":"",
         "<ITRN_NNG>":"",
         "<ITRL_NNG>":"",
         "<CTR_NNG>":"",
         "<HNO_NNG>":"",
         "<ZIP_NNG>":"",
         "<IFT>":"",
         "<PRE>":""
      };
      
      public function LocationDetails()
      {
         super();
      }
      
      public static function fromPreset(poiPreset:String) : LocationDetails
      {
         var ld:LocationDetails = new LocationDetails();
         ld.addType("<PRE>",poiPreset);
         return ld;
      }
      
      public function clone(src:LocationDetails) : void
      {
         this.setCustomName(src.getCustomName());
         this.addEisString(src.toEIS());
      }
      
      public function setCustomName(name:String) : void
      {
         this.mCustomName = name;
      }
      
      public function getCustomName() : String
      {
         return this.mCustomName;
      }
      
      public function getType(eisType:String) : String
      {
         return this.locDescArray[eisType];
      }
      
      public function addType(eisType:String, data:String) : void
      {
         if(data == "")
         {
            if(this.mEmptyEisTypes.indexOf(eisType) == -1)
            {
               this.mEmptyEisTypes.push(eisType);
            }
         }
         else
         {
            switch(eisType)
            {
               case "<TEL>":
                  this.locDescArray[eisType] = this.formatPhoneNumber(data);
                  break;
               default:
                  this.locDescArray[eisType] = data;
            }
            this.removeFromEmptyEisTypes(data);
         }
      }
      
      public function removeType(eisType:String) : void
      {
         this.locDescArray[eisType] = "";
         this.removeFromEmptyEisTypes(eisType);
      }
      
      public function isPOI() : Boolean
      {
         if(String(this.locDescArray["<POI>"]).length > 0)
         {
            return true;
         }
         return false;
      }
      
      private function formatPhoneNumber(data:String) : String
      {
         var retVal:String = "";
         switch(VServiceGlobalSettings.navMarketConfig)
         {
            case VServiceGlobalSettings.MARKET_EUROPE:
            case VServiceGlobalSettings.MARKET_ROW:
               retVal = data.replace(/[^0-9]+/g,"");
               break;
            default:
               retVal = data;
         }
         return retVal;
      }
      
      public function toEIS() : String
      {
         var i:int = 0;
         var erg:String = new String();
         if(this.locDescArray["<IFT>"] != "")
         {
            erg += "<IFT>" + this.locDescArray["<IFT>"] + EIS_END_TAG;
         }
         if(this.locDescArray["<CTR>"] != "")
         {
            erg += "<CTR>" + this.locDescArray["<CTR>"] + EIS_END_TAG;
         }
         if(this.locDescArray["<CTR_NNG>"] != "")
         {
            erg += "<CTR_NNG>" + this.locDescArray["<CTR_NNG>"] + EIS_END_TAG;
         }
         if(this.locDescArray["<STA>"] != "")
         {
            erg += "<STA>" + this.locDescArray["<STA>"] + EIS_END_TAG;
         }
         if(this.locDescArray["<STA_NNG>"] != "")
         {
            erg += "<STA_NNG>" + this.locDescArray["<STA_NNG>"] + EIS_END_TAG;
         }
         if(this.locDescArray["<CTY>"] != "")
         {
            erg += "<CTY>" + this.locDescArray["<CTY>"] + EIS_END_TAG;
         }
         if(this.locDescArray["<CTY_NNG>"] != "")
         {
            erg += "<CTY_NNG>" + this.locDescArray["<CTY_NNG>"] + EIS_END_TAG;
         }
         if(this.locDescArray["<ZIP>"] != "")
         {
            erg += "<ZIP>" + this.locDescArray["<ZIP>"] + EIS_END_TAG;
         }
         if(this.locDescArray["<ZIP_NNG>"] != "")
         {
            erg += "<ZIP_NNG>" + this.locDescArray["<ZIP_NNG>"] + EIS_END_TAG;
         }
         if(this.locDescArray["<STR>"] != "")
         {
            erg += "<STR>" + this.locDescArray["<STR>"] + EIS_END_TAG;
         }
         if(this.locDescArray["<STR_NNG>"] != "")
         {
            erg += "<STR_NNG>" + this.locDescArray["<STR_NNG>"] + EIS_END_TAG;
         }
         if(this.locDescArray["<ITRN>"] != "")
         {
            erg += "<ITRN>" + this.locDescArray["<ITRN>"] + EIS_END_TAG;
         }
         if(this.locDescArray["<ITR_NNG>"] != "")
         {
            erg += "<ITR_NNG>" + this.locDescArray["<ITR_NNG>"] + EIS_END_TAG;
         }
         if(this.locDescArray["<CAT>"] != "")
         {
            erg += "<CAT>" + this.locDescArray["<CAT>"] + EIS_END_TAG;
         }
         if(this.locDescArray["<CAT_NNG>"] != "")
         {
            erg += "<CAT_NNG>" + this.locDescArray["<CAT_NNG>"] + EIS_END_TAG;
         }
         if(this.locDescArray["<POI>"] != "")
         {
            erg += "<POI>" + this.locDescArray["<POI>"] + EIS_END_TAG;
         }
         if(this.locDescArray["<POI_NNG>"] != "")
         {
            erg += "<POI_NNG>" + this.locDescArray["<POI_NNG>"] + EIS_END_TAG;
         }
         if(this.locDescArray["<HNO>"] != "")
         {
            erg += "<HNO>" + this.locDescArray["<HNO>"] + EIS_END_TAG;
         }
         if(this.locDescArray["<HNO_NNG>"] != "")
         {
            erg += "<HNO_NNG>" + this.locDescArray["<HNO_NNG>"] + EIS_END_TAG;
         }
         if(this.locDescArray["<CAB>"] != "")
         {
            erg += "<CAB>" + this.locDescArray["<CAB>"] + EIS_END_TAG;
         }
         if(this.locDescArray["<SAB>"] != "")
         {
            erg += "<SAB>" + this.locDescArray["<SAB>"] + EIS_END_TAG;
         }
         if(this.locDescArray["<SUB>"] != "")
         {
            erg += "<SUB>" + this.locDescArray["<SUB>"] + EIS_END_TAG;
         }
         if(this.locDescArray["<FLO>"] != "")
         {
            erg += "<FLO>" + this.locDescArray["<FLO>"] + EIS_END_TAG;
         }
         if(this.locDescArray["<APP>"] != "")
         {
            erg += "<APP>" + this.locDescArray["<APP>"] + EIS_END_TAG;
         }
         if(this.locDescArray["<TEL>"] != "")
         {
            erg += "<TEL>" + this.locDescArray["<TEL>"] + EIS_END_TAG;
         }
         if(this.locDescArray["<FAX>"] != "")
         {
            erg += "<FAX>" + this.locDescArray["<FAX>"] + EIS_END_TAG;
         }
         if(this.locDescArray["<EML>"] != "")
         {
            erg += "<EML>" + this.locDescArray["<EML>"] + EIS_END_TAG;
         }
         if(this.locDescArray["<WWW>"] != "")
         {
            erg += "<WWW>" + this.locDescArray["<WWW>"] + EIS_END_TAG;
         }
         if(this.locDescArray["<ITR>"] != "")
         {
            erg += "<ITR>" + this.locDescArray["<ITR>"] + EIS_END_TAG;
         }
         if(this.locDescArray["<DIR>"] != "")
         {
            erg += "<DIR>" + this.locDescArray["<DIR>"] + EIS_END_TAG;
         }
         if(this.locDescArray["<GEO>"] != "")
         {
            erg += "<GEO>" + this.locDescArray["<GEO>"] + EIS_END_TAG;
         }
         if(this.locDescArray["<BND>"] != "")
         {
            erg += "<BND>" + this.locDescArray["<BND>"] + EIS_END_TAG;
         }
         if(this.locDescArray["<CUT>"] != "")
         {
            erg += "<CUT>" + this.locDescArray["<CUT>"] + EIS_END_TAG;
         }
         if(this.locDescArray["<FUT>"] != "")
         {
            erg += "<FUT>" + this.locDescArray["<FUT>"] + EIS_END_TAG;
         }
         if(this.locDescArray["<TZO>"] != "")
         {
            erg += "<TZO>" + this.locDescArray["<TZO>"] + EIS_END_TAG;
         }
         if(this.locDescArray["<SPL>"] != "")
         {
            erg += "<SPL>" + this.locDescArray["<SPL>"] + EIS_END_TAG;
         }
         if(this.locDescArray["<ICON>"] != "")
         {
            erg += "<ICON>" + this.locDescArray["<ICON>"] + EIS_END_TAG;
         }
         if(this.locDescArray["<ITRL>"] != "")
         {
            erg += "<ITRL>" + this.locDescArray["<ITRL>"] + EIS_END_TAG;
         }
         if(this.locDescArray["<PRE>"] != "")
         {
            erg += "<PRE>" + this.locDescArray["<PRE>"] + EIS_END_TAG;
         }
         while(i < this.mEmptyEisTypes.length)
         {
            erg += String(this.mEmptyEisTypes[i]) + EIS_END_TAG;
            i++;
         }
         return erg;
      }
      
      public function addEisString(eisString:String) : void
      {
         var eisType:String = null;
         var eisValue:String = null;
         while(eisString.length > 0 && eisString.indexOf(EIS_END_TAG) > -1)
         {
            eisType = eisString.substring(0,eisString.indexOf(">") + 1);
            eisValue = eisString.substring(eisString.indexOf(">") + 1,eisString.indexOf(EIS_END_TAG));
            if(eisValue.length == 0)
            {
               this.mEmptyEisTypes.push(eisType);
            }
            else
            {
               if(eisType == "<TEL>")
               {
                  eisValue = this.formatPhoneNumber(this.skimMultiplePhonenumbers(eisValue));
               }
               this.locDescArray[eisType] = eisValue;
               this.removeFromEmptyEisTypes(eisValue);
            }
            eisString = eisString.slice(eisString.indexOf(EIS_END_TAG) + 3,eisString.length + 1);
         }
      }
      
      public function addEisStringPosPosition(eisString:String) : void
      {
         var eisType:String = null;
         var eisValue:String = null;
         var lastFoundType:String = "";
         this.mStreetNameOriginal = "";
         this.mStreetNameTexts = new Array();
         this.mStreetNameIcons = new Array();
         while(eisString.length > 0 && eisString.indexOf(EIS_END_TAG) > -1)
         {
            eisType = eisString.substring(0,eisString.indexOf(">") + 1);
            eisValue = eisString.substring(eisString.indexOf(">") + 1,eisString.indexOf(EIS_END_TAG));
            if(eisValue.length == 0)
            {
               this.mEmptyEisTypes.push(eisType);
            }
            else
            {
               if(lastFoundType == "<STR>")
               {
                  if(eisType == "<TXT>")
                  {
                     this.mStreetNameTexts.push(eisValue);
                  }
                  else if(eisType == "<ICON>")
                  {
                     this.mStreetNameIcons.push(eisValue);
                  }
               }
               if(eisType == "<STR>")
               {
                  this.mStreetNameOriginal = eisValue;
               }
               if(eisType == "<TXT>")
               {
                  if(String(this.locDescArray[lastFoundType]).indexOf("%s") != -1)
                  {
                     if(String(this.locDescArray[lastFoundType]).indexOf(eisValue) != -1)
                     {
                        this.locDescArray[lastFoundType] = String(this.locDescArray[lastFoundType]).replace("%s","");
                     }
                     else
                     {
                        this.locDescArray[lastFoundType] = String(this.locDescArray[lastFoundType]).replace("%s",eisValue);
                     }
                  }
               }
               else if(eisType == "<ICON>")
               {
                  if(lastFoundType == "<STR>" && this.locDescArray["<ICON>"] == "")
                  {
                     this.locDescArray["<ICON>"] = eisValue;
                  }
               }
               else if(eisType == "<TEL>")
               {
                  this.locDescArray[eisType] = this.formatPhoneNumber(eisValue);
               }
               else
               {
                  this.locDescArray[eisType] = eisValue;
               }
               if(eisType != "<ICON>" && eisType != "<TXT>")
               {
                  lastFoundType = eisType;
               }
               this.removeFromEmptyEisTypes(eisValue);
            }
            eisString = eisString.slice(eisString.indexOf(EIS_END_TAG) + 3,eisString.length + 1);
         }
      }
      
      public function addEisStringGetDetails(eisString:String) : void
      {
         var eisType:String = null;
         var eisValue:String = null;
         while(eisString.length > 0 && eisString.indexOf(EIS_END_TAG) > -1)
         {
            eisType = eisString.substring(0,eisString.indexOf(">") + 1);
            eisValue = eisString.substring(eisString.indexOf(">") + 1,eisString.indexOf(EIS_END_TAG));
            if(eisValue.length == 0)
            {
               this.mEmptyEisTypes.push(eisType);
            }
            else
            {
               if(!(eisType == "<STR>" && this.locDescArray["<ITR>"] != ""))
               {
                  if(eisType == "<TEL>")
                  {
                     this.locDescArray[eisType] = this.formatPhoneNumber(eisValue);
                  }
                  else
                  {
                     this.locDescArray[eisType] = eisValue;
                  }
               }
               this.removeFromEmptyEisTypes(eisValue);
            }
            eisString = eisString.slice(eisString.indexOf(EIS_END_TAG) + 3,eisString.length + 1);
         }
      }
      
      public function eraseEisType(eisType:String) : void
      {
         this.locDescArray[eisType] = "";
      }
      
      public function getPersistenceString() : String
      {
         var persStr:String = "<CUSTOM_NAME>" + this.mCustomName + "<*>";
         return persStr + this.toEIS();
      }
      
      public function setFromPersistenceString(str:String) : void
      {
         if(str.length == 0)
         {
            return;
         }
         this.mCustomName = str.substring(str.indexOf("<CUSTOM_NAME>") + 13,str.indexOf("<*>"));
         str = str.slice(str.indexOf("<*>") + 3,str.length);
         this.addEisString(str);
      }
      
      public function getStreetNameWithMaxXIcons(icons:int) : String
      {
         var streetName:String = this.mStreetNameOriginal;
         for(var i:int = 0; i < icons; i++)
         {
            streetName = streetName.replace("%s","");
         }
         var j:int = 0;
         while(streetName.indexOf("%s") != -1 && this.mStreetNameTexts.length > j)
         {
            if(streetName.indexOf(String(this.mStreetNameTexts[j])) == -1)
            {
               streetName = streetName.replace("%s",this.mStreetNameTexts[j]);
            }
            else
            {
               streetName = streetName.replace("%s","");
            }
            j++;
         }
         return streetName;
      }
      
      public function getStreetNameIconPath(index:int) : String
      {
         if(this.mStreetNameIcons.length > index)
         {
            return String(this.mStreetNameIcons[index]);
         }
         return "";
      }
      
      private function removeFromEmptyEisTypes(eisType:String) : void
      {
         for(var i:int = 0; i < this.mEmptyEisTypes.length; i++)
         {
            if(eisType == String(this.mEmptyEisTypes[i]))
            {
               this.mEmptyEisTypes.splice(i,1);
            }
         }
      }
      
      private function skimMultiplePhonenumbers(eisValue:String) : String
      {
         if(eisValue.indexOf(",") != -1)
         {
            return eisValue.slice(0,eisValue.indexOf(","));
         }
         return eisValue;
      }
   }
}

