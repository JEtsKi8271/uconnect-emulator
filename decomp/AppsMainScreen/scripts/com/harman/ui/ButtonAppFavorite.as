package com.harman.ui
{
   import com.nfuzion.framework.global.Framework;
   import events.GlobalEvent;
   import events.SoundEvent;
   import flash.display.MovieClip;
   import skin.Skin;
   
   public class ButtonAppFavorite extends ButtonMovieClip
   {
      
      public var id:int = 0;
      
      public var select:int = 0;
      
      public var icon:MovieClip;
      
      public var colorize:MovieClip;
      
      public function ButtonAppFavorite()
      {
         super();
      }
      
      override protected function click() : void
      {
         mFiring = true;
         Framework.messenger.dispatchEvent(new SoundEvent(SoundEvent.CLICK));
         this.parent.dispatchEvent(new GlobalEvent(GlobalEvent.OPTION,this));
      }
      
      override public function setState(state:int) : void
      {
         switch(state)
         {
            case STATE_UP:
               Skin.style.applyStyle(this.colorize,Skin.style.currentTheme.upStateStandard);
               break;
            case STATE_DOWN:
               Skin.style.applyStyle(this.colorize,Skin.style.currentTheme.downStateStandard);
               break;
            case STATE_ACTIVE:
               Skin.style.applyStyle(this.colorize,Skin.style.currentTheme.activeStateStandard);
               break;
            case STATE_DISABLED:
               Skin.style.applyStyle(this.colorize,Skin.style.currentTheme.upStateStandard);
         }
         mCurrentState = state;
      }
   }
}

