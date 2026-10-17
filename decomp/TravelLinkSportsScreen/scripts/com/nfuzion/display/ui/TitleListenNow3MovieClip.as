package com.nfuzion.display.ui
{
   import flash.display.IMovieClip;
   import flash.text.TextField;
   import skin.Skin;
   
   public dynamic class TitleListenNow3MovieClip extends BaseMovieClip implements IMovieClip
   {
      
      public var value1_label:TextField;
      
      public var value2_label:TextField;
      
      public var value3_label:TextField;
      
      public function TitleListenNow3MovieClip()
      {
         super();
      }
      
      override protected function updateTheme() : void
      {
         Skin.style.applyFont(this.value1_label,Skin.style.currentTheme.FONT_PRIMARY);
         Skin.style.applyFont(this.value2_label,Skin.style.currentTheme.FONT_PRIMARY);
         Skin.style.applyFont(this.value3_label,Skin.style.currentTheme.FONT_PRIMARY);
         Skin.style.applyStyle(this.value1_label,Skin.style.currentTheme.titleText);
         Skin.style.applyStyle(this.value2_label,Skin.style.currentTheme.titleText);
         Skin.style.applyStyle(this.value3_label,Skin.style.currentTheme.titleText);
      }
   }
}

