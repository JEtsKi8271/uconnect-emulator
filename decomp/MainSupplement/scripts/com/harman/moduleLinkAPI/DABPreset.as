package com.harman.moduleLinkAPI
{
   public class DABPreset
   {
      
      public static const POSITION_NONE:uint = 255;
      
      private var mId:uint = 255;
      
      private var mName:String;
      
      private var mGenre:String;
      
      private var mSelected:Boolean;
      
      public function DABPreset()
      {
         super();
      }
      
      public function get id() : uint
      {
         return this.mId;
      }
      
      public function get name() : String
      {
         return this.mName;
      }
      
      public function get genre() : String
      {
         return this.mGenre;
      }
      
      public function get selected() : Boolean
      {
         return this.mSelected;
      }
      
      public function fill(id:uint, name:String, genre:String, selected:Boolean) : void
      {
         this.mId = id;
         this.mName = name;
         this.mGenre = genre;
         this.mSelected = selected;
      }
      
      public function isEqual(otherPreset:DABPreset) : Boolean
      {
         var haveSameValues:Boolean = false;
         if(otherPreset != null)
         {
            haveSameValues = this.mId == otherPreset.mId && this.mName == otherPreset.mName && this.mGenre == otherPreset.mGenre && this.mSelected == otherPreset.mSelected;
         }
         return haveSameValues;
      }
      
      public function clear() : void
      {
         this.mId = POSITION_NONE;
         this.mName = "";
         this.mGenre = "";
         this.mSelected = false;
      }
      
      public function copyFrom(otherPreset:DABPreset) : void
      {
         if(otherPreset != null)
         {
            this.mId = otherPreset.id;
            this.mName = otherPreset.mName;
            this.mGenre = otherPreset.mGenre;
            this.mSelected = otherPreset.mSelected;
         }
      }
   }
}

