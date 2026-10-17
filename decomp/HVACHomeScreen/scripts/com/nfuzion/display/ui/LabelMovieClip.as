package com.nfuzion.display.ui
{
   import flash.display.IMovieClip;
   import flash.text.TextField;
   import skin.Skin;
   
   public dynamic class LabelMovieClip extends BaseMovieClip implements IMovieClip
   {
      
      public var value_label:TextField;
      
      public function LabelMovieClip()
      {
         super();
      }
      
      override protected function updateTheme() : void
      {
         Skin.style.applyFont(this.value_label,Skin.style.currentTheme.FONT_PRIMARY);
         Skin.style.applyStyle(this.value_label,Skin.style.currentTheme.primaryText);
      }
   }
}

