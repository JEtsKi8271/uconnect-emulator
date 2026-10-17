package com.nfuzion.display.ui
{
   import flash.display.IMovieClip;
   import flash.text.TextField;
   import skin.Skin;
   
   public dynamic class DialPadNumberButtonMovieClip extends ButtonMovieClip implements IMovieClip
   {
      
      public var labelNumber:TextField;
      
      public var labelLetters:TextField;
      
      public var labelSymbol:TextField;
      
      public function DialPadNumberButtonMovieClip()
      {
         super();
      }
      
      override protected function setButtonFont() : void
      {
         Skin.style.applyFont(this.labelNumber,Skin.style.currentTheme.FONT_PRIMARY);
         if(this.labelLetters != null)
         {
            Skin.style.applyFont(this.labelLetters,Skin.style.currentTheme.FONT_PRIMARY);
         }
         if(this.labelSymbol != null)
         {
            Skin.style.applyFont(this.labelSymbol,Skin.style.currentTheme.FONT_PRIMARY);
         }
      }
      
      override protected function setButtonTextColors() : void
      {
         Skin.style.applyStyle(this.labelNumber,Skin.style.currentTheme.primaryText);
         if(this.labelLetters != null)
         {
            Skin.style.applyStyle(this.labelLetters,Skin.style.currentTheme.primaryText);
         }
         if(this.labelSymbol != null)
         {
            Skin.style.applyStyle(this.labelSymbol,Skin.style.currentTheme.primaryText);
         }
      }
   }
}

