package com.harman.navigation.Controller.Trips.util
{
   import com.harman.navigation.DomainControl.NavGlobalSettings;
   import com.harman.navigation.utils.LocationDescription;
   import com.harman.navigation.utils.LocationDetails;
   import com.nfuzion.framework.global.Framework;
   
   public class Trip
   {
      
      private var mName:String = "";
      
      private var mDestinations:Array = new Array();
      
      public function Trip()
      {
         super();
      }
      
      public function setName(name:String) : void
      {
         this.mName = name;
      }
      
      public function getName() : String
      {
         return this.mName;
      }
      
      public function getDestinations() : Array
      {
         return this.mDestinations;
      }
      
      public function addDestination(loc:LocationDescription) : void
      {
         this.mDestinations.push(loc);
      }
      
      public function moveToPosition(index:int, newIndex:int) : void
      {
         if(index < 0 || this.mDestinations.length < index)
         {
            Framework.Trace("Trips.moveToPosition( " + index + ", " + newIndex + " ) invalid index (" + this.mDestinations.length + ")");
            return;
         }
         var tmp:LocationDescription = LocationDescription(this.mDestinations[index]);
         this.mDestinations.splice(index,1);
         this.mDestinations.splice(newIndex,0,tmp);
      }
      
      public function removeDestination(index:int) : void
      {
         this.mDestinations.splice(index,1);
      }
      
      public function removeAllDestination() : void
      {
         this.mDestinations.splice(0,this.mDestinations.length);
      }
      
      public function setDestinationsCustomName(index:int, name:String) : void
      {
         LocationDescription(this.mDestinations[index]).getPrimaryLocation().setCustomName(name);
         LocationDescription(this.mDestinations[index]).getSecondaryLocation().setCustomName(name);
      }
      
      public function setDestinationsPhoneNumber(index:int, number:String) : void
      {
         if(index < this.mDestinations.length && index >= 0)
         {
            LocationDescription(this.mDestinations[index]).getPrimaryLocation().addType("<TEL>",number);
         }
         else
         {
            Framework.Trace("Trips.setDestinationsPhoneNumber( " + index + ", " + number + ") invalid index!");
         }
      }
      
      public function toPersistence() : Object
      {
         var pers:Object = new Object();
         pers["title"] = this.mName;
         for(var i:int = 0; i < this.mDestinations.length; i++)
         {
            if(this.mDestinations[i] != null)
            {
               pers[i + "_pri"] = LocationDescription(this.mDestinations[i]).getPrimaryLocation().getPersistenceString();
               pers[i + "_sec"] = LocationDescription(this.mDestinations[i]).getSecondaryLocation().getPersistenceString();
            }
         }
         return pers;
      }
      
      public function fromPersistence(res:Object) : void
      {
         var index:int = 0;
         var i:String = null;
         var locDet1:LocationDetails = null;
         var tmp1:LocationDescription = null;
         var locDet2:LocationDetails = null;
         var tmp2:LocationDescription = null;
         if(res != null)
         {
            this.initiallizeTrip();
            index = 0;
            for(i in res)
            {
               index = int(i.substr(0,i.indexOf("_")));
               if(i.indexOf("_pri") != -1)
               {
                  locDet1 = new LocationDetails();
                  locDet1.setFromPersistenceString(res[i]);
                  tmp1 = LocationDescription(this.mDestinations[index]);
                  if(tmp1 == null)
                  {
                     tmp1 = new LocationDescription();
                  }
                  tmp1.setPrimaryLocation(locDet1);
                  this.mDestinations.splice(index,1,tmp1);
               }
               else if(i.indexOf("_sec") != -1)
               {
                  locDet2 = new LocationDetails();
                  locDet2.setFromPersistenceString(res[i]);
                  tmp2 = LocationDescription(this.mDestinations[index]);
                  if(tmp2 == null)
                  {
                     tmp2 = new LocationDescription();
                  }
                  tmp2.setSecondaryLocation(locDet2);
                  this.mDestinations.splice(index,1,tmp2);
               }
               else if(i.indexOf("title") != -1)
               {
                  this.setName(String(res[i]));
               }
            }
            this.finalizeTrip();
         }
      }
      
      private function initiallizeTrip() : void
      {
         for(var i:int = 0; i < NavGlobalSettings.TRIPS_MAX_DESTINATIONS; i++)
         {
            this.mDestinations[i] = null;
         }
      }
      
      private function finalizeTrip() : void
      {
         for(var i:* = int(this.mDestinations.length - 1); i >= 0; i--)
         {
            if(this.mDestinations[i] == null)
            {
               this.mDestinations.splice(i,1);
            }
         }
      }
   }
}

