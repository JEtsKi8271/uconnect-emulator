package com.harman.navigation.dbService
{
   import com.harman.navigation.Controller.FavoriteDestinations.FavoriteDestination;
   import com.harman.navigation.utils.LocationDescription;
   import com.harman.navigation.utils.LocationDetails;
   import com.nfuzion.framework.global.Framework;
   
   public class DBItem
   {
      
      public static const PRIMARY_LOC:String = "PRI";
      
      public static const SECONDARY_LOC:String = "SEC";
      
      public static const LOC_STR_N:String = "<LOC>";
      
      public var formattedName:String;
      
      public var lat:String;
      
      public var lon:String;
      
      public var data:String;
      
      public var navUniqueId:int = -1;
      
      public var sortIndex:int = -1;
      
      public var pinned:Boolean = false;
      
      public var phoneint:String;
      
      public var url:String;
      
      private var _mType:String;
      
      private var _bIsHome:Boolean;
      
      public function DBItem(type:String = "", item:FavoriteDestination = null)
      {
         super();
         this.reset(true);
         if(type != "")
         {
            this._mType = type;
         }
         if(item != null)
         {
            if(this.setup(item) == false)
            {
               Framework.Trace("something wrong with this item");
            }
         }
      }
      
      public function get isHome() : Boolean
      {
         return this._bIsHome;
      }
      
      public function get type() : String
      {
         return this._mType;
      }
      
      public function setType(newType:String) : void
      {
         if(newType != "")
         {
            this._mType = newType;
         }
      }
      
      public function setData(newData:String) : void
      {
         if(newData != "")
         {
            this.data = newData;
         }
      }
      
      public function isRoutable() : Boolean
      {
         if(this.lat == "" || this.lon == "")
         {
            return false;
         }
         return true;
      }
      
      public function setEntryAsHome() : void
      {
         this._bIsHome = true;
         this.formattedName = "";
      }
      
      public function setEntryNotHome() : void
      {
         this._bIsHome = false;
      }
      
      public function setItem(name:String, locdata:String, key:int, phone:String) : Boolean
      {
         if(this.data != "")
         {
            this.reset(false);
            if(name != "")
            {
               this.formattedName = name;
            }
            if(key != -1)
            {
               this.navUniqueId = key;
            }
            if(phone != "")
            {
               this.phoneint = phone;
            }
            this.setData(locdata);
            return true;
         }
         return false;
      }
      
      public function empty() : void
      {
         this.reset(false);
      }
      
      private function reset(bFullReset:Boolean) : void
      {
         this.formattedName = this.lat = this.lon = this.data = this.url = "";
         this.navUniqueId = -1;
         this.pinned = false;
         this._bIsHome = false;
         if(bFullReset)
         {
            this._mType = "";
         }
      }
      
      public function setKey(key:int) : void
      {
         if(key != -1)
         {
            this.navUniqueId = key;
         }
      }
      
      public function setURL(url:String) : void
      {
         if(url != "")
         {
            url = url;
         }
      }
      
      public function setPhoneint(int:String) : void
      {
         if(int != "")
         {
            this.phoneint = int;
         }
      }
      
      public function setName(newName:String) : void
      {
         if(newName != "")
         {
            this.formattedName = newName;
         }
      }
      
      public function get Valid() : Boolean
      {
         if(this.data != "" && this.data.indexOf(SECONDARY_LOC) != -1 && this.data.indexOf(PRIMARY_LOC) != -1)
         {
            return true;
         }
         return false;
      }
      
      public function getInsertItem(bNeedPin:Boolean = false) : Object
      {
         return this.getDBObj(false,bNeedPin);
      }
      
      private function setup(item:FavoriteDestination) : Boolean
      {
         if(item == null)
         {
            return false;
         }
         var locDec1:LocationDetails = item.location.getPrimaryLocation();
         var locDec2:LocationDetails = item.location.getSecondaryLocation();
         if(locDec1 == null || locDec2 == null)
         {
            return false;
         }
         var cusName:String = locDec1.getCustomName();
         if(cusName != null && cusName != "")
         {
            this.setName(cusName);
         }
         var localdata:String = locDec1.toEIS();
         if(localdata != "")
         {
            localdata = LOC_STR_N + PRIMARY_LOC + "<*>" + localdata;
            if(locDec2.toEIS() != "")
            {
               localdata += LOC_STR_N + SECONDARY_LOC + "<*>" + locDec2.toEIS();
               this.setData(localdata);
               this.pinned = item.pinned;
               if(item.location.databaseKey != -1)
               {
                  this.navUniqueId = item.location.databaseKey;
               }
               return true;
            }
            return false;
         }
         return false;
      }
      
      public function printSummary() : void
      {
         Framework.Trace("type " + this.type);
         Framework.Trace("name " + this.formattedName);
         Framework.Trace("data " + this.data);
         Framework.Trace("lat " + this.lat);
         Framework.Trace("lon " + this.lon);
         Framework.Trace("key " + this.navUniqueId);
         Framework.Trace("phoneint " + this.phoneint);
      }
      
      public function getMoveItem() : Object
      {
         var temp:Object = new Object();
         temp.navUniqueId = this.navUniqueId;
         return temp;
      }
      
      public function getUpdateItem(bNeedSortIndex:Boolean = false, bNeedPin:Boolean = false) : Object
      {
         var temp:Object = this.getDBObj(bNeedSortIndex,bNeedPin);
         temp.navUniqueId = this.navUniqueId;
         return temp;
      }
      
      private function getDBObj(bNeedSortIndex:Boolean = false, bNeedPin:Boolean = false) : Object
      {
         var item:Object = new Object();
         item.formattedName = this.formattedName;
         item.data = this.data;
         item.lat = this.lat;
         item.lon = this.lon;
         if(bNeedSortIndex)
         {
            item.sortIndex = this.sortIndex;
         }
         if(bNeedPin)
         {
            item.pinned = this.pinned;
         }
         return item;
      }
      
      public function getMyLocDescription(bNeedSortIndex:Boolean = false, bNeedPin:Boolean = false) : FavoriteDestination
      {
         var s1:String = null;
         var eisType:String = null;
         var d1:String = null;
         var det:LocationDetails = null;
         if(this.Valid == false)
         {
            Framework.Trace("something is wrong, this one is null");
            return null;
         }
         var tempArray:Array = this.data.split(LOC_STR_N);
         var loc:LocationDescription = new LocationDescription(this.navUniqueId);
         for(var i:int = 0; i < tempArray.length; i++)
         {
            if(tempArray[i] != "")
            {
               s1 = tempArray[i];
               eisType = s1.substring(0,s1.indexOf("<*>"));
               d1 = s1.substring(s1.indexOf("<*>") + 3);
               det = new LocationDetails();
               if(d1 != "")
               {
                  det.addEisString(d1);
               }
               if(this.formattedName != "")
               {
                  det.setCustomName(this.formattedName);
               }
               if(eisType == PRIMARY_LOC)
               {
                  loc.setPrimaryLocation(det);
               }
               else
               {
                  loc.setSecondaryLocation(det);
               }
            }
         }
         var favoriteItem:FavoriteDestination = new FavoriteDestination(loc);
         if(bNeedPin)
         {
            favoriteItem.setPin(this.pinned);
         }
         if(bNeedSortIndex)
         {
            favoriteItem.setIndex(this.sortIndex);
         }
         return favoriteItem;
      }
   }
}

