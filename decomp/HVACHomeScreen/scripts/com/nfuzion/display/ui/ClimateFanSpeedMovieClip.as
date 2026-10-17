package com.nfuzion.display.ui
{
   import flash.display.IMovieClip;
   import flash.text.TextField;
   import skin.Skin;
   
   public dynamic class ClimateFanSpeedMovieClip extends BaseMovieClip implements IMovieClip
   {
      
      public var fanBar_label:TextField;
      
      public var number_label:TextField;
      
      public function ClimateFanSpeedMovieClip()
      {
         super();
      }
      
      override protected function updateTheme() : void
      {
         if(this.fanBar_label != null)
         {
            Skin.style.applyFont(this.fanBar_label,Skin.style.currentTheme.FONT_PRIMARY);
            Skin.style.applyStyle(this.fanBar_label,Skin.style.currentTheme.primaryText);
         }
         if(this.number_label != null)
         {
            Skin.style.applyFont(this.number_label,Skin.style.currentTheme.FONT_PRIMARY);
         }
      }
   }
}

