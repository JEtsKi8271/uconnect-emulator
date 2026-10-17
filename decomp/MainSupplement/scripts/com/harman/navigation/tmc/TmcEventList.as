package com.harman.navigation.tmc
{
   import com.harman.navigation.utils.SortableList;
   
   public class TmcEventList extends SortableList
   {
      
      private var _infoType:int;
      
      public function TmcEventList()
      {
         super();
      }
      
      public function get infoType() : int
      {
         return this._infoType;
      }
      
      public function addEvent(evt:TmcEvent) : void
      {
         super.addItem(evt);
      }
      
      public function getEvent(index:int) : TmcEvent
      {
         return TmcEvent(super.getItem(index));
      }
      
      public function sortByDistance() : void
      {
         super.sort(function(evt1:TmcEvent, evt2:TmcEvent):int
         {
            return evt1.compareDistanceTo(evt2);
         });
      }
      
      public function sortByNameAndDistance() : void
      {
         super.sortOn(["label","distanceCurrentUnits"]);
      }
      
      public function filterByLabelPrefix(prefix:String, caseSensitive:Boolean = false) : TmcEventList
      {
         var evt:TmcEvent = null;
         var lbl:String = null;
         var result:TmcEventList = new TmcEventList();
         if(!caseSensitive)
         {
            prefix = prefix.toLocaleLowerCase();
         }
         for(var k:int = 0; k < this.length; k++)
         {
            evt = this.getEvent(k);
            lbl = evt.label;
            if(!caseSensitive)
            {
               lbl = lbl.toLocaleLowerCase();
            }
            if(lbl.indexOf(prefix) == 0)
            {
               result.addItem(evt);
            }
         }
         return result;
      }
      
      public function setInfoType(infoType:int) : void
      {
         this._infoType = infoType;
      }
   }
}

