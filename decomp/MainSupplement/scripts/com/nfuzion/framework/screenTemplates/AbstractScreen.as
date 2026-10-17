package com.nfuzion.framework.screenTemplates
{
   import com.nfuzion.framework.global.Framework;
   import flash.display.MovieClip;
   import flash.events.Event;
   
   public class AbstractScreen extends MovieClip
   {
      
      private var mDesignView:MovieClip;
      
      private var mVars:Object;
      
      private var mHasView:Boolean = false;
      
      private var mPermanentCache:Boolean = false;
      
      private function mOnScreenInComplete():void
      {
      }
      private function mOnScreenOutComplete():void
      {
      }
      public function AbstractScreen()
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
         return this.mDesignView;
      }
      
      public function set view(view:MovieClip) : void
      {
         this.mDesignView = view;
      }
      
      public function get screenVars() : Object
      {
         if(this.mVars == null)
         {
            this.mVars = new Object();
         }
         return this.mVars;
      }
      
      public function set screenVars(vars:Object) : void
      {
         this.mVars = vars;
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
         if(null != this.mDesignView)
         {
            this.mDesignView = null;
         }
         this.mOnScreenInComplete = null;
         this.mOnScreenOutComplete = null;
         this.mVars = null;
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
      
      protected function back(e:Event = null) : void
      {
         Framework.structure.back();
      }
      
      protected function close(e:Event = null) : void
      {
         Framework.structure.exit();
      }
   }
}

