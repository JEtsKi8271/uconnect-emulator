package com.nfuzion.display.ui
{
   import flash.display.IMovieClip;
   import flash.display.MovieClip;
   import skin.Skin;
   
   public dynamic class MainMenuScreenViewMovieClip extends BaseMovieClip implements IMovieClip
   {
      
      public var fanSpeed_group:MovieClip;
      
      public function MainMenuScreenViewMovieClip()
      {
         super();
      }
      
      override protected function updateTheme() : void
      {
         Skin.style.applyFont(this.fanSpeed_group.value_label,Skin.style.currentTheme.FONT_PRIMARY);
         Skin.style.applyStyle(this.fanSpeed_group.value_label,Skin.style.currentTheme.primaryText);
         Skin.style.applyFont(this.climate_button.icon.vents.off,Skin.style.currentTheme.FONT_PRIMARY);
      }
   }
}

