package com.nfuzion.display.ui
{
   import flash.display.IMovieClip;
   import flash.text.TextField;
   import skin.Skin;
   
   public dynamic class HeadlineDetailsMovieClip extends BaseMovieClip implements IMovieClip
   {
      
      public var description_label:TextField;
      
      public function HeadlineDetailsMovieClip()
      {
         super();
      }
      
      override protected function updateTheme() : void
      {
         Skin.style.applyFont(this.description_label,Skin.style.currentTheme.FONT_PRIMARY);
         Skin.style.applyStyle(this.description_label,Skin.style.currentTheme.primaryText);
      }
   }
}

