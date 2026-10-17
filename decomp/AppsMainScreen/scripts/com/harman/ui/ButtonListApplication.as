package com.harman.ui
{
   import com.nfuzion.framework.global.Framework;
   import events.GlobalEvent;
   import events.SoundEvent;
   import events.WidgetEvent;
   import flash.display.IMovieClip;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import skin.Skin;
   
   public dynamic class ButtonListApplication extends ButtonMovieClip implements IMovieClip
   {
      
      public static const ENABLED:int = 0;
      
      public static const CAUTION:int = 1;
      
      public static const CONFIRM:int = 2;
      
      public static const WARNING:int = 3;
      
      public static const DISABLE:int = 4;
      
      public var id:int = 0;
      
      public var sel:int = 0;
      
      public var window:MovieClip;
      
      public var gloss:MovieClip;
      
      public var down:MovieClip;
      
      public var active:MovieClip;
      
      public var label:TextField;
      
      public var select:TextField;
      
      public var labelColor:int = 0;
      
      public function ButtonListApplication()
      {
         super();
      }
      
      override protected function updateTheme() : void
      {
         super.updateTheme();
         Skin.style.applyStyle(this.down,Skin.style.currentTheme.downStateList);
         Skin.style.applyStyle(this.active,Skin.style.currentTheme.activeStateList);
      }
      
      override protected function setFont() : void
      {
         Skin.style.applyFont(this.label,Skin.style.currentTheme.FONT_PRIMARY);
         Skin.style.applyFont(this.select,Skin.style.currentTheme.FONT_PRIMARY);
      }
      
      override protected function onMouseDown(e:MouseEvent) : void
      {
         if(mEnabled)
         {
            this.parent.dispatchEvent(new WidgetEvent(WidgetEvent.PRESS,this));
            this.setState(STATE_DOWN);
         }
      }
      
      override protected function click() : void
      {
         if(!mFiring)
         {
            Framework.messenger.dispatchEvent(new SoundEvent(mCurrentState != STATE_DISABLED ? SoundEvent.CLICK : SoundEvent.REJECT));
         }
         if(mCurrentState != STATE_DISABLED)
         {
            this.parent.dispatchEvent(new GlobalEvent(GlobalEvent.ITEM,this));
         }
         else
         {
            this.parent.dispatchEvent(new GlobalEvent(GlobalEvent.ITEMDISABLED,this));
         }
         mFiring = true;
      }
      
      override public function setState(state:int) : void
      {
         switch(state)
         {
            case STATE_UP:
               this.textColor = this.labelColor;
               this.gloss.visible = false;
               this.down.visible = false;
               this.active.visible = false;
               break;
            case STATE_DOWN:
               this.gloss.visible = true;
               this.down.visible = true;
               this.active.visible = false;
               break;
            case STATE_ACTIVE:
               this.gloss.visible = true;
               this.down.visible = false;
               this.active.visible = true;
               break;
            case STATE_DISABLED:
               this.gloss.visible = false;
               this.down.visible = false;
               this.active.visible = false;
         }
         mCurrentState = state;
      }
      
      public function set textColor(color:int) : void
      {
         switch(color)
         {
            case ENABLED:
               Skin.style.applyStyle(this.label,Skin.style.currentTheme.primaryText);
               break;
            case CAUTION:
               Skin.style.applyStyle(this.label,Skin.style.currentTheme.alertCautionText);
               break;
            case CONFIRM:
               Skin.style.applyStyle(this.label,Skin.style.currentTheme.alertNoneText);
               break;
            case WARNING:
               Skin.style.applyStyle(this.label,Skin.style.currentTheme.alertWarningText);
               break;
            case DISABLE:
               Skin.style.applyStyle(this.label,Skin.style.currentTheme.disabledText);
         }
         this.labelColor = color;
      }
   }
}

