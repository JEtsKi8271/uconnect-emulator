package com.harman.ui
{
   import flash.display.MovieClip;
   import flash.text.TextField;
   import skin.Skin;
   
   public class TextGroup extends BaseMovieClip
   {
      
      public var eco_icon:MovieClip;
      
      public var icon:MovieClip;
      
      public var label:TextField;
      
      public var value:TextField;
      
      public var value_bg:MovieClip;
      
      public function TextGroup()
      {
         super();
      }
      
      override protected function updateTheme() : void
      {
         Skin.style.applyFont(this.label,Skin.style.currentTheme.FONT_PRIMARY);
         Skin.style.applyStyle(this.label,Skin.style.currentTheme.primaryText);
         Skin.style.applyFont(this.value,Skin.style.currentTheme.FONT_PRIMARY);
         Skin.style.applyStyle(this.value,Skin.style.currentTheme.primaryText);
      }
   }
}

