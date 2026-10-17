package com.nfuzion.display.ui
{
   import flash.display.IMovieClip;
   import flash.display.MovieClip;
   import flash.text.TextField;
   import skin.Skin;
   
   public dynamic class TrackListButtonMovieClip extends ButtonMovieClip implements IMovieClip
   {
      
      public var name_label:TextField;
      
      public var number_label:TextField;
      
      public var playIcon:MovieClip;
      
      public function TrackListButtonMovieClip()
      {
         super();
      }
      
      override protected function setButtonImageColors() : void
      {
         Skin.style.applyStyle(this.btnDown,Skin.style.currentTheme.standardGraphic);
         Skin.style.applyStyle(this.btnActive,Skin.style.currentTheme.activeGraphic);
         Skin.style.applyStyle(this.playIcon,Skin.style.currentTheme.activeGraphic);
      }
      
      override protected function setButtonFont() : void
      {
         Skin.style.applyFont(this.name_label,Skin.style.currentTheme.FONT_PRIMARY);
         Skin.style.applyFont(this.number_label,Skin.style.currentTheme.FONT_PRIMARY);
      }
      
      override protected function setButtonTextColors() : void
      {
         Skin.style.applyStyle(this.name_label,Skin.style.currentTheme.primaryText);
         Skin.style.applyStyle(this.number_label,Skin.style.currentTheme.primaryText);
      }
   }
}

