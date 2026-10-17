package com.nfuzion.display.ui
{
   import flash.display.IMovieClip;
   import flash.text.TextField;
   import skin.Skin;
   
   public dynamic class DisplayPhonePrimaryMovieClip extends BaseMovieClip implements IMovieClip
   {
      
      public var labelPhoneName:TextField;
      
      public var labelCallTime:TextField;
      
      public var labelAction:TextField;
      
      public var labelStatus:TextField;
      
      public var labelRoaming:TextField;
      
      public function DisplayPhonePrimaryMovieClip()
      {
         super();
      }
      
      override protected function updateTheme() : void
      {
         Skin.style.applyFont(this.labelPhoneName,Skin.style.currentTheme.FONT_PRIMARY);
         Skin.style.applyFont(this.labelCallTime,Skin.style.currentTheme.FONT_PRIMARY);
         Skin.style.applyFont(this.labelAction,Skin.style.currentTheme.FONT_PRIMARY);
         Skin.style.applyFont(this.labelStatus,Skin.style.currentTheme.FONT_PRIMARY);
         Skin.style.applyFont(this.labelRoaming,Skin.style.currentTheme.FONT_PRIMARY);
         Skin.style.applyStyle(this.labelPhoneName,Skin.style.currentTheme.LCDText);
         Skin.style.applyStyle(this.labelCallTime,Skin.style.currentTheme.LCDText);
         Skin.style.applyStyle(this.labelAction,Skin.style.currentTheme.LCDText);
         Skin.style.applyStyle(this.labelStatus,Skin.style.currentTheme.LCDText);
         Skin.style.applyStyle(this.labelRoaming,Skin.style.currentTheme.LCDText);
      }
   }
}

