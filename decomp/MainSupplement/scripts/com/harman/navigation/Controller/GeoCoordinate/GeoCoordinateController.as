package com.harman.navigation.Controller.GeoCoordinate
{
   import com.harman.navigation.Controller.GeoCoordinate.util.GeoFormatCheck;
   import com.harman.navigation.Controller.GeoCoordinate.util.GeoFormatDD;
   import com.harman.navigation.Controller.GeoCoordinate.util.GeoFormatDM;
   import com.harman.navigation.Controller.GeoCoordinate.util.GeoFormatDMS;
   import com.harman.navigation.Controller.GeoCoordinate.util.GeoFormats;
   import com.harman.navigation.Controller.GeoCoordinate.util.IGeoFormat;
   import com.harman.navigation.Controller.Persistence.PersistenceApi;
   import com.harman.navigation.Controller.Persistence.PersistenceEvent;
   import com.harman.navigation.Controller.Persistence.PersistenceKeys;
   import com.harman.navigation.DomainControl.NavGlobalSettings;
   import com.harman.navigation.NavigationApi;
   import com.harman.navigation.NavigationEvent;
   import com.harman.navigation.NavigationImpl;
   import com.harman.navigation.NavigationNamespace;
   import com.harman.navigation.global.NavigationPackage;
   import com.nfuzion.framework.global.Framework;
   import com.nfuzion.moduleLink.Connection;
   import com.nfuzion.span.Client;
   import flash.events.EventDispatcher;
   
   use namespace NavigationNamespace;
   
   public class GeoCoordinateController extends EventDispatcher implements IGeoCoordinate
   {
      
      private var connection:Connection;
      
      private var client:Client;
      
      private var mExtension:IGeoFormat = null;
      
      public function GeoCoordinateController()
      {
         super();
         this.reformat(NavGlobalSettings.GEO_COORDINATE_SPELLER_DEFAULT_FORMAT,false);
         PersistenceApi.api.addEventListener(PersistenceEvent.PERS_DATA_LOADED,this.onPersistence,false,0,true);
         PersistenceApi.api.loadData(PersistenceKeys.GEO_ENTRY_FORMAT);
         NavigationApi.impl = NavigationImpl.create();
         NavigationApi.api.addEventListener(NavigationEvent.POS_POSITIONINFORMATION,this.onPositionInfo,false,0,true);
      }
      
      public function setCoordinateEntryType(type:int) : void
      {
         if(this.mExtension != null)
         {
            Framework.Trace("GeoCoordinateController.setCoordinateEntryType( " + type + " )");
            this.mExtension.setCoordinateType(type);
            this.mExtension.setCursorPosition(0);
         }
         else
         {
            Framework.Trace("GeoCoordinateController.setCoordinateEntryType( " + type + " ) mExtension == null !");
         }
         this.sendEvent(GeoCoordinateEvent.GEO_CURRENT_COORDINATE_TYPE);
         this.sendEvent(GeoCoordinateEvent.GEO_AVAILABLE_CHARACTERS);
         this.sendEvent(GeoCoordinateEvent.GEO_CURSOR_POSITION);
      }
      
      public function getCoordinateEntryType() : void
      {
         this.sendEvent(GeoCoordinateEvent.GEO_CURRENT_COORDINATE_TYPE);
      }
      
      public function get coordinateEntryType() : int
      {
         if(this.mExtension != null)
         {
            return this.mExtension.coordinateType;
         }
         Framework.Trace("GeoCoordinateController.coordinateEntryType: mExtension == null !");
         return -1;
      }
      
      public function getCurrentEntry() : void
      {
         this.sendEvent(GeoCoordinateEvent.GEO_CURRENT_ENTRY);
      }
      
      public function get currentEntry() : String
      {
         if(this.mExtension != null)
         {
            return this.mExtension.currentEntry;
         }
         Framework.Trace("GeoCoordinateController.currentEntry: mExtension == null !");
         return "";
      }
      
      public function setFormat(format:int) : void
      {
         this.reformat(format,true);
      }
      
      public function reformat(format:int, persistChange:Boolean) : void
      {
         var tmpLat:String = null;
         var tmpLong:String = null;
         Framework.Trace("GeoCoordinateController.setFormat( " + format + " )");
         if(this.mExtension == null || this.mExtension.formatID != format)
         {
            tmpLat = "+00.000000°";
            tmpLong = "-000.000000°";
            if(this.mExtension != null)
            {
               tmpLat = "" + this.mExtension.latitudeAsDD;
               tmpLong = "" + this.mExtension.longitudeAsDD;
               Framework.Trace("-> ( " + tmpLat + " " + tmpLong + " ) " + this.mExtension.formatID);
            }
            switch(format)
            {
               case GeoFormats.FORMAT_DMS:
                  this.mExtension = new GeoFormatDMS(GeoFormats.FORMAT_DMS);
                  break;
               case GeoFormats.FORMAT_DM:
                  this.mExtension = new GeoFormatDM(GeoFormats.FORMAT_DM);
                  break;
               case GeoFormats.FORMAT_DD:
                  this.mExtension = new GeoFormatDD(GeoFormats.FORMAT_DD);
                  break;
               default:
                  Framework.Trace(" Unknown format !");
                  this.mExtension = null;
            }
            if(this.mExtension == null)
            {
               Framework.Trace("GeoCoordinateController.setFormat( " + format + " ) mExtension == null !");
            }
            else
            {
               this.mExtension.importGeoEntry(GeoFormatCheck.checkDDLatitudeStringConsistency(tmpLat),GeoFormatCheck.checkDDLongitudeStringConsistency(tmpLong));
               if(persistChange)
               {
                  this.toPersistence();
               }
            }
            this.sendEvent(GeoCoordinateEvent.GEO_FORMAT);
            this.sendEvent(GeoCoordinateEvent.GEO_CURRENT_COORDINATE_TYPE);
            this.sendEvent(GeoCoordinateEvent.GEO_AVAILABLE_CHARACTERS);
            this.sendEvent(GeoCoordinateEvent.GEO_CURSOR_POSITION);
         }
         else
         {
            Framework.Trace(" -> Format already set..");
         }
      }
      
      public function getFormat() : void
      {
         this.sendEvent(GeoCoordinateEvent.GEO_FORMAT);
      }
      
      public function get format() : int
      {
         if(this.mExtension != null)
         {
            return this.mExtension.formatID;
         }
         Framework.Trace("GeoCoordinateController.format: mExtension == null !");
         return -1;
      }
      
      public function setCursorPosition(pos:int) : void
      {
         if(this.mExtension != null)
         {
            Framework.Trace("GeoCoordinateController.setCursorPosition( " + pos + " )");
            this.mExtension.setCursorPosition(pos);
         }
         else
         {
            Framework.Trace("GeoCoordinateController.setCursorPosition( " + pos + " ) mExtension == null !");
         }
         this.sendEvent(GeoCoordinateEvent.GEO_CURSOR_POSITION);
         this.sendEvent(GeoCoordinateEvent.GEO_AVAILABLE_CHARACTERS);
         this.sendEvent(GeoCoordinateEvent.GEO_COORDINATE_IS_VALID);
      }
      
      public function getCursorPosition() : void
      {
         this.sendEvent(GeoCoordinateEvent.GEO_CURSOR_POSITION);
      }
      
      public function get cursorPosition() : int
      {
         if(this.mExtension != null)
         {
            return this.mExtension.cursorPosition;
         }
         Framework.Trace("GeoCoordinateController.cursorPosition: mExtension == null !");
         return -1;
      }
      
      public function get maxCursorPosition() : int
      {
         if(this.mExtension != null)
         {
            return this.mExtension.maxCursorPosition;
         }
         Framework.Trace("GeoCoordinateController.maxCursorPosition: mExtension == null !");
         return -1;
      }
      
      public function getAvailableCharacters() : void
      {
         this.sendEvent(GeoCoordinateEvent.GEO_AVAILABLE_CHARACTERS);
      }
      
      public function get availableCharacters() : String
      {
         if(this.mExtension != null)
         {
            Framework.Trace("GeoCoordinateController.availableCharacters( " + this.mExtension.availableCharacters + " )");
            return this.mExtension.availableCharacters;
         }
         Framework.Trace("GeoCoordinateController.availableCharacters: mExtension == null !");
         return "";
      }
      
      public function enterCharacter(char:String) : void
      {
         Framework.Trace("GeoCoordinateController.enterCharacter( " + char + " )");
         switch(char)
         {
            case "0":
            case "1":
            case "2":
            case "3":
            case "4":
            case "5":
            case "6":
            case "7":
            case "8":
            case "9":
            case "N":
            case "E":
            case "S":
            case "W":
            case "-":
            case "+":
               if(this.mExtension != null)
               {
                  this.mExtension.enterCharacter(char);
                  this.sendEvent(GeoCoordinateEvent.GEO_AVAILABLE_CHARACTERS);
                  this.sendEvent(GeoCoordinateEvent.GEO_CURSOR_POSITION);
                  this.sendEvent(GeoCoordinateEvent.GEO_CURRENT_ENTRY);
                  this.sendEvent(GeoCoordinateEvent.GEO_COORDINATE_IS_VALID);
               }
               return;
            default:
               Framework.Trace(" - Rejected character! ( " + char + " )");
               return;
         }
      }
      
      public function getIsValid() : void
      {
         this.sendEvent(GeoCoordinateEvent.GEO_COORDINATE_IS_VALID);
      }
      
      public function get isValid() : Boolean
      {
         if(this.mExtension != null)
         {
            return this.mExtension.checkIsValid();
         }
         Framework.Trace("GeoCoordinateController.isValid: mExtension == null !");
         return false;
      }
      
      public function getDetails() : void
      {
         if(this.mExtension != null)
         {
            this.mExtension.getDetails();
         }
         else
         {
            Framework.Trace("GeoCoordinateController.getDetails: mExtension == null !");
         }
      }
      
      public function sendEvent(eventType:String) : void
      {
         dispatchEvent(new GeoCoordinateEvent(eventType));
      }
      
      private function onPositionInfo(e:NavigationEvent) : void
      {
         var position:String = NavigationPackage.peripheral.navigation.navigation.posPositionInformation.getType("<GEO>");
         if(position != "" && this.mExtension != null)
         {
            Framework.Trace("GeoCoordinateController.onPositionInfo( " + position + " ) -> \'" + position.substr(0,position.lastIndexOf(" ")) + "\' \'" + position.substring(position.lastIndexOf(" ") + 1,position.length) + "\'");
            this.mExtension.importGeoEntry(GeoFormatCheck.checkDDLatitudeStringConsistency(position.substring(position.lastIndexOf(" ") + 1,position.length)),GeoFormatCheck.checkDDLongitudeStringConsistency(position.substr(0,position.lastIndexOf(" "))));
            NavigationPackage.peripheral.navigation.navigation.removeEventListener(NavigationEvent.POS_POSITIONINFORMATION,this.onPositionInfo);
         }
      }
      
      private function onPersistence(e:PersistenceEvent) : void
      {
         var res:Object = null;
         var index:int = 0;
         var i:String = null;
         if(PersistenceApi.api.dataLoaded == PersistenceKeys.GEO_ENTRY_FORMAT)
         {
            res = PersistenceApi.api.getDataLoaded(PersistenceKeys.GEO_ENTRY_FORMAT,true);
            if(res != null)
            {
               index = 0;
               for(i in res)
               {
                  if(i.indexOf("format") != -1)
                  {
                     Framework.Trace("GeoCoordinateController.onPersistence( " + int(res[i]) + " )");
                     this.reformat(int(res[i]),false);
                  }
               }
            }
            PersistenceApi.api.removeEventListener(PersistenceEvent.PERS_DATA_LOADED,this.onPersistence);
         }
      }
      
      public function toPersistence() : void
      {
         var pers:Object = new Object();
         if(this.mExtension != null)
         {
            pers["format"] = this.mExtension.formatID;
         }
         PersistenceApi.api.saveData(PersistenceKeys.GEO_ENTRY_FORMAT,pers);
      }
      
      public function factoryReset() : void
      {
         Framework.Trace("GeoCoordinateController.factoryReset()");
         this.reformat(NavGlobalSettings.GEO_COORDINATE_SPELLER_DEFAULT_FORMAT,true);
      }
      
      public function getAll() : void
      {
      }
      
      public function hello() : void
      {
      }
      
      public function isReady() : Boolean
      {
         return true;
      }
      
      public function addInterest(signalName:String) : void
      {
      }
      
      public function removeInterest(signalName:String) : void
      {
      }
      
      public function destroyInterest(signalName:String) : void
      {
      }
      
      public function interested(signalName:String) : Boolean
      {
         return false;
      }
      
      public function totalInterest(signalName:String) : uint
      {
         return 0;
      }
   }
}

