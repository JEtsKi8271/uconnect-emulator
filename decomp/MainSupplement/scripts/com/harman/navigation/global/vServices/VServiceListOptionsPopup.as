package com.harman.navigation.global.vServices
{
   public class VServiceListOptionsPopup
   {
      
      private var mButtonTexts:Array = new Array();
      
      private var mButtonStates:Array = new Array();
      
      public function VServiceListOptionsPopup()
      {
         super();
      }
      
      public function setButtonTexts(texts:Array) : void
      {
         this.mButtonTexts = texts;
      }
      
      public function setButtonStates(states:Array) : void
      {
         this.mButtonStates = states;
      }
      
      public function get buttonTexts() : Array
      {
         return this.mButtonTexts;
      }
      
      public function get buttonStates() : Array
      {
         return this.mButtonStates;
      }
   }
}

