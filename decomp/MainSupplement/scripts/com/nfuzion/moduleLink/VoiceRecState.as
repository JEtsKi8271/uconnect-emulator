package com.nfuzion.moduleLink
{
   public class VoiceRecState
   {
      
      private var state:Boolean;
      
      private var vrOffReason:String = "";
      
      public function VoiceRecState()
      {
         super();
         this.setup(false,"");
      }
      
      public function get availbleState() : Boolean
      {
         return this.state;
      }
      
      public function get VRNotAvailableReason() : String
      {
         return this.vrOffReason;
      }
      
      public function setup(newState:Boolean, reason:String = "") : Boolean
      {
         var bEmitChange:Boolean = false;
         if(this.state != newState)
         {
            bEmitChange = true;
         }
         else if(this.state == false)
         {
            if(this.vrOffReason != reason)
            {
               bEmitChange = true;
            }
         }
         this.state = newState;
         if(this.state == false)
         {
            this.vrOffReason = reason;
         }
         else
         {
            this.vrOffReason = "";
         }
         return bEmitChange;
      }
   }
}

