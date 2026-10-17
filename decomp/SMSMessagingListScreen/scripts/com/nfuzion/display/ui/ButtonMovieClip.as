package com.nfuzion.display.ui
{
   import flash.display.IMovieClip;
   import flash.display.MovieClip;
   import flash.text.TextField;
   import skin.Skin;
   
   public dynamic class ButtonMovieClip extends BaseMovieClip implements IMovieClip
   {
      
      protected const STATE_UP:String = "up";
      
      protected const STATE_DOWN:String = "down";
      
      protected const STATE_ACTIVE:String = "active";
      
      protected const STATE_DISABLED:String = "disabled";
      
      public var btnUp:MovieClip;
      
      public var btnDown:MovieClip;
      
      public var btnActive:MovieClip;
      
      public var btnDisabled:MovieClip;
      
      public var value_label:TextField;
      
      public var icon:MovieClip;
      
      protected var mCurrentState:String;
      
      public function ButtonMovieClip()
      {
         super();
      }
      
      override protected function updateTheme() : void
      {
         this.mCurrentState = this.getStateFromFrameLabel();
         if(super.mIsChangingFrame == false)
         {
            this.setButtonFont();
         }
         this.setButtonImageColors();
         this.setButtonTextColors();
         this.setButtonIconColor();
         this.showOrHideButtonImages();
      }
      
      protected function setButtonFont() : void
      {
         if(this.value_label != null)
         {
            Skin.style.applyFont(this.value_label,Skin.style.currentTheme.FONT_PRIMARY);
         }
      }
      
      protected function setButtonImageColors() : void
      {
         Skin.style.applyStyle(this.btnDown,Skin.style.currentTheme.downStateStandard);
         Skin.style.applyStyle(this.btnActive,Skin.style.currentTheme.activeStateStandard);
         Skin.style.applyStyle(this.btnDisabled,Skin.style.currentTheme.disabledStateStandard);
      }
      
      protected function setButtonTextColors() : void
      {
         if(this.value_label != null)
         {
            switch(this.mCurrentState)
            {
               case this.STATE_UP:
                  Skin.style.applyStyle(this.value_label,Skin.style.currentTheme.primaryText);
                  break;
               case this.STATE_DOWN:
                  Skin.style.applyStyle(this.value_label,Skin.style.currentTheme.tertiaryText);
                  break;
               case this.STATE_ACTIVE:
                  Skin.style.applyStyle(this.value_label,Skin.style.currentTheme.primaryText);
                  break;
               case this.STATE_DISABLED:
                  Skin.style.applyStyle(this.value_label,Skin.style.currentTheme.disabledText);
            }
         }
      }
      
      protected function setButtonIconColor() : void
      {
         if(this.icon != null)
         {
            switch(this.mCurrentState)
            {
               case this.STATE_UP:
                  Skin.style.applyStyle(this.icon,Skin.style.currentTheme.standardIcon);
                  break;
               case this.STATE_DOWN:
                  Skin.style.applyStyle(this.icon,Skin.style.currentTheme.downIcon);
                  break;
               case this.STATE_ACTIVE:
                  Skin.style.applyStyle(this.icon,Skin.style.currentTheme.activeIcon);
                  break;
               case this.STATE_DISABLED:
                  Skin.style.applyStyle(this.icon,Skin.style.currentTheme.disabledIcon);
            }
         }
      }
      
      protected function showOrHideButtonImages() : void
      {
         this.setVisible(this.btnDown,this.mCurrentState == this.STATE_DOWN);
         this.setVisible(this.btnActive,this.mCurrentState == this.STATE_ACTIVE);
         this.setVisible(this.btnDisabled,this.mCurrentState == this.STATE_DISABLED);
      }
      
      protected function getStateFromFrameLabel() : String
      {
         var state:String = this.STATE_UP;
         if(currentLabel != null)
         {
            if(this.currentLabel.search(this.STATE_UP) == 0)
            {
               state = this.STATE_UP;
            }
            else if(this.currentLabel.search(this.STATE_DOWN) == 0)
            {
               state = this.STATE_DOWN;
            }
            else if(this.currentLabel.search(this.STATE_ACTIVE) == 0)
            {
               state = this.STATE_ACTIVE;
            }
            else if(this.currentLabel.search(this.STATE_DISABLED) == 0)
            {
               state = this.STATE_DISABLED;
            }
         }
         return state;
      }
      
      protected function setVisible(mc:MovieClip, isVisible:Boolean) : void
      {
         if(mc != null)
         {
            mc.visible = Boolean(isVisible);
         }
      }
   }
}

