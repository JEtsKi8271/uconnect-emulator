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
   
   public dynamic class ButtonListSettings extends ButtonMovieClip implements IMovieClip
   {
      
      public var identifier:int;
      
      public var sel:int;
      
      public var label:TextField;
      
      public var value:TextField;
      
      public var check0:TextField;
      
      public var check1:TextField;
      
      public var check2:TextField;
      
      public var arrow:MovieClip;
      
      public var gloss:MovieClip;
      
      public var down:MovieClip;
      
      public var active:MovieClip;
      
      public var incrementer:MovieClip;
      
      public var checkbox0:ButtonCheckboxSettings;
      
      public var checkbox1:ButtonCheckboxSettings;
      
      public var checkbox2:ButtonCheckboxSettings;
      
      public var sound:String = "events.SoundEvent.click";
      
      private var mPetrified:Boolean = false;
      
      public function ButtonListSettings()
      {
         super();
      }
      
      override protected function interactiveChildren() : void
      {
         this.label.mouseEnabled = false;
         this.value.mouseEnabled = false;
         this.check0.mouseEnabled = false;
         this.check1.mouseEnabled = false;
         this.check2.mouseEnabled = false;
         this.arrow.mouseEnabled = false;
         this.gloss.mouseEnabled = false;
         this.down.mouseEnabled = false;
         this.active.mouseEnabled = false;
         this.incrementer.label.mouseEnabled = false;
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
         Skin.style.applyFont(this.value,Skin.style.currentTheme.FONT_PRIMARY);
         Skin.style.applyFont(this.check0,Skin.style.currentTheme.FONT_PRIMARY);
         Skin.style.applyFont(this.check1,Skin.style.currentTheme.FONT_PRIMARY);
         Skin.style.applyFont(this.check2,Skin.style.currentTheme.FONT_PRIMARY);
         Skin.style.applyFont(this.incrementer.label,Skin.style.currentTheme.FONT_PRIMARY);
      }
      
      override protected function onMouseDown(e:MouseEvent) : void
      {
         if(mEnabled)
         {
            this.parent.dispatchEvent(new WidgetEvent(WidgetEvent.PRESS,this));
            this.setState(STATE_DOWN);
         }
      }
      
      override protected function onMouseClick(e:MouseEvent) : void
      {
         switch(e.target.name)
         {
            case "checkbox0":
            case "checkbox1":
            case "checkbox2":
            case "negative":
            case "positive":
               break;
            default:
               if(mEnabled)
               {
                  this.setState(mActive ? int(STATE_ACTIVE) : int(STATE_UP));
               }
               this.click();
         }
      }
      
      override protected function click() : void
      {
         Framework.messenger.dispatchEvent(new SoundEvent(mCurrentState != STATE_DISABLED ? this.sound : SoundEvent.REJECT));
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
      
      public function set id(id:int) : void
      {
         this.identifier = id;
         this.checkbox0.id = id;
         this.checkbox1.id = id;
         this.checkbox2.id = id;
         this.incrementer.positive.id = id;
         this.incrementer.negative.id = id;
      }
      
      public function get id() : int
      {
         return this.identifier;
      }
      
      public function set petrify(petrified:Boolean) : void
      {
         this.mPetrified = petrified;
         if(this.mPetrified)
         {
            this.setState(STATE_DOWN);
         }
         else
         {
            this.setState(mActive ? int(STATE_ACTIVE) : int(STATE_UP));
         }
      }
      
      override public function setState(state:int) : void
      {
         switch(state)
         {
            case STATE_UP:
               if(!this.mPetrified)
               {
                  mCurrentState = state;
                  this.gloss.visible = false;
                  this.down.visible = false;
                  this.active.visible = false;
                  Skin.style.applyStyle(this.label,Skin.style.currentTheme.primaryText);
                  Skin.style.applyStyle(this.check0,Skin.style.currentTheme.primaryText);
                  Skin.style.applyStyle(this.check1,Skin.style.currentTheme.primaryText);
                  Skin.style.applyStyle(this.check2,Skin.style.currentTheme.primaryText);
                  Skin.style.applyStyle(this.value,Skin.style.currentTheme.primaryText);
                  Skin.style.applyStyle(this.incrementer.label,Skin.style.currentTheme.primaryText);
                  Skin.style.applyStyle(this.arrow,Skin.style.currentTheme.standardUpIcon);
               }
               break;
            case STATE_DOWN:
               mCurrentState = state;
               this.gloss.visible = true;
               this.down.visible = true;
               this.active.visible = false;
               Skin.style.applyStyle(this.label,Skin.style.currentTheme.primaryText);
               Skin.style.applyStyle(this.check0,Skin.style.currentTheme.primaryText);
               Skin.style.applyStyle(this.check1,Skin.style.currentTheme.primaryText);
               Skin.style.applyStyle(this.check2,Skin.style.currentTheme.primaryText);
               Skin.style.applyStyle(this.value,Skin.style.currentTheme.primaryText);
               Skin.style.applyStyle(this.incrementer.label,Skin.style.currentTheme.primaryText);
               Skin.style.applyStyle(this.colorize,Skin.style.currentTheme.downStateList);
               Skin.style.applyStyle(this.arrow,Skin.style.currentTheme.standardDownIcon);
               break;
            case STATE_ACTIVE:
               if(!this.mPetrified)
               {
                  mCurrentState = state;
                  this.gloss.visible = true;
                  this.down.visible = false;
                  this.active.visible = true;
                  Skin.style.applyStyle(this.label,Skin.style.currentTheme.primaryText);
                  Skin.style.applyStyle(this.check0,Skin.style.currentTheme.primaryText);
                  Skin.style.applyStyle(this.check1,Skin.style.currentTheme.primaryText);
                  Skin.style.applyStyle(this.check2,Skin.style.currentTheme.primaryText);
                  Skin.style.applyStyle(this.value,Skin.style.currentTheme.primaryText);
                  Skin.style.applyStyle(this.incrementer.label,Skin.style.currentTheme.primaryText);
                  Skin.style.applyStyle(this.colorize,Skin.style.currentTheme.activeStateList);
                  Skin.style.applyStyle(this.arrow,Skin.style.currentTheme.standardActiveIcon);
               }
               break;
            case STATE_DISABLED:
               mCurrentState = state;
               this.gloss.visible = false;
               this.down.visible = false;
               this.active.visible = false;
               Skin.style.applyStyle(this.label,Skin.style.currentTheme.disabledText);
               Skin.style.applyStyle(this.check0,Skin.style.currentTheme.disabledText);
               Skin.style.applyStyle(this.check1,Skin.style.currentTheme.disabledText);
               Skin.style.applyStyle(this.check2,Skin.style.currentTheme.disabledText);
               Skin.style.applyStyle(this.value,Skin.style.currentTheme.disabledText);
               Skin.style.applyStyle(this.incrementer.label,Skin.style.currentTheme.disabledText);
               Skin.style.applyStyle(this.arrow,Skin.style.currentTheme.standardDisabledIcon);
         }
      }
   }
}

