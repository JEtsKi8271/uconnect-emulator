package com.harman.ui
{
   import com.nfuzion.framework.global.Framework;
   import events.GlobalEvent;
   import events.SoundEvent;
   import flash.display.MovieClip;
   import flash.text.TextField;
   import skin.Skin;
   
   public class ButtonCategory extends ButtonMovieClip
   {
      
      public var label:TextField;
      
      public var icon:MovieClip;
      
      public var down:MovieClip;
      
      public var active:MovieClip;
      
      public function ButtonCategory()
      {
         super();
      }
      
      override protected function setFont() : void
      {
         if(this.label)
         {
            Skin.style.applyFont(this.label,Skin.style.currentTheme.FONT_PRIMARY);
         }
      }
      
      override protected function click() : void
      {
         mFiring = true;
         Framework.messenger.dispatchEvent(new SoundEvent(SoundEvent.CLICK));
         this.parent.dispatchEvent(new GlobalEvent(GlobalEvent.CATEGORY,this));
      }
      
      override public function setState(state:int) : void
      {
         switch(state)
         {
            case STATE_UP:
               this.down.visible = false;
               this.active.visible = false;
               if(this.label)
               {
                  Skin.style.applyStyle(this.label,Skin.style.currentTheme.primaryText);
               }
               break;
            case STATE_DOWN:
               this.down.visible = true;
               this.active.visible = false;
               if(this.label)
               {
                  Skin.style.applyStyle(this.label,Skin.style.currentTheme.tertiaryText);
               }
               Skin.style.applyStyle(this.down,Skin.style.currentTheme.downStateStandard);
               break;
            case STATE_ACTIVE:
               this.down.visible = false;
               this.active.visible = true;
               if(this.label)
               {
                  Skin.style.applyStyle(this.label,Skin.style.currentTheme.primaryText);
               }
               Skin.style.applyStyle(this.active,Skin.style.currentTheme.activeStateStandard);
               break;
            case STATE_DISABLED:
               this.down.visible = false;
               this.active.visible = false;
               if(this.label)
               {
                  Skin.style.applyStyle(this.label,Skin.style.currentTheme.disabledText);
               }
         }
         mCurrentState = state;
      }
   }
}

