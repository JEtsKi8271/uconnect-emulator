package com.harman.ui
{
   import events.GlobalEvent;
   import events.SoundEvent;
   import flash.display.MovieClip;
   import flash.events.TimerEvent;
   import skin.Skin;
   
   public class ButtonIncrementer extends ButtonMovieClip
   {
      
      public var id:int;
      
      public var icon:MovieClip;
      
      public var colorize:MovieClip;
      
      public function ButtonIncrementer()
      {
         super();
         auto = 500;
      }
      
      override protected function updateTheme() : void
      {
         Skin.style.applyStyle(this.colorize,Skin.style.currentTheme.downStateStandard);
         super.updateTheme();
      }
      
      override protected function click() : void
      {
         if(!mFiring)
         {
            this.root.dispatchEvent(new SoundEvent(mEnabled ? SoundEvent.SET : SoundEvent.REJECT));
            if(mEnabled)
            {
               this.parent.parent.parent.dispatchEvent(new GlobalEvent(GlobalEvent.ITEM,this));
            }
         }
      }
      
      override protected function onAutoClick(e:TimerEvent) : void
      {
         if(!mFiring)
         {
            this.root.dispatchEvent(new SoundEvent(mEnabled ? SoundEvent.SET : SoundEvent.REJECT));
         }
         if(mEnabled)
         {
            this.parent.parent.parent.dispatchEvent(new GlobalEvent(GlobalEvent.ITEM,this));
         }
         mFiring = true;
      }
      
      override public function setState(state:int) : void
      {
         switch(state)
         {
            case STATE_UP:
               this.colorize.visible = false;
               Skin.style.applyStyle(this.icon,Skin.style.currentTheme.standardUpIcon);
               break;
            case STATE_DOWN:
               this.colorize.visible = true;
               Skin.style.applyStyle(this.icon,Skin.style.currentTheme.standardDownIcon);
               break;
            case STATE_ACTIVE:
               this.colorize.visible = true;
               Skin.style.applyStyle(this.icon,Skin.style.currentTheme.standardActiveIcon);
               break;
            case STATE_DISABLED:
               this.colorize.visible = false;
               Skin.style.applyStyle(this.icon,Skin.style.currentTheme.standardDisabledIcon);
         }
         mCurrentState = state;
      }
   }
}

