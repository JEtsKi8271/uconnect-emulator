package com.harman.ui
{
   import flash.display.IMovieClip;
   import flash.text.TextField;
   import flash.utils.Dictionary;
   import skin.Skin;
   
   public dynamic class ScreenAppsHome extends BaseMovieClip implements IMovieClip
   {
      
      public var label_pressAndHold:TextField;
      
      public var COOR:Dictionary = new Dictionary();
      
      public var screenWidth:int = 640;
      
      public function ScreenAppsHome()
      {
         this.COOR[0] = [20,10];
         this.COOR[1] = [154,10];
         this.COOR[2] = [288,10];
         this.COOR[3] = [422,10];
         this.COOR[4] = [20,110];
         this.COOR[5] = [154,110];
         this.COOR[6] = [288,110];
         this.COOR[7] = [422,110];
         this.COOR[8] = [20,210];
         this.COOR[9] = [154,210];
         this.COOR[10] = [288,210];
         this.COOR[11] = [422,210];
         super();
      }
      
      override protected function updateTheme() : void
      {
         Skin.style.applyFont(this.label_pressAndHold,Skin.style.currentTheme.FONT_PRIMARY);
         Skin.style.applyStyle(this.label_pressAndHold,{
            "method":"format",
            "color":{"hexValue":10921637},
            "alpha":1
         });
      }
   }
}

