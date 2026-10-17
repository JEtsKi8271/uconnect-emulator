package com.harman.ui
{
   import flash.display.IMovieClip;
   import flash.display.MovieClip;
   import flash.filters.GlowFilter;
   import flash.text.TextField;
   import skin.Skin;
   
   public dynamic class ButtonListWhereTo extends ButtonMovieClip implements IMovieClip
   {
      
      public var icon:MovieClip;
      
      public var label:TextField;
      
      private var mBorderFilter:GlowFilter = new GlowFilter(Skin.style.currentTheme.activeGraphic.color.hexValue,0.5,35,35,2,1);
      
      public function ButtonListWhereTo()
      {
         super();
      }
      
      override protected function setFont() : void
      {
         Skin.style.applyFont(this.label,Skin.style.currentTheme.FONT_PRIMARY);
      }
      
      override public function setState(state:int) : void
      {
         switch(state)
         {
            case STATE_UP:
               this.icon.filters = [];
               break;
            case STATE_DOWN:
               this.icon.filters = [this.mBorderFilter];
               break;
            case STATE_ACTIVE:
               this.icon.filters = [];
               break;
            case STATE_DISABLED:
               this.icon.filters = [];
         }
         mCurrentState = state;
      }
   }
}

