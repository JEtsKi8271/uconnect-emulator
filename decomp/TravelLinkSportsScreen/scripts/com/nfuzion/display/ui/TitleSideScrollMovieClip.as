package com.nfuzion.display.ui
{
   import flash.display.IMovieClip;
   import flash.text.TextField;
   import skin.Skin;
   
   public dynamic class TitleSideScrollMovieClip extends BaseMovieClip implements IMovieClip
   {
      
      public var value1a_label:TextField;
      
      public var value2a_label:TextField;
      
      public var value1b_label:TextField;
      
      public var value2b_label:TextField;
      
      public var value3b_label:TextField;
      
      public var value1c_label:TextField;
      
      public var value2c_label:TextField;
      
      public var value3c_label:TextField;
      
      public var value4c_label:TextField;
      
      public function TitleSideScrollMovieClip()
      {
         super();
      }
      
      override protected function updateTheme() : void
      {
         Skin.style.applyFont(this.value1_label,Skin.style.currentTheme.FONT_PRIMARY);
         Skin.style.applyFont(this.value2_label,Skin.style.currentTheme.FONT_PRIMARY);
         Skin.style.applyStyle(this.value1_label,Skin.style.currentTheme.titleText);
         Skin.style.applyStyle(this.value2_label,Skin.style.currentTheme.titleText);
      }
   }
}

