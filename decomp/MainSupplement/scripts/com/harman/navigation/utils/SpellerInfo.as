package com.harman.navigation.utils
{
   public class SpellerInfo
   {
      
      private var mEisString:String = "";
      
      private var mCharacters:String = "";
      
      private var mFullMatch:Boolean = false;
      
      private var mCount:int = 0;
      
      public function SpellerInfo()
      {
         super();
      }
      
      public function reset() : void
      {
         this.mEisString = "";
         this.mCharacters = "";
         this.mFullMatch = false;
         this.mCount = 0;
      }
      
      public function get eisString() : String
      {
         return this.mEisString;
      }
      
      public function get characters() : String
      {
         return this.mCharacters;
      }
      
      public function get fullMatch() : Boolean
      {
         return this.mFullMatch;
      }
      
      public function get count() : int
      {
         return this.mCount;
      }
      
      public function setEisString(eis:String) : void
      {
         this.mEisString = eis;
      }
      
      public function setCharacters(chars:String) : void
      {
         this.mCharacters = chars;
      }
      
      public function setFullMatch(fullMatch:Boolean) : void
      {
         this.mFullMatch = fullMatch;
      }
      
      public function setCount(count:int) : void
      {
         this.mCount = count;
      }
   }
}

