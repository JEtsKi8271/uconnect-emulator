package com.harman.navigation.tmc
{
   import com.harman.navigation.global.NavigationPackage;
   import com.harman.navigation.global.vServices.*;
   import com.harman.navigation.utils.SortableItem;
   
   public class TmcEvent extends SortableItem
   {
      
      private static var CALCULATOR:VServiceDistanceCalculator;
      
      private var mEmptyEisTypes:Array = new Array();
      
      private var eventArray:Object = {
         "<TEV>":"",
         "<TMC>":"",
         "<GEO>":"",
         "<ICON>":"",
         "<INF>":"",
         "<STR>":"",
         "<RRD>":"",
         "<MIN>":""
      };
      
      public function TmcEvent(eisString:String)
      {
         var eisType:String = null;
         var eisValue:String = null;
         super();
         var endSection:String = new String("<*>");
         while(eisString.length > 0 && eisString.indexOf(endSection) > -1)
         {
            eisType = eisString.substring(0,eisString.indexOf(">") + 1);
            eisValue = eisString.substring(eisString.indexOf(">") + 1,eisString.indexOf(endSection));
            if(eisValue.length == 0)
            {
               this.mEmptyEisTypes.push(eisType);
            }
            else if(eisType == "<TXT>")
            {
               if(String(this.eventArray["<STR>"]).indexOf(eisValue) == -1)
               {
                  this.eventArray["<STR>"] = String(this.eventArray["<STR>"]).replace("%s",eisValue);
               }
               else
               {
                  this.eventArray["<STR>"] = String(this.eventArray["<STR>"]).replace("%s","");
               }
            }
            else if(eisType == "<STR>")
            {
               if(this.eventArray["<STR>"] != "")
               {
                  if(this.eventArray["<STR>"] == "%s")
                  {
                     eisValue = eisValue.replace("%s",String(this.eventArray["<STR>"]));
                  }
                  this.eventArray[eisType] = eisValue;
               }
               else
               {
                  this.eventArray[eisType] = eisValue;
               }
               this.removeFromEmptyEisTypes(eisValue);
            }
            else
            {
               this.eventArray[eisType] = eisValue;
               this.removeFromEmptyEisTypes(eisValue);
            }
            eisString = eisString.slice(eisString.indexOf(endSection) + 3,eisString.length + 1);
         }
      }
      
      private static function get calculator() : VServiceDistanceCalculator
      {
         if(CALCULATOR == null)
         {
            CALCULATOR = new VServiceDistanceCalculator();
         }
         return CALCULATOR;
      }
      
      public static function geoStringToLatLong(geoStr:String) : Array
      {
         return [Number(geoStr.substring(geoStr.indexOf(" ") + 1,geoStr.length - 1)),Number(geoStr.substring(0,geoStr.indexOf(" ")))];
      }
      
      override public function get label() : String
      {
         var lbl:String = this.getType("<STR>");
         if(lbl == null || lbl.length == 0)
         {
            lbl = this.getType("<CTY>");
            if(lbl == null || lbl.length == 0)
            {
               lbl = this.getType("<GEO>");
            }
         }
         return lbl;
      }
      
      public function get message() : String
      {
         return this.getType("<TMC>");
      }
      
      public function compareDistanceTo(evt2:TmcEvent) : int
      {
         var dist1:Number = this.distanceCurrentUnits;
         var dist2:Number = evt2.distanceCurrentUnits;
         if(dist1 < dist2)
         {
            return -1;
         }
         if(dist1 > dist2)
         {
            return 1;
         }
         return 0;
      }
      
      public function get position() : String
      {
         return this.getType("<GEO>");
      }
      
      public function get distanceString() : String
      {
         return calculator.getDistanceToPositionString(this.position);
      }
      
      public function get distanceCurrentUnits() : Number
      {
         return calculator.getDistanceToPosition(this.position);
      }
      
      public function get directionTo() : int
      {
         var srcLatLon:Array = null;
         var destLatLon:Array = null;
         var relPosition:int = 0;
         var distance_VP_DEST:Number = NaN;
         var compareLatitude:Number = NaN;
         var compareLongitude:Number = NaN;
         var distance_CP_VP:Number = NaN;
         var distance_CP_DEST:Number = NaN;
         var vehicleDirectionNew:Number = NaN;
         var angle:Number = NaN;
         if(this.position != "")
         {
            srcLatLon = geoStringToLatLong(NavigationPackage.peripheral.navigation.navigation.posPositionInformation.getType("<GEO>"));
            destLatLon = geoStringToLatLong(this.position);
            relPosition = VServiceDirectionTracker.getRelativePosition(srcLatLon[0],srcLatLon[1],destLatLon[0],destLatLon[1]);
            distance_VP_DEST = Math.sqrt(Math.pow(destLatLon[0] - srcLatLon[0],2) + Math.pow(destLatLon[1] - srcLatLon[1],2));
            compareLatitude = srcLatLon[0] + distance_VP_DEST;
            compareLongitude = Number(srcLatLon[1]);
            distance_CP_VP = compareLatitude - srcLatLon[0];
            distance_CP_DEST = Math.sqrt(Math.pow(destLatLon[0] - compareLatitude,2) + Math.pow(destLatLon[1] - compareLongitude,2));
            vehicleDirectionNew = Number(NavigationPackage.peripheral.navigation.navigation.posPositionInformation.getType("<DIR>")) / 255 * 360;
            angle = VServiceDirectionTracker.calcDestinationDirection(relPosition,vehicleDirectionNew,VServiceDirectionTracker.calcAngleC(distance_CP_VP,distance_VP_DEST,distance_CP_DEST));
            return VServiceDistanceListController.getImageIdForAngle(angle);
         }
         return -1;
      }
      
      public function getType(eisType:String) : String
      {
         return this.eventArray[eisType];
      }
      
      public function getZoomInfo() : String
      {
         var info:String = "";
         if(this.getType("<TMC>") != null)
         {
            info += "<TMC>" + this.getType("<TMC>") + "<*>";
         }
         if(this.getType("<TEV>") != null)
         {
            info += "<TEV>" + this.getType("<TEV>") + "<*>";
         }
         if(this.getType("<GEO>") != null)
         {
            info += "<GEO>" + this.getType("<GEO>") + "<*>";
         }
         if(this.getType("<TID>") != null)
         {
            info += "<TID>" + this.getType("<TID>") + "<*>";
         }
         return info;
      }
      
      public function get toString() : String
      {
         var ret:String = "";
         ret += " TEV: " + this.eventArray["<TEV>"];
         ret += "\nTMC " + this.eventArray["<TMC>"];
         ret += "\nGEO " + this.eventArray["<GEO>"];
         ret += "\nINF " + this.eventArray["<INF>"];
         ret += "\nSTR " + this.eventArray["<STR>"];
         ret += "\nRRD " + this.eventArray["<RRD>"];
         ret += "\nMIN " + this.eventArray["<MIN>"];
         ret += "\nICON " + this.eventArray["<ICON>"];
         ret += "\n Empty: ";
         for(var i:int = 0; i < this.mEmptyEisTypes.length; i++)
         {
            ret += this.mEmptyEisTypes[i] + ", ";
         }
         return ret;
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
   }
}

