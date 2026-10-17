package com.harman.navigation.Controller.LiveServices
{
   import com.harman.navigation.NavGlobalSettingsCommon;
   import com.harman.navigation.utils.LocationDescription;
   
   public class LocalSearchResultList
   {
      
      public static const SO_UNKNOWN:int = 0;
      
      public static const SO_BY_NAME:int = 1;
      
      public static const SO_BY_DISTANCE:int = 2;
      
      private var mSortOrder:int = NavGlobalSettingsCommon.TTLS_LOCAL_SEARCH_SORT_OREDER_DEFAULT;
      
      private var mResultList:Object = new Object();
      
      private var mSortAlpha:Array = new Array();
      
      private var mSortDistance:Array = new Array();
      
      private var mAlphajumpVec:Vector.<String> = new Vector.<String>();
      
      public function LocalSearchResultList(listItems:Array)
      {
         var i:int = 0;
         var listItem:LocalSearchResultListItem = null;
         super();
         this.mSortOrder = NavGlobalSettingsCommon.TTLS_LOCAL_SEARCH_SORT_OREDER_DEFAULT;
         if(listItems)
         {
            for(i = 0; i < listItems.length; i++)
            {
               listItem = new LocalSearchResultListItem(listItems[i]);
               if(listItem.valid)
               {
                  this.mResultList[listItem.tomtomID] = listItem;
               }
            }
         }
         this.determineAlphaJumpCharacters();
         this.sortAlphabetically();
         this.sortByDistance();
      }
      
      public function set sortOrder(order:int) : void
      {
         this.mSortOrder = order;
      }
      
      public function get sortOrder() : int
      {
         return this.mSortOrder;
      }
      
      public function getListItem(index:int) : LocalSearchResultListItem
      {
         switch(this.mSortOrder)
         {
            case SO_BY_DISTANCE:
               return LocalSearchResultListItem(this.mResultList[this.mSortDistance[index]]);
            case SO_BY_NAME:
               return LocalSearchResultListItem(this.mResultList[this.mSortAlpha[index]]);
            case SO_UNKNOWN:
         }
         return new LocalSearchResultListItem(null);
      }
      
      public function get listAlpha() : Array
      {
         return this.mSortAlpha;
      }
      
      public function get listDistance() : Array
      {
         return this.mSortDistance;
      }
      
      public function getLocationDescriptionForTomTomID(id:int) : LocationDescription
      {
         if(this.mResultList[id] != null)
         {
            return LocalSearchResultListItem(this.mResultList[id]).locationDescription;
         }
         return new LocationDescription();
      }
      
      public function get alphaCharacters() : Vector.<String>
      {
         return this.mAlphajumpVec;
      }
      
      public function indexFromStartChar(char:String) : int
      {
         char = char.toUpperCase();
         for(var i:int = 0; i < this.mSortAlpha.length; i++)
         {
            if(LocalSearchResultListItem(this.mResultList[this.mSortAlpha[i]]).title.length > 0 && LocalSearchResultListItem(this.mResultList[this.mSortAlpha[i]]).title.charAt(0) == char)
            {
               return i;
            }
         }
         return 0;
      }
      
      private function determineAlphaJumpCharacters() : void
      {
         var item:LocalSearchResultListItem = null;
         this.mAlphajumpVec.splice(0,this.mAlphajumpVec.length);
         for each(item in this.mResultList)
         {
            if(item.title.length > 0)
            {
               this.mAlphajumpVec.push(item.title.charAt(0).toUpperCase());
            }
         }
      }
      
      private function sortAlphabetically() : void
      {
         var i:String = null;
         var title:String = null;
         var added:Boolean = false;
         var j:int = 0;
         var res:int = 0;
         for(i in this.mResultList)
         {
            title = LocalSearchResultListItem(this.mResultList[i]).title;
            if(this.mSortAlpha.length == 0)
            {
               this.mSortAlpha.push(i);
            }
            else
            {
               added = false;
               for(j = 0; j < this.mSortAlpha.length; j++)
               {
                  res = this.alphabetical(title.toUpperCase(),LocalSearchResultListItem(this.mResultList[String(this.mSortAlpha[j])]).title.toUpperCase());
                  if(res == -1 || res == 0)
                  {
                     this.mSortAlpha.splice(j,0,i);
                     added = true;
                     break;
                  }
               }
               if(!added)
               {
                  this.mSortAlpha.splice(j,0,i);
               }
            }
         }
      }
      
      private function sortByDistance() : void
      {
         var i:String = null;
         var distance:Number = NaN;
         var added:Boolean = false;
         var j:int = 0;
         for(i in this.mResultList)
         {
            distance = LocalSearchResultListItem(this.mResultList[i]).distance;
            if(this.mSortDistance.length == 0)
            {
               this.mSortDistance.push(i);
            }
            else
            {
               added = false;
               for(j = 0; j < this.mSortDistance.length; j++)
               {
                  if(distance <= LocalSearchResultListItem(this.mResultList[String(this.mSortDistance[j])]).distance)
                  {
                     this.mSortDistance.splice(j,0,i);
                     added = true;
                     break;
                  }
               }
               if(!added)
               {
                  this.mSortDistance.splice(j,0,i);
               }
            }
         }
      }
      
      private function alphabetical(name1:String, name2:String) : int
      {
         if(name1 < name2)
         {
            return -1;
         }
         if(name1 > name2)
         {
            return 1;
         }
         return 0;
      }
   }
}

