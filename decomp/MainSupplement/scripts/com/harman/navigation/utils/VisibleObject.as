package com.harman.navigation.utils
{
   public class VisibleObject
   {
      
      private var mName:String = "";
      
      private var mID:String = "";
      
      private var mVisible:Boolean = false;
      
      private var mIconPath:String = "";
      
      private var mCount:int = 0;
      
      public function VisibleObject()
      {
         super();
      }
      
      public function clone(orig:VisibleObject) : void
      {
         this.mName = orig.name;
         this.mID = orig.id;
         this.mVisible = orig.visible;
         this.mIconPath = orig.iconPath;
         this.mCount = orig.mCount;
      }
      
      public function get name() : String
      {
         return this.mName;
      }
      
      public function get id() : String
      {
         return this.mID;
      }
      
      public function get visible() : Boolean
      {
         return this.mVisible;
      }
      
      public function get iconPath() : String
      {
         return this.mIconPath;
      }
      
      public function get count() : int
      {
         return this.mCount;
      }
      
      public function setName(name:String) : void
      {
         this.mName = name;
      }
      
      public function setID(id:String) : void
      {
         this.mID = id;
      }
      
      public function setVisible(visible:Boolean) : void
      {
         this.mVisible = visible;
      }
      
      public function setIconPath(path:String) : void
      {
         this.mIconPath = path;
      }
      
      public function setCount(count:int) : void
      {
         this.mCount = count;
      }
   }
}

