package com.nfuzion.moduleLinkAPI
{
   import flash.events.EventDispatcher;
   
   public class Module extends EventDispatcher implements IModule
   {
      
      private var interest:Object;
      
      public function Module()
      {
         super();
         this.interest = new Object();
      }
      
      public function getAll() : void
      {
      }
      
      public function isReady() : Boolean
      {
         return false;
      }
      
      public function hello() : void
      {
         dispatchEvent(new ModuleEvent(ModuleEvent.HELLO));
      }
      
      public function addInterest(signalName:String) : void
      {
         if(this.interest[signalName] != undefined)
         {
            if(this.interest[signalName] == 0)
            {
               this.subscribe(signalName);
            }
            ++this.interest[signalName];
         }
         else
         {
            this.subscribe(signalName);
            this.interest[signalName] = 1;
         }
      }
      
      public function removeInterest(signalName:String) : void
      {
         if(this.interest[signalName] != undefined)
         {
            if(this.interest[signalName] == 1)
            {
               this.unsubscribe(signalName);
            }
            --this.interest[signalName];
         }
      }
      
      public function destroyInterest(signalName:String) : void
      {
         if(this.interest[signalName] != undefined)
         {
            if(this.interest[signalName] > 0)
            {
               this.unsubscribe(signalName);
            }
            this.interest[signalName] = 0;
         }
      }
      
      public function interested(signalName:String) : Boolean
      {
         if(this.interest[signalName] != undefined)
         {
            if(this.interest[signalName] > 0)
            {
               return true;
            }
         }
         return false;
      }
      
      public function totalInterest(signalName:String) : uint
      {
         if(this.interest[signalName] != undefined)
         {
            return this.interest[signalName];
         }
         return 0;
      }
      
      override public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false) : void
      {
         super.addEventListener(type,listener,useCapture,priority,useWeakReference);
         this.addInterest(type);
      }
      
      override public function removeEventListener(type:String, listener:Function, useCapture:Boolean = false) : void
      {
         super.removeEventListener(type,listener,useCapture);
         this.removeInterest(type);
      }
      
      protected function subscribe(signalName:String) : void
      {
      }
      
      protected function unsubscribe(signalName:String) : void
      {
      }
   }
}

