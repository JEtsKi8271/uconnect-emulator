package com.nfuzion.display.ui
{
   import flash.display.Bitmap;
   import flash.display.IMovieClip;
   import skin.Skin;
   
   public dynamic class WallpaperBackgroundImage extends BaseMovieClip implements IMovieClip
   {
      
      protected var wallpaperBitmap:Bitmap;
      
      public function WallpaperBackgroundImage()
      {
         super();
      }
      
      override protected function updateTheme() : void
      {
         if(this.wallpaperBitmap != null)
         {
            removeChild(this.wallpaperBitmap);
         }
         this.wallpaperBitmap = new Bitmap(Skin.style.currentTheme.wallpaperBitmapData);
         addChild(this.wallpaperBitmap);
      }
   }
}

