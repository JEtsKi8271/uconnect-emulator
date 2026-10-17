package com.nfuzion.display.ui
{
   import flash.display.IMovieClip;
   import flash.text.TextField;
   import skin.Skin;
   
   public dynamic class ListItemPlayerBrowseButtonMovieClip extends ListButtonMovieClip implements IMovieClip
   {
      
      public var labelText:TextField;
      
      public function ListItemPlayerBrowseButtonMovieClip()
      {
         super();
      }
      
      override protected function setButtonFont() : void
      {
         Skin.style.applyFont(this.labelText,Skin.style.currentTheme.FONT_PRIMARY);
      }
      
      override protected function setButtonTextColors() : void
      {
         Skin.style.applyStyle(this.labelText,Skin.style.currentTheme.primaryText);
      }
   }
}

