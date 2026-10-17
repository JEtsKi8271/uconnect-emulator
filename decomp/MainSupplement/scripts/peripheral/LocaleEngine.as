package peripheral
{
   import com.harman.moduleLinkAPI.HMIRequestEvent;
   import com.harman.moduleLinkAPI.VehicleStatusEvent;
   import com.nfuzion.moduleLinkAPI.VehConfigEvent;
   import core.locale.Locale;
   import core.locale.LocaleArchive;
   import events.LocaleEvent;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import locale.T;
   
   public class LocaleEngine extends EventDispatcher
   {
      
      private static const languageIDToXMLIDTable:Object = {
         "de_DE":2,
         "en_US":3,
         "fr_CA":4,
         "fr_FR":5,
         "it_IT":6,
         "es_MX":7,
         "es_ES":8,
         "ja_JP":9,
         "pt_PT":10,
         "nl_NL":11,
         "en_GB":12,
         "zh_CN":13,
         "ru_RU":14,
         "ko_KR":15,
         "pt_BR":16,
         "pl_PL":17,
         "tr_TR":18,
         "ar_AE":19
      };
      
      private static const languageIDToTextTable:Object = {
         "de_DE":"Deutsch",
         "en_US":"English",
         "fr_CA":"Français",
         "fr_FR":"Français",
         "it_IT":"Italiano",
         "es_MX":"Español",
         "es_ES":"Español",
         "ja_JP":"日本語",
         "pt_PT":"Português",
         "nl_NL":"Nederlands",
         "en_GB":"English",
         "zh_CN":"简体中文",
         "ru_RU":"Русский",
         "ko_KR":"한국어",
         "pt_BR":"Português BR",
         "pl_PL":"Polski",
         "tr_TR":"Türk",
         "ar_AE":"عربي"
      };
      
      private static const XMLIDTolanguageIDTable:Vector.<String> = new <String>[undefined,undefined,"de_DE","en_US","fr_CA","fr_FR","it_IT","es_MX","es_ES","ja_JP","pt_PT","nl_NL","en_GB","zh_CN","ru_RU","ko_KR","pt_BR","pl_PL","tr_TR","ar_AE"];
      
      private var mLocales:Vector.<Locale>;
      
      private var mCurrentLocale:Locale;
      
      private var showHexCodes:Boolean = false;
      
      private var hasAdditionalLanguagesFeature:Boolean = false;
      
      private var VARIANT_PRODUCT:String;
      
      public function LocaleEngine()
      {
         this.VARIANT_PRODUCT = Peripheral.versionInfo.productVariantID.VARIANT_PRODUCT;
         super();
         LocaleArchive.getInstance().addEventListener(LocaleArchive.getInstance().EVT_LANGUAGE_CHANGED(),this.onLanguageChange);
         Peripheral.vehicleStatus.addEventListener(VehicleStatusEvent.LANGUAGE,this.vehicleStatusLanguageChange);
         Peripheral.hmiRequest.addEventListener(HMIRequestEvent.GET_HEX_CODE,this.onHexCodeRequest);
         this.hasAdditionalLanguagesFeature = Peripheral.versionInfo.productVariantID.VARIANT_PRODUCT == "MP4";
         var langVariant:String = XMLIDTolanguageIDTable[Global.languageId];
         if(!langVariant)
         {
            langVariant = "en_US";
         }
         if(Boolean(Peripheral.vehConfig) && Peripheral.vehConfig.variantMarket != "")
         {
            this.onMarketConfigRead();
            langVariant = this.validateLanguageSelection(langVariant);
         }
         else
         {
            Peripheral.vehConfig.addEventListener(VehConfigEvent.VARIANT_MARKET,this.onVariantMarketAvailable,false,0,true);
         }
         LocaleArchive.getInstance().setLanguage(languageIDToXMLIDTable[langVariant],languageIDToXMLIDTable[langVariant]);
         this.mCurrentLocale = new Locale(langVariant,languageIDToTextTable[langVariant]);
      }
      
      private function onVariantMarketAvailable(e:VehConfigEvent) : void
      {
         var langVariant:String = null;
         Peripheral.vehConfig.removeEventListener(VehConfigEvent.VARIANT_MARKET,this.onVariantMarketAvailable);
         if(Peripheral.vehConfig.variantMarket)
         {
            langVariant = XMLIDTolanguageIDTable[Global.languageId];
            this.onMarketConfigRead();
            langVariant = this.validateLanguageSelection(langVariant);
            LocaleArchive.getInstance().setLanguage(languageIDToXMLIDTable[langVariant],languageIDToXMLIDTable[langVariant]);
            this.mCurrentLocale = new Locale(langVariant,languageIDToTextTable[langVariant]);
         }
      }
      
      public function onMarketConfigRead() : void
      {
         this.mLocales = new Vector.<Locale>();
         switch(Peripheral.vehConfig.variantMarket)
         {
            case "ROW":
               this.mLocales.push(new Locale("ar_AE",languageIDToTextTable["ar_AE"]));
            case "ECE":
            case "TU":
               this.mLocales.push(new Locale("it_IT",languageIDToTextTable["it_IT"]));
               this.mLocales.push(new Locale("fr_FR",languageIDToTextTable["fr_FR"]));
               this.mLocales.push(new Locale("en_GB",languageIDToTextTable["en_GB"]));
               if(this.isMexSpanishROWArgentinaVariant)
               {
                  this.mLocales.push(new Locale("es_MX",languageIDToTextTable["es_MX"]));
               }
               else
               {
                  this.mLocales.push(new Locale("es_ES",languageIDToTextTable["es_ES"]));
               }
               this.mLocales.push(new Locale("pt_PT",languageIDToTextTable["pt_PT"]));
               this.mLocales.push(new Locale("de_DE",languageIDToTextTable["de_DE"]));
               this.mLocales.push(new Locale("nl_NL",languageIDToTextTable["nl_NL"]));
               this.mLocales.push(new Locale("pt_BR",languageIDToTextTable["pt_BR"]));
               this.mLocales.push(new Locale("pl_PL",languageIDToTextTable["pl_PL"]));
               this.mLocales.push(new Locale("tr_TR",languageIDToTextTable["tr_TR"]));
               this.mLocales.push(new Locale("ru_RU",languageIDToTextTable["ru_RU"]));
               break;
            case "NA":
               this.mLocales.push(new Locale("en_US",languageIDToTextTable["en_US"]));
               this.mLocales.push(new Locale("es_MX",languageIDToTextTable["es_MX"]));
               this.mLocales.push(new Locale("fr_CA",languageIDToTextTable["fr_CA"]));
               break;
            case "JP":
               this.mLocales.push(new Locale("en_US",languageIDToTextTable["en_US"]));
               this.mLocales.push(new Locale("ja_JP",languageIDToTextTable["ja_JP"]));
               break;
            case "AU":
               this.mLocales.push(new Locale("en_GB",languageIDToTextTable["en_GB"]));
               this.mLocales.push(new Locale("fr_FR",languageIDToTextTable["fr_FR"]));
               break;
            case "SA":
               this.mLocales.push(new Locale("en_GB",languageIDToTextTable["en_GB"]));
               this.mLocales.push(new Locale("es_ES",languageIDToTextTable["es_ES"]));
               break;
            case "KR":
               this.mLocales.push(new Locale("en_US",languageIDToTextTable["en_US"]));
               this.mLocales.push(new Locale("ko_KR",languageIDToTextTable["ko_KR"]));
               break;
            case "CH":
               this.mLocales.push(new Locale("en_US",languageIDToTextTable["en_US"]));
               this.mLocales.push(new Locale("zh_CN",languageIDToTextTable["zh_CN"]));
         }
         this.handleAdditionalLanguages();
      }
      
      public function getText(rid:uint) : String
      {
         var str:String = null;
         if(!this.showHexCodes)
         {
            return LocaleArchive.getInstance().getTextByResID(rid);
         }
         return rid.toString(16).toUpperCase() + ":" + LocaleArchive.getInstance().getTextByResID(rid);
      }
      
      private function onHexCodeRequest(e:HMIRequestEvent) : void
      {
         if(e.mData.getHexCode.stringBundleName in T)
         {
            Peripheral.hmiRequest.hmiSendHexCode(T[e.mData.getHexCode.stringBundleName].toString(),e.mData.getHexCode.stringBundleName);
         }
         else
         {
            Peripheral.hmiRequest.hmiSendHexCode("0",e.mData.getHexCode.stringBundleName);
         }
      }
      
      public function getShowHexCodes() : Boolean
      {
         return this.showHexCodes;
      }
      
      public function setShowHexCodes(hex:Boolean) : void
      {
         this.showHexCodes = hex;
      }
      
      public function get locales() : Vector.<Locale>
      {
         return this.mLocales;
      }
      
      public function set locale(newLocale:Locale) : void
      {
         var langVariant:String = null;
         if(this.mCurrentLocale.id != newLocale.id)
         {
            langVariant = this.validateLanguageSelection(newLocale.id);
            LocaleArchive.getInstance().setLanguage(languageIDToXMLIDTable[langVariant],languageIDToXMLIDTable[langVariant]);
            this.mCurrentLocale = new Locale(langVariant,languageIDToTextTable[langVariant]);
         }
      }
      
      public function get locale() : Locale
      {
         return this.mCurrentLocale;
      }
      
      public function setLanguageById(id:String) : void
      {
         var langVariant:String = null;
         if(this.mCurrentLocale.id != id)
         {
            langVariant = this.validateLanguageSelection(id);
            LocaleArchive.getInstance().setLanguage(languageIDToXMLIDTable[langVariant],languageIDToXMLIDTable[langVariant]);
            this.mCurrentLocale = new Locale(langVariant,languageIDToTextTable[langVariant]);
         }
      }
      
      public function isReady() : Boolean
      {
         return true;
      }
      
      private function vehicleStatusLanguageChange(e:VehicleStatusEvent) : void
      {
         if(e.mData != null && e.mData.override != null)
         {
            LocaleArchive.getInstance().setLanguage(languageIDToXMLIDTable[Peripheral.vehicleStatus.language],languageIDToXMLIDTable[Peripheral.vehicleStatus.language]);
            this.mCurrentLocale = new Locale(Peripheral.vehicleStatus.language,languageIDToTextTable[Peripheral.vehicleStatus.language]);
         }
         else
         {
            this.setLanguageById(Peripheral.vehicleStatus.language);
         }
      }
      
      private function onLanguageChange(e:Event) : void
      {
         dispatchEvent(new LocaleEvent(LocaleEvent.CHANGE));
      }
      
      private function validateLanguageSelection(languageID:String) : String
      {
         var loopCounter:int = 0;
         if(Boolean(this.mLocales) && this.mLocales != null)
         {
            for(loopCounter = 0; loopCounter < this.mLocales.length; loopCounter++)
            {
               if(this.mLocales[loopCounter].id == languageID)
               {
                  return languageID;
               }
            }
         }
         switch(Peripheral.vehConfig.variantMarket)
         {
            case "ECE":
            case "TU":
               switch(Peripheral.vehConfig.vehicleDestination)
               {
                  case "129":
                  case "7":
                     return "de_DE";
                  case "100":
                     return "it_IT";
                  case "20":
                     return "ru_RU";
                  case "71":
                     return "fr_FR";
                  default:
                     return "en_GB";
               }
               break;
            case "NA":
               switch(Peripheral.vehConfig.vehicleDestination)
               {
                  case "14":
                     return "es_MX";
                  default:
                     return "en_US";
               }
               break;
            case "AU":
               switch(Peripheral.vehConfig.vehicleDestination)
               {
                  case "73":
                     return "fr_FR";
                  default:
                     return "en_GB";
               }
               break;
            case "SA":
               switch(Peripheral.vehConfig.vehicleDestination)
               {
                  case "25":
                  case "45":
                     return "es_ES";
                  default:
                     return "en_GB";
               }
               break;
            case "ROW":
            case "KR":
            case "CH":
            case "JP":
         }
         return "en_US";
      }
      
      private function handleAdditionalLanguages() : void
      {
         var l:Locale = null;
         if(!this.hasAdditionalLanguagesFeature)
         {
            return;
         }
         for each(l in this.mLocales)
         {
            switch(l.id)
            {
               case "ru_RU":
               case "pt_BR":
                  if(Peripheral.vehConfig.additionalLanguages.indexOf(l.id) == -1)
                  {
                     this.mLocales.splice(this.mLocales.indexOf(l),1);
                  }
            }
         }
      }
      
      private function get isMexSpanishROWArgentinaVariant() : Boolean
      {
         var bResult:Boolean = false;
         if(Peripheral.vehConfig.variantMarket == "ROW")
         {
            if(Peripheral.vehConfig.vehicleDestinationName == "argentina")
            {
               if(this.VARIANT_PRODUCT == "VP3" || this.VARIANT_PRODUCT == "VP4" || this.VARIANT_PRODUCT == "MP4" || this.VARIANT_PRODUCT == "524")
               {
                  bResult = true;
               }
            }
         }
         return bResult;
      }
   }
}

