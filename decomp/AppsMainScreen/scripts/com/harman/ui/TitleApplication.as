package com.harman.ui
{
   import flash.display.IMovieClip;
   import flash.display.MovieClip;
   import flash.text.TextField;
   import skin.Skin;
   
   public class TitleApplication extends BaseMovieClip implements IMovieClip
   {
      
      public var label:TextField;
      
      public var status:TextField;
      
      public var colorize:MovieClip;
      
      public function TitleApplication()
      {
         super();
      }
      
      override protected function updateTheme() : void
      {
         if(this.colorize)
         {
            this.colorize.visible = false;
         }
         Skin.style.applyFont(this.label,Skin.style.currentTheme.FONT_PRIMARY);
         Skin.style.applyFont(this.status,Skin.style.currentTheme.FONT_PRIMARY);
      }
   }
}

