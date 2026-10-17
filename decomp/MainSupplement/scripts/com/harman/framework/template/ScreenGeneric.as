package com.harman.framework.template
{
   import flash.display.MovieClip;
   
   public class ScreenGeneric extends MovieClip
   {
      
      private var mAssets:MovieClip = null;
      
      private var mScreenVars:Object = null;
      
      private var mPermanentCache:Boolean = false;
      
      private function mOnScreenInComplete():void
      {
      }
      private function mOnScreenOutComplete():void
      {
      }
      public function ScreenGeneric()
      {
         super();
      }
      
      public function get cache() : Boolean
      {
         return this.mPermanentCache;
      }
      
      public function set cache(_cache:Boolean) : void
      {
         this.mPermanentCache = _cache;
      }
      
      public function get view() : MovieClip
      {
         return this.mAssets;
      }
      
      public function set view(view:MovieClip) : void
      {
         this.mAssets = view;
      }
      
      public function get screenVars() : Object
      {
         return this.mScreenVars;
      }
      
      public function set screenVars(vars:Object) : void
      {
         this.mScreenVars = vars;
      }
      
      public function set onScreenInComplete(callBack:Function) : void
      {
         this.mOnScreenInComplete = callBack;
      }
      
      public function set onScreenOutComplete(callBack:Function) : void
      {
         this.mOnScreenOutComplete = callBack;
      }
      
      public function cleanup() : void
      {
         if(this.mAssets != null)
         {
            this.mAssets = null;
         }
         this.mOnScreenInComplete = null;
         this.mOnScreenOutComplete = null;
         this.mScreenVars = null;
      }
      
      public function screenIn() : void
      {
      }
      
      public function screenOut() : void
      {
      }
      
      public function screenInComplete() : void
      {
         if(this.mOnScreenInComplete != null)
         {
            this.mOnScreenInComplete();
         }
      }
      
      public function screenOutComplete() : void
      {
         if(this.mOnScreenOutComplete != null)
         {
            this.mOnScreenOutComplete();
         }
      }
   }
}

