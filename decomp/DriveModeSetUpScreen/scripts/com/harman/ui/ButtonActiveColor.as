package com.harman.ui
{
   import events.GlobalEvent;
   import events.SoundEvent;
   import flash.display.IMovieClip;
   import flash.display.MovieClip;
   import flash.text.TextField;
   import skin.Skin;
   
   public class ButtonActiveColor extends ButtonMovieClip implements IMovieClip
   {
      
      public var label:TextField;
      
      public var down:MovieClip;
      
      public var active:MovieClip;
      
      protected var mActiveColor:uint;
      
      private var mDisableClickEnable:Boolean = true;
      
      public function ButtonActiveColor(color:uint)
      {
         this.mActiveColor = color;
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
               Skin.style.applyStyle(this.active,{
                  "method":"colorTransform",
                  "alpha":1,
                  "color":{
                     "hexValue":this.mActiveColor,
                     "hue":0,
                     "saturation":100,
                     "brightness":100,
                     "contrast":0
                  }
               });
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
         if(Boolean(mEnabled) || this.mDisableClickEnable)
         {
            this.parent.dispatchEvent(new GlobalEvent(GlobalEvent.ITEM,this));
         }
         mFiring = true;
      }
      
      public function setDisableClickEnable(enable:Boolean) : void
      {
         this.mDisableClickEnable = enable;
      }
   }
}

