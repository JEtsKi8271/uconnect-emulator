package com.harman.ui
{
   import core.utils.Text;
   
   public dynamic class ScreenDriveModeSetUp extends ScreenMovieClip
   {
      
      public var displayTitle:TitleMovieClip;
      
      public function ScreenDriveModeSetUp()
      {
         super();
      }
      
      override protected function updateAlignment() : void
      {
         Text.align(this.displayTitle.label);
      }
   }
}

