package com.harman.navigation.Controller.Trips
{
   import com.harman.navigation.Controller.Persistence.PersistenceApi;
   import com.harman.navigation.Controller.Persistence.PersistenceEvent;
   import com.harman.navigation.Controller.Persistence.PersistenceImpl;
   import com.harman.navigation.Controller.Persistence.PersistenceKeys;
   import com.harman.navigation.Controller.Trips.util.Trip;
   import com.harman.navigation.DomainControl.NavGlobalSettings;
   import com.harman.navigation.NavigationNamespace;
   import com.harman.navigation.global.NavigationPackage;
   import com.harman.navigation.utils.LocationDescription;
   import com.nfuzion.framework.global.Framework;
   import flash.events.EventDispatcher;
   
   use namespace NavigationNamespace;
   
   public class TripsController extends EventDispatcher implements ITrips
   {
      
      private var mTripsArray:Array = new Array();
      
      private var mSelectedTrip:int = -1;
      
      private var mSelectedDestination:int = -1;
      
      private var mPersistenceCount:int = 0;
      
      private var mImportExportInProgress:Boolean = false;
      
      public function TripsController()
      {
         super();
         PersistenceApi.impl = PersistenceImpl.create();
         PersistenceApi.api.addEventListener(PersistenceEvent.PERS_DATA_LOADED,this.onPersistence,false,0,true);
         PersistenceApi.api.loadData(PersistenceKeys.TRIPS_00);
         PersistenceApi.api.loadData(PersistenceKeys.TRIPS_01);
         PersistenceApi.api.loadData(PersistenceKeys.TRIPS_02);
         PersistenceApi.api.loadData(PersistenceKeys.TRIPS_03);
         PersistenceApi.api.loadData(PersistenceKeys.TRIPS_04);
         PersistenceApi.api.loadData(PersistenceKeys.TRIPS_05);
         PersistenceApi.api.loadData(PersistenceKeys.TRIPS_06);
         PersistenceApi.api.loadData(PersistenceKeys.TRIPS_07);
         PersistenceApi.api.loadData(PersistenceKeys.TRIPS_08);
         PersistenceApi.api.loadData(PersistenceKeys.TRIPS_09);
         PersistenceApi.api.loadData(PersistenceKeys.TRIPS_10);
         PersistenceApi.api.loadData(PersistenceKeys.TRIPS_11);
      }
      
      public function getTripsIsBusy() : void
      {
         this.sendEvent(TripsEvent.TRIPS_BUSY);
      }
      
      public function get tripsIsBusy() : Boolean
      {
         return false;
      }
      
      public function selectTrip(index:int) : void
      {
         this.mSelectedTrip = index;
      }
      
      public function get selectedTrip() : int
      {
         return this.mSelectedTrip;
      }
      
      public function selectDestination(index:int) : void
      {
         this.mSelectedDestination = index;
      }
      
      public function get selectedDestination() : int
      {
         return this.mSelectedDestination;
      }
      
      public function getTrips() : void
      {
         this.sendEvent(TripsEvent.TRIPS_UPDATED);
      }
      
      public function get trips() : Array
      {
         return this.mTripsArray;
      }
      
      public function tripCreate(name:String, allowDuplicateNames:Boolean) : int
      {
         var i:int = 0;
         if(this.mTripsArray.length >= NavGlobalSettings.TRIPS_MAX_TRIPS)
         {
            return -1;
         }
         if(name == null || name == "")
         {
            return -2;
         }
         if(!allowDuplicateNames)
         {
            for(i = 0; i < this.mTripsArray.length; i++)
            {
               if(Trip(this.mTripsArray[i]).getName() == name)
               {
                  return -2;
               }
            }
         }
         var newTrip:Trip = new Trip();
         newTrip.setName(name);
         this.mTripsArray.push(newTrip);
         this.persistData(this.mTripsArray.length - 1);
         this.sendEvent(TripsEvent.TRIPS_UPDATED);
         return this.mTripsArray.length - 1;
      }
      
      public function tripRename(index:int, name:String, allowDuplicateNames:Boolean) : Boolean
      {
         var i:int = 0;
         if(name == null || name == "")
         {
            return false;
         }
         if(index < 0 || this.mTripsArray.length < index)
         {
            return false;
         }
         if(!allowDuplicateNames)
         {
            for(i = 0; i < this.mTripsArray.length; i++)
            {
               if(Trip(this.mTripsArray[i]).getName() == name)
               {
                  return false;
               }
            }
         }
         Trip(this.mTripsArray[index]).setName(name);
         this.persistData(index);
         this.sendEvent(TripsEvent.TRIPS_UPDATED);
         return true;
      }
      
      public function tripDelete(index:int) : void
      {
         this.mTripsArray.splice(index,1);
         this.persistData(-1);
         this.sendEvent(TripsEvent.TRIPS_UPDATED);
      }
      
      public function tripDeleteAll() : void
      {
         this.mTripsArray.splice(0,this.mTripsArray.length);
         this.persistData(-1);
         this.sendEvent(TripsEvent.TRIPS_UPDATED);
      }
      
      public function tripMoveToPosition(index:int, newIndex:int) : void
      {
         if(index < 0 || this.mTripsArray.length < index)
         {
            Framework.Trace("TripsController.tripMoveToPosition( " + index + ", " + newIndex + " ) invalid index (" + this.mTripsArray.length + ")");
            return;
         }
         var tmp:Trip = Trip(this.mTripsArray[index]);
         this.mTripsArray.splice(index,1);
         this.mTripsArray.splice(newIndex,0,tmp);
         this.persistData(-1);
         this.sendEvent(TripsEvent.TRIPS_UPDATED);
      }
      
      public function destinationAdd(trip:int, loc:LocationDescription) : void
      {
         Trip(this.mTripsArray[trip]).addDestination(loc);
         this.persistData(trip);
         this.sendEvent(TripsEvent.TRIPS_UPDATED);
      }
      
      public function startGuidanceTo(trip:int, destination:int) : void
      {
      }
      
      public function destinationSetName(trip:int, destination:int, name:String) : void
      {
         Trip(this.mTripsArray[trip]).setDestinationsCustomName(destination,name);
         this.persistData(trip);
         this.sendEvent(TripsEvent.TRIPS_UPDATED);
      }
      
      public function destinationSetPhoneNumber(trip:int, destination:int, number:String) : void
      {
         Trip(this.mTripsArray[trip]).setDestinationsPhoneNumber(destination,number);
         this.persistData(trip);
         this.sendEvent(TripsEvent.TRIPS_UPDATED);
      }
      
      public function destinationMoveToPosition(trip:int, destination:int, newIndex:int) : void
      {
         Framework.Trace("Trip.destinationMoveToPosition( " + trip + ", " + destination + ", " + newIndex + " )");
         Trip(this.mTripsArray[trip]).moveToPosition(destination,newIndex);
         this.persistData(trip);
         this.sendEvent(TripsEvent.TRIPS_UPDATED);
      }
      
      public function destinationRemove(trip:int, destination:int) : void
      {
         Framework.Trace("Trip.destinationRemove( " + trip + ", " + destination + " )");
         Trip(this.mTripsArray[trip]).removeDestination(destination);
         this.persistData(trip);
         this.sendEvent(TripsEvent.TRIPS_UPDATED);
      }
      
      public function destinationRemoveAll(trip:int) : void
      {
         Framework.Trace("Trip.destinationRemove( " + trip + " )");
         Trip(this.mTripsArray[trip]).removeAllDestination();
         this.persistData(trip);
         this.sendEvent(TripsEvent.TRIPS_UPDATED);
      }
      
      private function onPersistence(e:PersistenceEvent) : void
      {
         var res:Object = null;
         var newTrip:Trip = null;
         var tmp:String = PersistenceApi.api.dataLoaded;
         if(tmp == PersistenceKeys.TRIPS_00 || tmp == PersistenceKeys.TRIPS_01 || tmp == PersistenceKeys.TRIPS_02 || tmp == PersistenceKeys.TRIPS_03 || tmp == PersistenceKeys.TRIPS_04 || tmp == PersistenceKeys.TRIPS_05 || tmp == PersistenceKeys.TRIPS_06 || tmp == PersistenceKeys.TRIPS_07 || tmp == PersistenceKeys.TRIPS_08 || tmp == PersistenceKeys.TRIPS_09 || tmp == PersistenceKeys.TRIPS_10 || tmp == PersistenceKeys.TRIPS_11)
         {
            if(tmp == PersistenceKeys.TRIPS_00)
            {
               res = PersistenceApi.api.getDataLoaded(PersistenceKeys.TRIPS_00,true);
            }
            else if(tmp == PersistenceKeys.TRIPS_01)
            {
               res = PersistenceApi.api.getDataLoaded(PersistenceKeys.TRIPS_01,true);
            }
            else if(tmp == PersistenceKeys.TRIPS_02)
            {
               res = PersistenceApi.api.getDataLoaded(PersistenceKeys.TRIPS_02,true);
            }
            else if(tmp == PersistenceKeys.TRIPS_03)
            {
               res = PersistenceApi.api.getDataLoaded(PersistenceKeys.TRIPS_03,true);
            }
            else if(tmp == PersistenceKeys.TRIPS_04)
            {
               res = PersistenceApi.api.getDataLoaded(PersistenceKeys.TRIPS_04,true);
            }
            else if(tmp == PersistenceKeys.TRIPS_05)
            {
               res = PersistenceApi.api.getDataLoaded(PersistenceKeys.TRIPS_05,true);
            }
            else if(tmp == PersistenceKeys.TRIPS_06)
            {
               res = PersistenceApi.api.getDataLoaded(PersistenceKeys.TRIPS_06,true);
            }
            else if(tmp == PersistenceKeys.TRIPS_07)
            {
               res = PersistenceApi.api.getDataLoaded(PersistenceKeys.TRIPS_07,true);
            }
            else if(tmp == PersistenceKeys.TRIPS_08)
            {
               res = PersistenceApi.api.getDataLoaded(PersistenceKeys.TRIPS_08,true);
            }
            else if(tmp == PersistenceKeys.TRIPS_09)
            {
               res = PersistenceApi.api.getDataLoaded(PersistenceKeys.TRIPS_09,true);
            }
            else if(tmp == PersistenceKeys.TRIPS_10)
            {
               res = PersistenceApi.api.getDataLoaded(PersistenceKeys.TRIPS_10,true);
            }
            else if(tmp == PersistenceKeys.TRIPS_11)
            {
               res = PersistenceApi.api.getDataLoaded(PersistenceKeys.TRIPS_11,true);
            }
            newTrip = new Trip();
            newTrip.fromPersistence(res);
            if(newTrip.getName() != "")
            {
               this.mTripsArray.push(newTrip);
            }
            this.mPersistenceCount += 1;
            if(this.mPersistenceCount >= NavGlobalSettings.TRIPS_MAX_TRIPS)
            {
               PersistenceApi.api.removeEventListener(PersistenceEvent.PERS_DATA_LOADED,this.onPersistence);
            }
         }
      }
      
      private function persistData(index:int) : void
      {
         var i:int = 0;
         var obj:Object = new Object();
         if(index == -1)
         {
            if(Trip(this.mTripsArray[0]) != null)
            {
               PersistenceApi.api.saveData(PersistenceKeys.TRIPS_00,Trip(this.mTripsArray[0]).toPersistence());
            }
            else
            {
               PersistenceApi.api.saveData(PersistenceKeys.TRIPS_00,new Object());
            }
            if(Trip(this.mTripsArray[1]) != null)
            {
               PersistenceApi.api.saveData(PersistenceKeys.TRIPS_01,Trip(this.mTripsArray[1]).toPersistence());
            }
            else
            {
               PersistenceApi.api.saveData(PersistenceKeys.TRIPS_01,new Object());
            }
            if(Trip(this.mTripsArray[2]) != null)
            {
               PersistenceApi.api.saveData(PersistenceKeys.TRIPS_02,Trip(this.mTripsArray[2]).toPersistence());
            }
            else
            {
               PersistenceApi.api.saveData(PersistenceKeys.TRIPS_02,new Object());
            }
            if(Trip(this.mTripsArray[3]) != null)
            {
               PersistenceApi.api.saveData(PersistenceKeys.TRIPS_03,Trip(this.mTripsArray[3]).toPersistence());
            }
            else
            {
               PersistenceApi.api.saveData(PersistenceKeys.TRIPS_03,new Object());
            }
            if(Trip(this.mTripsArray[4]) != null)
            {
               PersistenceApi.api.saveData(PersistenceKeys.TRIPS_04,Trip(this.mTripsArray[4]).toPersistence());
            }
            else
            {
               PersistenceApi.api.saveData(PersistenceKeys.TRIPS_04,new Object());
            }
            if(Trip(this.mTripsArray[5]) != null)
            {
               PersistenceApi.api.saveData(PersistenceKeys.TRIPS_05,Trip(this.mTripsArray[5]).toPersistence());
            }
            else
            {
               PersistenceApi.api.saveData(PersistenceKeys.TRIPS_05,new Object());
            }
            if(Trip(this.mTripsArray[6]) != null)
            {
               PersistenceApi.api.saveData(PersistenceKeys.TRIPS_06,Trip(this.mTripsArray[6]).toPersistence());
            }
            else
            {
               PersistenceApi.api.saveData(PersistenceKeys.TRIPS_06,new Object());
            }
            if(Trip(this.mTripsArray[7]) != null)
            {
               PersistenceApi.api.saveData(PersistenceKeys.TRIPS_07,Trip(this.mTripsArray[7]).toPersistence());
            }
            else
            {
               PersistenceApi.api.saveData(PersistenceKeys.TRIPS_07,new Object());
            }
            if(Trip(this.mTripsArray[8]) != null)
            {
               PersistenceApi.api.saveData(PersistenceKeys.TRIPS_08,Trip(this.mTripsArray[8]).toPersistence());
            }
            else
            {
               PersistenceApi.api.saveData(PersistenceKeys.TRIPS_08,new Object());
            }
            if(Trip(this.mTripsArray[9]) != null)
            {
               PersistenceApi.api.saveData(PersistenceKeys.TRIPS_09,Trip(this.mTripsArray[9]).toPersistence());
            }
            else
            {
               PersistenceApi.api.saveData(PersistenceKeys.TRIPS_09,new Object());
            }
            if(Trip(this.mTripsArray[10]) != null)
            {
               PersistenceApi.api.saveData(PersistenceKeys.TRIPS_10,Trip(this.mTripsArray[10]).toPersistence());
            }
            else
            {
               PersistenceApi.api.saveData(PersistenceKeys.TRIPS_10,new Object());
            }
            if(Trip(this.mTripsArray[11]) != null)
            {
               PersistenceApi.api.saveData(PersistenceKeys.TRIPS_11,Trip(this.mTripsArray[11]).toPersistence());
            }
            else
            {
               PersistenceApi.api.saveData(PersistenceKeys.TRIPS_11,new Object());
            }
         }
         else
         {
            switch(index)
            {
               case 0:
                  if(Trip(this.mTripsArray[index]) != null)
                  {
                     PersistenceApi.api.saveData(PersistenceKeys.TRIPS_00,Trip(this.mTripsArray[index]).toPersistence());
                  }
                  else
                  {
                     PersistenceApi.api.saveData(PersistenceKeys.TRIPS_00,new Object());
                  }
                  break;
               case 1:
                  if(Trip(this.mTripsArray[index]) != null)
                  {
                     PersistenceApi.api.saveData(PersistenceKeys.TRIPS_01,Trip(this.mTripsArray[index]).toPersistence());
                  }
                  else
                  {
                     PersistenceApi.api.saveData(PersistenceKeys.TRIPS_01,new Object());
                  }
                  break;
               case 2:
                  if(Trip(this.mTripsArray[index]) != null)
                  {
                     PersistenceApi.api.saveData(PersistenceKeys.TRIPS_02,Trip(this.mTripsArray[index]).toPersistence());
                  }
                  else
                  {
                     PersistenceApi.api.saveData(PersistenceKeys.TRIPS_02,new Object());
                  }
                  break;
               case 3:
                  if(Trip(this.mTripsArray[index]) != null)
                  {
                     PersistenceApi.api.saveData(PersistenceKeys.TRIPS_03,Trip(this.mTripsArray[index]).toPersistence());
                  }
                  else
                  {
                     PersistenceApi.api.saveData(PersistenceKeys.TRIPS_03,new Object());
                  }
                  break;
               case 4:
                  if(Trip(this.mTripsArray[index]) != null)
                  {
                     PersistenceApi.api.saveData(PersistenceKeys.TRIPS_04,Trip(this.mTripsArray[index]).toPersistence());
                  }
                  else
                  {
                     PersistenceApi.api.saveData(PersistenceKeys.TRIPS_04,new Object());
                  }
                  break;
               case 5:
                  if(Trip(this.mTripsArray[index]) != null)
                  {
                     PersistenceApi.api.saveData(PersistenceKeys.TRIPS_05,Trip(this.mTripsArray[index]).toPersistence());
                  }
                  else
                  {
                     PersistenceApi.api.saveData(PersistenceKeys.TRIPS_05,new Object());
                  }
                  break;
               case 6:
                  if(Trip(this.mTripsArray[index]) != null)
                  {
                     PersistenceApi.api.saveData(PersistenceKeys.TRIPS_06,Trip(this.mTripsArray[index]).toPersistence());
                  }
                  else
                  {
                     PersistenceApi.api.saveData(PersistenceKeys.TRIPS_06,new Object());
                  }
                  break;
               case 7:
                  if(Trip(this.mTripsArray[index]) != null)
                  {
                     PersistenceApi.api.saveData(PersistenceKeys.TRIPS_07,Trip(this.mTripsArray[index]).toPersistence());
                  }
                  else
                  {
                     PersistenceApi.api.saveData(PersistenceKeys.TRIPS_07,new Object());
                  }
                  break;
               case 8:
                  if(Trip(this.mTripsArray[index]) != null)
                  {
                     PersistenceApi.api.saveData(PersistenceKeys.TRIPS_08,Trip(this.mTripsArray[index]).toPersistence());
                  }
                  else
                  {
                     PersistenceApi.api.saveData(PersistenceKeys.TRIPS_08,new Object());
                  }
                  break;
               case 9:
                  if(Trip(this.mTripsArray[index]) != null)
                  {
                     PersistenceApi.api.saveData(PersistenceKeys.TRIPS_09,Trip(this.mTripsArray[index]).toPersistence());
                  }
                  else
                  {
                     PersistenceApi.api.saveData(PersistenceKeys.TRIPS_09,new Object());
                  }
                  break;
               case 10:
                  if(Trip(this.mTripsArray[index]) != null)
                  {
                     PersistenceApi.api.saveData(PersistenceKeys.TRIPS_10,Trip(this.mTripsArray[index]).toPersistence());
                  }
                  else
                  {
                     PersistenceApi.api.saveData(PersistenceKeys.TRIPS_10,new Object());
                  }
                  break;
               case 11:
                  if(Trip(this.mTripsArray[index]) != null)
                  {
                     PersistenceApi.api.saveData(PersistenceKeys.TRIPS_11,Trip(this.mTripsArray[index]).toPersistence());
                  }
                  else
                  {
                     PersistenceApi.api.saveData(PersistenceKeys.TRIPS_11,new Object());
                  }
            }
         }
      }
      
      public function isImportExportInProgress() : void
      {
         this.sendEvent(TripsEvent.TRIPS_IMPORT_EXPORT_IN_PROGRESS);
      }
      
      public function get importExportInProgress() : Boolean
      {
         return this.mImportExportInProgress;
      }
      
      public function exportTrips() : void
      {
         this.mImportExportInProgress = true;
         this.sendEvent(TripsEvent.TRIPS_IMPORT_EXPORT_IN_PROGRESS);
         for(var i:int = 0; i < this.mTripsArray.length; i++)
         {
            NavigationPackage.peripheral.navigation.navigation.writeObjectToFile(NavGlobalSettings.TRIPS_EXPORT_DIRECTORY + NavGlobalSettings.TRIPS_EXPORT_BASE_NAME + i + NavGlobalSettings.TRIPS_EXPORT_NAME_EXTENSION,Object(Trip(this.mTripsArray[i]).toPersistence()));
         }
         this.mImportExportInProgress = false;
         this.sendEvent(TripsEvent.TRIPS_IMPORT_EXPORT_IN_PROGRESS);
      }
      
      public function importTrips() : void
      {
         var obj:Object = null;
         var newTrip:Trip = null;
         this.mImportExportInProgress = true;
         this.sendEvent(TripsEvent.TRIPS_IMPORT_EXPORT_IN_PROGRESS);
         var stopReading:Boolean = false;
         for(var i:int = 0; stopReading != true; i++)
         {
            obj = NavigationPackage.peripheral.navigation.navigation.readObjectFromFile(NavGlobalSettings.TRIPS_EXPORT_DIRECTORY + NavGlobalSettings.TRIPS_EXPORT_BASE_NAME + i + NavGlobalSettings.TRIPS_EXPORT_NAME_EXTENSION);
            newTrip = new Trip();
            newTrip.fromPersistence(obj);
            if(obj != null)
            {
               if(newTrip != null)
               {
                  if(newTrip.getName() != "")
                  {
                     if(i == 0)
                     {
                        this.mTripsArray.splice(0,this.mTripsArray.length);
                     }
                     this.mTripsArray.push(newTrip);
                  }
               }
            }
            else
            {
               stopReading = true;
            }
         }
         this.persistData(-1);
         this.mImportExportInProgress = false;
         this.sendEvent(TripsEvent.TRIPS_IMPORT_EXPORT_IN_PROGRESS);
         this.sendEvent(TripsEvent.TRIPS_UPDATED);
      }
      
      private function sendEvent(eventType:String) : void
      {
         dispatchEvent(new TripsEvent(eventType));
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

