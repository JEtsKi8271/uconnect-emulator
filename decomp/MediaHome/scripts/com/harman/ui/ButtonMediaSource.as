package com.harman.ui
{
   import events.SoundEvent;
   import events.WidgetEvent;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import skin.Skin;
   
   public class ButtonMediaSource extends ButtonMovieClip
   {
      
      public var label:TextField;
      
      public var icon:MovieClip;
      
      public var down:MovieClip;
      
      public var active:MovieClip;
      
      public function ButtonMediaSource()
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
               this.down.visible = false;
               this.active.visible = false;
               this.label;
               Skin.style.applyStyle(this.label,Skin.style.currentTheme.primaryText);
               Skin.style.applyStyle(this.icon,Skin.style.currentTheme.standardUpIcon);
               break;
            case STATE_DOWN:
               this.down.visible = true;
               this.active.visible = false;
               this.label;
               Skin.style.applyStyle(this.label,Skin.style.currentTheme.tertiaryText);
               Skin.style.applyStyle(this.icon,Skin.style.currentTheme.standardDownIcon);
               Skin.style.applyStyle(this.down,Skin.style.currentTheme.downStateStandard);
               break;
            case STATE_ACTIVE:
               this.down.visible = false;
               this.active.visible = true;
               this.label;
               Skin.style.applyStyle(this.label,Skin.style.currentTheme.primaryText);
               Skin.style.applyStyle(this.icon,Skin.style.currentTheme.standardActiveIcon);
               Skin.style.applyStyle(this.active,Skin.style.currentTheme.activeStateStandard);
               break;
            case STATE_DISABLED:
               this.down.visible = false;
               this.active.visible = false;
               this.label;
               Skin.style.applyStyle(this.label,Skin.style.currentTheme.disabledText);
               Skin.style.applyStyle(this.icon,Skin.style.currentTheme.standardDisabledIcon);
         }
         mCurrentState = state;
      }
      
      override protected function onMouseDown(e:MouseEvent) : void
      {
         this.setState(STATE_DOWN);
      }
      
      override protected function onMouseOut(e:MouseEvent) : void
      {
         if(mActive)
         {
            this.setState(STATE_ACTIVE);
         }
         else
         {
            this.setState(mEnabled ? int(STATE_UP) : int(STATE_DISABLED));
         }
      }
      
      override protected function onMouseClick(e:MouseEvent) : void
      {
         if(mActive)
         {
            this.setState(STATE_ACTIVE);
         }
         else
         {
            this.setState(mEnabled ? int(STATE_UP) : int(STATE_DISABLED));
         }
         this.click();
      }
      
      override protected function click() : void
      {
         this.root.dispatchEvent(new SoundEvent(mEnabled ? SoundEvent.CLICK : SoundEvent.REJECT));
         this.parent.dispatchEvent(new WidgetEvent(WidgetEvent.CLICK,this));
      }
      
      override public function setHighlight(active:Boolean) : void
      {
         mActive = active;
         if(mActive)
         {
            this.setState(STATE_ACTIVE);
         }
         else
         {
            this.setState(mEnabled ? int(STATE_UP) : int(STATE_DISABLED));
         }
      }
   }
}

