package com.harman.navigation.global.vServices
{
   public class VServicePopupGeneric
   {
      
      private var mPopupText:Array = new Array();
      
      private var mOnCancelFunction:Function = null;
      
      private var mEnableAnimation:Boolean = false;
      
      private var mOnePopupText:String = "";
      
      private var mOneButtonPopupButtonText:String = "";
      
      private var mOneCancelFunction:Function = null;
      
      private var mOneButtonCallback:Function = null;
      
      private var mTwoButtonPopupText:String = "";
      
      private var mTwoButtonPopupButtonTexts:Array = new Array();
      
      private var mTwoButtonCallbacks:Array = null;
      
      private var mThreeButtonPopupText:String = "";
      
      private var mThreeButtonPopupButtonTexts:Array = new Array();
      
      private var mThreeButtonCallbacks:Array = null;
      
      public function VServicePopupGeneric()
      {
         super();
      }
      
      public function set popupText(composition:Array) : void
      {
         this.mPopupText = composition.slice(0,composition.length);
      }
      
      public function get popupText() : Array
      {
         return this.mPopupText;
      }
      
      public function setOnCancelCallBackFunction(callBack:Function) : void
      {
         this.mOnCancelFunction = callBack;
      }
      
      public function onCancel() : void
      {
         if(this.mOnCancelFunction != null)
         {
            this.mOnCancelFunction();
         }
      }
      
      public function enableAnimation(enable:Boolean) : void
      {
         this.mEnableAnimation = enable;
      }
      
      public function get animationEnabled() : Boolean
      {
         return this.mEnableAnimation;
      }
      
      public function setOneButtonPopupText(text:String) : void
      {
         this.mOnePopupText = text;
      }
      
      public function get oneButtonPopupText() : String
      {
         return this.mOnePopupText;
      }
      
      public function setOneButtonPopupButtonText(text:String) : void
      {
         this.mOneButtonPopupButtonText = text;
      }
      
      public function get oneButtonPopupButtonText() : String
      {
         return this.mOneButtonPopupButtonText;
      }
      
      public function setOneButtonPopupButtonCallbackFunction(callBack:Function) : void
      {
         this.mOneButtonCallback = callBack;
      }
      
      public function onOneButtonPopupButton() : void
      {
         if(this.mOneButtonCallback != null)
         {
            (this.mOneButtonCallback as Function)();
         }
      }
      
      public function setTwoButtonPopupText(text:String) : void
      {
         this.mTwoButtonPopupText = text;
      }
      
      public function get twoButtonPopupText() : String
      {
         return this.mTwoButtonPopupText;
      }
      
      public function setTwoButtonPopupButtonTexts(texts:Array) : void
      {
         this.mTwoButtonPopupButtonTexts = texts;
      }
      
      public function get twoButtonPopupButtonTexts() : Array
      {
         return this.mTwoButtonPopupButtonTexts;
      }
      
      public function setTwoButtonPopupButtonCallbackFunctions(functions:Array) : void
      {
         this.mTwoButtonCallbacks = functions;
      }
      
      public function onTwoButtonPopupButton(index:int) : void
      {
         if(this.mTwoButtonCallbacks[index] != null)
         {
            (this.mTwoButtonCallbacks[index] as Function)();
         }
      }
      
      public function setThreeButtonPopupText(text:String) : void
      {
         this.mThreeButtonPopupText = text;
      }
      
      public function get threeButtonPopupText() : String
      {
         return this.mThreeButtonPopupText;
      }
      
      public function setThreeButtonPopupButtonTexts(texts:Array) : void
      {
         this.mThreeButtonPopupButtonTexts = texts;
      }
      
      public function get threeButtonPopupButtonTexts() : Array
      {
         return this.mThreeButtonPopupButtonTexts;
      }
      
      public function setThreeButtonPopupButtonCallbackFunctions(functions:Array) : void
      {
         this.mThreeButtonCallbacks = functions;
      }
      
      public function onThreeButtonPopupButton(index:int) : void
      {
         if(this.mThreeButtonCallbacks[index] != null)
         {
            (this.mThreeButtonCallbacks[index] as Function)();
         }
      }
   }
}

