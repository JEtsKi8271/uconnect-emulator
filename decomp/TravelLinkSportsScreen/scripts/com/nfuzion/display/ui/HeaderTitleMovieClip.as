package com.nfuzion.display.ui
{
   import flash.display.IMovieClip;
   import flash.text.TextField;
   import skin.Skin;
   
   public dynamic class HeaderTitleMovieClip extends BaseMovieClip implements IMovieClip
   {
      
      public var value_label:TextField;
      
      public var date_label:TextField;
      
      public function HeaderTitleMovieClip()
      {
         super();
      }
      
      override protected function updateTheme() : void
      {
         Skin.style.applyFont(this.value_label,Skin.style.currentTheme.FONT_PRIMARY);
         Skin.style.applyFont(this.date_label,Skin.style.currentTheme.FONT_PRIMARY);
         Skin.style.applyStyle(this.value_label,Skin.style.currentTheme.primaryText);
         Skin.style.applyStyle(this.date_label,Skin.style.currentTheme.primaryText);
      }
   }
}

