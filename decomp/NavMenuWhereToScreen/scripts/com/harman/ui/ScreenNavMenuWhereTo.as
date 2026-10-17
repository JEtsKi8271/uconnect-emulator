package com.harman.ui
{
   import core.locale.LocaleArchive;
   import core.utils.Graphic;
   import flash.display.MovieClip;
   
   public dynamic class ScreenNavMenuWhereTo extends ScreenMovieClip
   {
      
      public var back_button:MovieClip;
      
      public var close_button:MovieClip;
      
      public var window:MovieClip;
      
      public var background:MovieClip;
      
      public function ScreenNavMenuWhereTo()
      {
         super();
      }
      
      override protected function updateAlignment() : void
      {
         Graphic.mirror(this.back_button);
         Graphic.mirror(this.close_button);
         Graphic.mirror(this.background);
         if(LocaleArchive.getInstance().isMirrored())
         {
            this.pageup_button.x = 29;
            this.pagedown_button.x = 29;
            this.slider.x = 29;
            this.back_button.x = 630;
            this.close_button.x = 98;
            this.background.x = 641;
            this.window.x = 106;
            this.window.item0_button.x = 354;
            this.window.item1_button.x = 177;
            this.window.item2_button.x = 0;
            this.window.item3_button.x = 354;
            this.window.item4_button.x = 177;
            this.window.item5_button.x = 0;
         }
         else
         {
            this.pageup_button.x = 563;
            this.pagedown_button.x = 563;
            this.slider.x = 563;
            this.back_button.x = 10;
            this.close_button.x = 544;
            this.background.x = 0;
            this.window.x = 13;
            this.window.item0_button.x = 0;
            this.window.item1_button.x = 177;
            this.window.item2_button.x = 354;
            this.window.item3_button.x = 0;
            this.window.item4_button.x = 177;
            this.window.item5_button.x = 354;
         }
      }
   }
}

