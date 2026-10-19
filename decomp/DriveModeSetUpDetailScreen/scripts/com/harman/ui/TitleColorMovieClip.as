package com.harman.ui
{
   import flash.display.IMovieClip;
   import flash.display.MovieClip;
   import flash.text.TextField;
   import skin.Skin;
   
   public class TitleColorMovieClip extends BaseMovieClip implements IMovieClip
   {
      
      public var colorize:MovieClip;
      
      public var label:TextField;
      
      public function TitleColorMovieClip()
      {
         super();
      }
      
      override protected function updateTheme() : void
      {
         Skin.style.applyFont(this.label,Skin.style.currentTheme.FONT_PRIMARY);
      }
      
      public function updateBackgroud(color:uint) : void
      {
         Skin.style.applyStyle(this.colorize,{
            "method":"colorTransform",
            "alpha":1,
            "color":{
               "hexValue":color,
               "hue":0,
               "saturation":100,
               "brightness":100,
               "contrast":0
            }
         });
      }
   }
}

