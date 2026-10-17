package com.harman.ui
{
   import events.WidgetEvent;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import skin.Skin;
   
   public class ButtonSticky extends ButtonMovieClip
   {
      
      public var icon:MovieClip;
      
      public var down:MovieClip;
      
      public var active:MovieClip;
      
      public var mMouseDown:Boolean;
      
      public function ButtonSticky()
      {
         super();
      }
      
      override protected function onMouseDown(e:MouseEvent) : void
      {
         this.mMouseDown = true;
         super.onMouseDown(e);
         if(mEnabled)
         {
            this.dispatchEvent(new WidgetEvent(WidgetEvent.PRESS,this));
         }
      }
      
      override protected function onMouseOut(e:MouseEvent) : void
      {
         if(this.mMouseDown)
         {
            this.mMouseDown = false;
            super.onMouseOut(e);
            if(mEnabled)
            {
               this.dispatchEvent(new WidgetEvent(WidgetEvent.RELEASE,this));
            }
         }
      }
      
      override protected function onMouseClick(e:MouseEvent) : void
      {
         if(this.mMouseDown)
         {
            this.mMouseDown = false;
            super.onMouseClick(e);
         }
      }
      
      override protected function click() : void
      {
         super.click();
         if(mEnabled)
         {
            this.dispatchEvent(new WidgetEvent(WidgetEvent.RELEASE,this));
         }
      }
      
      override public function setEnabled(enabled:Boolean) : void
      {
         if(!enabled && this.mMouseDown)
         {
            this.dispatchEvent(new WidgetEvent(WidgetEvent.RELEASE,this));
         }
         super.setEnabled(enabled);
      }
      
      override public function setState(state:int) : void
      {
         switch(state)
         {
            case STATE_UP:
               this.down.visible = false;
               this.active.visible = false;
               Skin.style.applyStyle(this.icon,Skin.style.currentTheme.standardUpIcon);
               break;
            case STATE_DOWN:
               this.down.visible = true;
               this.active.visible = false;
               Skin.style.applyStyle(this.icon,Skin.style.currentTheme.standardDownIcon);
               Skin.style.applyStyle(this.down,Skin.style.currentTheme.downStateStandard);
               break;
            case STATE_ACTIVE:
               this.down.visible = false;
               this.active.visible = true;
               Skin.style.applyStyle(this.icon,Skin.style.currentTheme.standardActiveIcon);
               Skin.style.applyStyle(this.active,Skin.style.currentTheme.activeStateStandard);
               break;
            case STATE_DISABLED:
               this.down.visible = false;
               this.active.visible = false;
               Skin.style.applyStyle(this.icon,Skin.style.currentTheme.standardDisabledIcon);
         }
         mCurrentState = state;
      }
   }
}

