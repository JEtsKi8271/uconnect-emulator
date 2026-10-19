package com.harman.ui
{
   import events.GlobalEvent;
   import events.SoundEvent;
   import flash.display.MovieClip;
   import flash.text.TextField;
   import skin.Skin;
   
   public class ButtonGroupTitle extends ButtonMovieClip
   {
      
      public var label:TextField;
      
      public var down:MovieClip;
      
      public var active:MovieClip;
      
      public function ButtonGroupTitle()
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
               this.down.visible = true;
               this.active.visible = false;
               Skin.style.applyStyle(this.label,Skin.style.currentTheme.primaryText);
               Skin.style.applyStyle(this.down,Skin.style.currentTheme.upStateStandard);
               break;
            case STATE_DOWN:
               this.down.visible = true;
               this.active.visible = false;
               Skin.style.applyStyle(this.label,Skin.style.currentTheme.tertiaryText);
               Skin.style.applyStyle(this.down,Skin.style.currentTheme.downStateStandard);
               break;
            case STATE_ACTIVE:
               this.down.visible = false;
               this.active.visible = true;
               Skin.style.applyStyle(this.label,Skin.style.currentTheme.primaryText);
               Skin.style.applyStyle(this.active,Skin.style.currentTheme.activeStateStandard);
               break;
            case STATE_DISABLED:
               this.down.visible = true;
               this.active.visible = false;
               Skin.style.applyStyle(this.label,Skin.style.currentTheme.disabledText);
               Skin.style.applyStyle(this.down,Skin.style.currentTheme.upStateStandard);
         }
         mCurrentState = state;
      }
      
      override protected function click() : void
      {
         if(!mFiring)
         {
            this.root.dispatchEvent(new SoundEvent(mEnabled ? SoundEvent.CLICK : SoundEvent.REJECT));
         }
         if(Boolean(mEnabled) || Boolean(alwaysClick))
         {
            this.parent.dispatchEvent(new GlobalEvent(GlobalEvent.ITEM,this));
         }
         mFiring = true;
      }
   }
}

