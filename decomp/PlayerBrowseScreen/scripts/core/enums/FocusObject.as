package core.enums
{
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   
   public dynamic class FocusObject
   {
      
      public var index:int = 0;
      
      public var layer:String = "";
      
      public var priority:String = "";
      
      public var objects:Array = null;
      
      public var focusCallBack:Function = null;
      
      public function FocusObject(param1:String = "", param2:String = "", param3:Array = null, param4:Function = null)
      {
         this.layer = param1;
         this.priority = param2;
         this.objects = param3;
         this.focusCallBack = param4;
         super();
      }
      
      public function getCursorableObject(param1:int = 0) : MovieClip
      {
         var _loc2_:int = 0;
         if(this.objects != null)
         {
            if(param1 == 0)
            {
               return this.objects[this.index];
            }
            _loc2_ = 0;
            while(_loc2_ != this.objects.length)
            {
               this.index += param1 > 0 ? 1 : -1;
               if(this.index < 0)
               {
                  this.index = this.objects.length - 1;
               }
               else if(this.index >= this.objects.length)
               {
                  this.index = 0;
               }
               if(this.isObjectCursorable())
               {
                  return this.objects[this.index];
               }
               _loc2_++;
            }
         }
         return null;
      }
      
      public function isObjectCursorable() : Boolean
      {
         var _loc1_:MovieClip = null;
         if(this.objects != null)
         {
            _loc1_ = MovieClip(this.objects[this.index]);
            if(_loc1_ != null)
            {
               if(_loc1_.mouseEnabled && this.checkVisibility(_loc1_))
               {
                  if(_loc1_.hasOwnProperty("mEnabled"))
                  {
                     return _loc1_.mEnabled;
                  }
                  if(_loc1_.hasOwnProperty("getEnabled"))
                  {
                     return _loc1_.getEnabled();
                  }
                  return true;
               }
               return false;
            }
            return false;
         }
         return false;
      }
      
      private function checkVisibility(param1:MovieClip) : Boolean
      {
         var _loc2_:DisplayObjectContainer = param1.parent;
         if(param1.visible && _loc2_ != null)
         {
            while(_loc2_ != null)
            {
               if(!_loc2_.visible)
               {
                  return false;
               }
               _loc2_ = _loc2_.parent;
            }
            return true;
         }
         return false;
      }
   }
}

