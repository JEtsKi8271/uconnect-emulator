package com.harman.navigation.global.vServices
{
   public class VServiceSpellerGeneric
   {
      
      private var mFollowUpMenuID:int = 0;
      
      private var mFollowUpMenuBackToSpeller:Boolean = true;
      
      private var mMaxCharacters:int = 25;
      
      private var mEnabledCharacters:String = "";
      
      private var mInputPreset:String = "";
      
      private var mListIndex:int = 0;
      
      public function VServiceSpellerGeneric()
      {
         super();
      }
      
      public function setFollowUpMenuID(id:int) : void
      {
         this.mFollowUpMenuID = id;
         this.mFollowUpMenuBackToSpeller = true;
      }
      
      public function setFollowUpMenuBackToSpeller(back:Boolean) : void
      {
         this.mFollowUpMenuBackToSpeller = back;
      }
      
      public function setMaxCharacters(max:int) : void
      {
         this.mMaxCharacters = max;
      }
      
      public function setEnabledCharacters(chars:String) : void
      {
         this.mEnabledCharacters = chars;
      }
      
      public function setInputPreset(input:String) : void
      {
         this.mInputPreset = input;
      }
      
      public function setListIndex(index:int) : void
      {
         this.mListIndex = index;
      }
      
      public function get followUpMenuID() : int
      {
         return this.mFollowUpMenuID;
      }
      
      public function get followUpMenuOnBackToSpeller() : Boolean
      {
         if(this.mFollowUpMenuBackToSpeller == true)
         {
            return true;
         }
         this.mFollowUpMenuBackToSpeller = true;
         return false;
      }
      
      public function get maxCharacters() : int
      {
         return this.mMaxCharacters;
      }
      
      public function get enabledCharacters() : String
      {
         return this.mEnabledCharacters;
      }
      
      public function get inputPreset() : String
      {
         return this.mInputPreset;
      }
      
      public function get listIndex() : int
      {
         return this.mListIndex;
      }
   }
}

