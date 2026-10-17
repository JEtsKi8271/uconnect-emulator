package com.nfuzion.display.ui
{
   import flash.display.IMovieClip;
   import flash.display.MovieClip;
   import flash.text.TextField;
   import skin.Skin;
   
   public dynamic class MainMenuButtonMovieClip extends ButtonMovieClip implements IMovieClip
   {
      
      public var glow:MovieClip;
      
      public var displaySignalStrength:MovieClip;
      
      public var displayBluetooth:MovieClip;
      
      public var compassLabel:TextField;
      
      public var controlsIcon:MovieClip;
      
      public function MainMenuButtonMovieClip()
      {
         super();
      }
      
      override protected function setButtonImageColors() : void
      {
         Skin.style.applyStyle(this.glow,Skin.style.currentTheme.activeGraphic);
      }
      
      override protected function setButtonFont() : void
      {
         super.setButtonFont();
         if(this.compassLabel != null)
         {
            Skin.style.applyFont(this.compassLabel,Skin.style.currentTheme.FONT_PRIMARY);
         }
      }
      
      override protected function setButtonTextColors() : void
      {
         super.setButtonTextColors();
         if(this.compassLabel != null)
         {
            Skin.style.applyStyle(this.compassLabel,Skin.style.currentTheme.primaryText);
         }
      }
      
      override protected function setButtonIconColor() : void
      {
      }
      
      override protected function showOrHideButtonImages() : void
      {
         setVisible(this.glow,mCurrentState == STATE_ACTIVE || mCurrentState == STATE_DOWN);
      }
   }
}

