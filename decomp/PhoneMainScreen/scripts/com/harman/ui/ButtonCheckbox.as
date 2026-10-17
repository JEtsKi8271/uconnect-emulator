package com.harman.ui
{
   import com.nfuzion.framework.global.Framework;
   import events.GlobalEvent;
   import events.SoundEvent;
   import flash.display.MovieClip;
   import skin.Skin;
   
   public class ButtonCheckbox extends ButtonMovieClip
   {
      
      public var id:int = 0;
      
      public var select:int = 0;
      
      public var icon:MovieClip;
      
      public var down:MovieClip;
      
      public var sound:String = "events.SoundEvent.set";
      
      public function ButtonCheckbox()
      {
         super();
      }
      
      override public function setHighlight(active:Boolean) : void
      {
         this.icon.visible = active;
         if(mActive != active)
         {
            if(mEnabled)
            {
               mActive = active;
               this.setState(mActive ? int(STATE_ACTIVE) : int(STATE_UP));
            }
         }
      }
      
      override protected function click() : void
      {
         Framework.messenger.dispatchEvent(new SoundEvent(mCurrentState != STATE_DISABLED ? this.sound : SoundEvent.REJECT));
         mFiring = true;
         this.parent.dispatchEvent(new GlobalEvent(GlobalEvent.CHECKBOX,this));
      }
      
      override public function setState(state:int) : void
      {
         switch(state)
         {
            case STATE_UP:
               this.down.visible = false;
               Skin.style.applyStyle(this.icon,Skin.style.currentTheme.disabledIcon);
               break;
            case STATE_DOWN:
               this.down.visible = true;
               Skin.style.applyStyle(this.icon,Skin.style.currentTheme.downIcon);
               Skin.style.applyStyle(this.down,Skin.style.currentTheme.downStateStandard);
               break;
            case STATE_ACTIVE:
               this.down.visible = false;
               Skin.style.applyStyle(this.icon,Skin.style.currentTheme.activeIcon);
               break;
            case STATE_DISABLED:
               this.down.visible = false;
               Skin.style.applyStyle(this.icon,Skin.style.currentTheme.disabledIcon);
         }
         mCurrentState = state;
      }
   }
}

