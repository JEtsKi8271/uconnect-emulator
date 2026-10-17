package com.nfuzion.display.ui
{
   import flash.display.IMovieClip;
   import flash.display.MovieClip;
   
   public dynamic class ScrollbarComponentHVAC extends MovieClip implements IMovieClip
   {
      
      public var upArrow_button:ButtonMovieClip;
      
      public var downArrow_button:ButtonMovieClip;
      
      public var thumb:HVACThumbMovieClip;
      
      public var popupDisplay:LabelMovieClip;
      
      public var track:MovieClip;
      
      public function ScrollbarComponentHVAC()
      {
         super();
      }
   }
}

