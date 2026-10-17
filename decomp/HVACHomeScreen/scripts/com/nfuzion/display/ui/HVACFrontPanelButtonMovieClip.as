package com.nfuzion.display.ui
{
   import flash.display.IMovieClip;
   import flash.text.TextField;
   import skin.Skin;
   
   public dynamic class HVACFrontPanelButtonMovieClip extends ButtonMovieClip implements IMovieClip
   {
      
      public var name_label:TextField;
      
      public var number_label:TextField;
      
      public function HVACFrontPanelButtonMovieClip()
      {
         super();
      }
      
      override protected function setButtonImageColors() : void
      {
         Skin.style.applyStyle(this.btnDown,Skin.style.currentTheme.downStateStandard);
         Skin.style.applyStyle(this.btnActive,Skin.style.currentTheme.activeStateStandard);
         Skin.style.applyStyle(this.playIcon,Skin.style.currentTheme.disabledStateStandard);
         if(mCurrentState == STATE_ACTIVE)
         {
            this.cursor.x = -12;
            this.cursor.y = -12;
            this.cursor.width = 93;
            this.cursor.height = 92;
         }
         else
         {
            this.cursor.x = 0;
            this.cursor.y = 0;
            this.cursor.width = 68;
            this.cursor.height = 67;
         }
      }
   }
}

