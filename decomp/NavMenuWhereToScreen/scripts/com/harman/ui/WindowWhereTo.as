package com.harman.ui
{
   public class WindowWhereTo extends WindowMovieClip
   {
      
      public const LENGTH:int = 6;
      
      public var item0_button:ButtonListWhereTo;
      
      public var item1_button:ButtonListWhereTo;
      
      public var item2_button:ButtonListWhereTo;
      
      public var item3_button:ButtonListWhereTo;
      
      public var item4_button:ButtonListWhereTo;
      
      public var item5_button:ButtonListWhereTo;
      
      public function WindowWhereTo()
      {
         super();
         this.item0_button.sel = 0;
         this.item1_button.sel = 1;
         this.item2_button.sel = 2;
         this.item3_button.sel = 3;
         this.item4_button.sel = 4;
         this.item5_button.sel = 5;
      }
   }
}

