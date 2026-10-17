package com.harman.ui
{
   import flash.display.IMovieClip;
   import skin.Skin;
   
   public dynamic class CursorMovieClip extends BaseMovieClip implements IMovieClip
   {
      
      public function CursorMovieClip()
      {
         this.visible = false;
         this.mouseEnabled = false;
         super();
      }
      
      override protected function updateTheme() : void
      {
         Skin.style.applyStyle(this,Skin.style.currentTheme.cursorActive);
      }
   }
}

