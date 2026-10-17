package com.harman.ui
{
   import com.nfuzion.framework.global.Framework;
   import events.GlobalEvent;
   import events.SoundEvent;
   import flash.display.MovieClip;
   import skin.Skin;
   
   public class ButtonCheckboxSettings extends ButtonMovieClip
   {
      
      public var id:uint;
      
      public var icon:MovieClip;
      
      public var down:MovieClip;
      
      public var sound:String = "events.SoundEvent.set";
      
      public function ButtonCheckboxSettings()
      {
         this.mouseChildren = false;
         super();
      }
      
      override protected function click() : void
      {
         Framework.messenger.dispatchEvent(new SoundEvent(mCurrentState != STATE_DISABLED ? this.sound : SoundEvent.REJECT));
         if(mCurrentState != STATE_DISABLED)
         {
            this.parent.parent.dispatchEvent(new GlobalEvent(GlobalEvent.ITEM,this));
         }
         else
         {
            this.parent.parent.dispatchEvent(new GlobalEvent(GlobalEvent.ITEMDISABLED,this));
         }
         mFiring = true;
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
      
      override public function setState(state:int) : void
      {
         switch(state)
         {
            case STATE_UP:
               this.down.visible = false;
               break;
            case STATE_DOWN:
               this.down.visible = true;
               Skin.style.applyStyle(this.down,Skin.style.currentTheme.downStateStandard);
               break;
            case STATE_ACTIVE:
               this.down.visible = false;
               break;
            case STATE_DISABLED:
               this.down.visible = false;
         }
         mCurrentState = state;
      }
   }
}

