package com.harman.moduleLinkAPI
{
   import flash.events.EventDispatcher;
   
   public class AhaStation extends EventDispatcher
   {
      
      private var stationID:int = 0;
      
      private var stationIdString:String = "";
      
      private var fullName:String = "";
      
      private var shortName:String = "";
      
      private var canHideList:Boolean = false;
      
      private var canLike:Boolean = false;
      
      private var canTimeShift:Boolean = false;
      
      private var hasDynamicPlaylist:Boolean = false;
      
      private var isLBSStation:Boolean = false;
      
      private var isFeaturedStation:Boolean = false;
      
      private var isSignatureStation:Boolean = false;
      
      private var isFacebook:Boolean = false;
      
      private var isTwitter:Boolean = false;
      
      public function AhaStation(id:int, properties:Object)
      {
         var prop:* = undefined;
         super();
         this.stationID = id;
         for(prop in properties)
         {
            try
            {
               this[prop] = properties[prop];
               trace("*<HMIModule> AhaStation <adding> \'" + prop + "\' : " + properties[prop]);
            }
            catch(e:Error)
            {
               trace("*<HMIModule> AhaStation <ignore> \'" + prop + "\' not recognized!");
            }
         }
      }
      
      public function get ID() : int
      {
         return this.stationID;
      }
      
      public function get ID_STRING() : String
      {
         return this.stationIdString;
      }
      
      public function get FULL_NAME() : String
      {
         return this.fullName;
      }
      
      public function get SHORT_NAME() : String
      {
         return this.shortName;
      }
      
      public function get HAS_CONTENT() : Boolean
      {
         return !this.canHideList;
      }
      
      public function get HAS_LIKE() : Boolean
      {
         return this.canLike;
      }
      
      public function get HAS_TIME_SHIFT() : Boolean
      {
         return this.canTimeShift;
      }
      
      public function get HAS_DYNAMIC_CONTENT() : Boolean
      {
         return this.hasDynamicPlaylist;
      }
      
      public function get IS_NEARBY() : Boolean
      {
         return this.isLBSStation;
      }
      
      public function get IS_FEATURED() : Boolean
      {
         return this.isFeaturedStation;
      }
      
      public function get IS_SIGNATURE() : Boolean
      {
         return this.isSignatureStation;
      }
      
      public function get IS_FACEBOOK() : Boolean
      {
         return this.isFacebook;
      }
      
      public function get IS_TWITTER() : Boolean
      {
         return this.isTwitter;
      }
   }
}

