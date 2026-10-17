package com.nfuzion.display.ui
{
   import flash.display.IMovieClip;
   import flash.text.TextField;
   import skin.Skin;
   
   public dynamic class DisplayTitleMovieClip extends BaseMovieClip implements IMovieClip
   {
      
      public var labelValue:TextField;
      
      public function DisplayTitleMovieClip()
      {
         super();
      }
      
      override protected function updateTheme() : void
      {
         Skin.style.applyFont(this.labelValue,Skin.style.currentTheme.FONT_PRIMARY);
         Skin.style.applyStyle(this.labelValue,Skin.style.currentTheme.primaryText);
      }
   }
}

