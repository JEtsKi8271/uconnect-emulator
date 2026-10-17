package com.harman.ui
{
   import events.SoundEvent;
   import events.WidgetEvent;
   import flash.display.MovieClip;
   import flash.text.TextField;
   import skin.Skin;
   
   public class ButtonSplitSource extends ButtonMovieClip
   {
      
      public var label:TextField;
      
      public var icon:MovieClip;
      
      public var down:MovieClip;
      
      public var active:MovieClip;
      
      public function ButtonSplitSource()
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
      
      override protected function click() : void
      {
         if(mEnabled)
         {
            this.root.dispatchEvent(new SoundEvent(SoundEvent.CLICK));
            this.parent.dispatchEvent(new WidgetEvent(WidgetEvent.CLICK,this));
         }
         else
         {
            this.root.dispatchEvent(new SoundEvent(SoundEvent.REJECT));
         }
      }
   }
}

