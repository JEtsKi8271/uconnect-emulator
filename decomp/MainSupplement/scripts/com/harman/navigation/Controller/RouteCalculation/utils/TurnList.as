package com.harman.navigation.Controller.RouteCalculation.utils
{
   import com.harman.navigation.utils.TurnListElement;
   
   public class TurnList
   {
      
      private var mTurnList:Array = new Array();
      
      private var mTurnListUpdatePending:Boolean = true;
      
      public function TurnList()
      {
         super();
      }
      
      public function setTurnList(list:Array) : void
      {
         var newTurn:TurnListElement = null;
         this.mTurnList.splice(0,this.mTurnList.length);
         for(var i:int = 0; i < list.length; i++)
         {
            newTurn = new TurnListElement();
            newTurn.addEisString(String(list[i]));
            this.mTurnList.push(newTurn);
         }
      }
      
      public function get turnList() : Array
      {
         return this.mTurnList;
      }
      
      public function setTurnListUpdatePending(pending:Boolean) : void
      {
         this.mTurnListUpdatePending = pending;
      }
      
      public function get turnListUpdatePending() : Boolean
      {
         return this.mTurnListUpdatePending;
      }
      
      public function getTurnListSegment(segment:int) : TurnListElement
      {
         if(segment <= this.mTurnList.length)
         {
            return TurnListElement(this.mTurnList[segment]);
         }
         return new TurnListElement();
      }
   }
}

