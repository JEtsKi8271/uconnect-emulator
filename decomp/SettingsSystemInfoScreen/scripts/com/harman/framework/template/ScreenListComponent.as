package com.harman.framework.template
{
   import ancillary.Ancillary;
   import ancillary.DynamicPopupNames;
   import ancillary.Screens;
   import com.harman.framework.controller.IList;
   import com.harman.moduleLinkAPI.AntiTheftEvent;
   import com.nfuzion.framework.global.Framework;
   import core.enums.FocusObject;
   import core.enums.FocusPriority;
   import core.enums.Layers;
   import core.locale.LocaleArchive;
   import core.utils.Text;
   import events.GlobalEvent;
   import events.HardControlEvent;
   import events.LocaleEvent;
   import events.SoundEvent;
   import events.WidgetEvent;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.text.TextField;
   import flash.text.TextFormat;
   import peripheral.Peripheral;
   
   public class ScreenListComponent extends ScreenList implements IList
   {
      
      public const LENGTH:int = 6;
      
      public const TYPE_EMPTY:String = "EMPTY";
      
      public const TYPE_SIMPLE:String = "SIMPLE";
      
      public const TYPE_SELECT:String = "SELECTION";
      
      public const TYPE_CHECK1:String = "1CHECKBOX";
      
      public const TYPE_CHECK2:String = "2CHECKBOX";
      
      public const TYPE_CHECK3:String = "3CHECKBOX";
      
      public const TYPE_INCREMENT:String = "INCREMENT";
      
      private const VARIANT_PRODUCT:String;
      
      public var contents:Vector.<Object> = new Vector.<Object>();
      
      public function ScreenListComponent()
      {
         this.VARIANT_PRODUCT = Peripheral.versionInfo.productVariantID.VARIANT_PRODUCT;
         cache = true;
         if(Peripheral.listScreen == null)
         {
            Peripheral.listScreen = new C_Settings();
         }
         mView = Peripheral.listScreen;
         super();
      }
      
      public function get assets() : MovieClip
      {
         return mView;
      }
      
      override protected function addListeners() : void
      {
         super.addListeners();
         Peripheral.listController.construct(this);
         Peripheral.listController.insideSettings = true;
         this.assets.back_button.addEventListener(WidgetEvent.CLICK,this.back,false,0,true);
         this.assets.close_button.addEventListener(WidgetEvent.CLICK,this.onClose,false,0,true);
         this.assets.window.addEventListener(GlobalEvent.ITEM,this.onItem,false,0,true);
         this.assets.window.addEventListener(GlobalEvent.ITEMDISABLED,this.onItemDisabled,false,0,true);
         Peripheral.hardControls.addEventListener(HardControlEvent.EXIT,this.onClose,false,0,true);
         Peripheral.antiTheft.addEventListener(AntiTheftEvent.ANTI_THEFT_IGNITION_STATE,this.onIgnitionState,false,0,true);
         Peripheral.antiTheft.addEventListener(AntiTheftEvent.ANTI_THEFT_POWER_MODE_STATE,this.onPowerModeState,false,0,true);
      }
      
      override protected function removeListeners() : void
      {
         Peripheral.listController.deconstruct();
         Peripheral.listController.insideSettings = false;
         this.assets.back_button.removeEventListener(WidgetEvent.CLICK,this.back);
         this.assets.close_button.removeEventListener(WidgetEvent.CLICK,this.onClose);
         this.assets.window.removeEventListener(GlobalEvent.ITEM,this.onItem);
         this.assets.window.removeEventListener(GlobalEvent.ITEMDISABLED,this.onItemDisabled);
         Peripheral.hardControls.removeEventListener(HardControlEvent.EXIT,this.onClose);
         Peripheral.antiTheft.removeEventListener(AntiTheftEvent.ANTI_THEFT_IGNITION_STATE,this.onIgnitionState);
         Peripheral.antiTheft.removeEventListener(AntiTheftEvent.ANTI_THEFT_POWER_MODE_STATE,this.onPowerModeState);
         super.removeListeners();
      }
      
      override protected function initScreen() : void
      {
         super.initScreen();
         this.assets.back_button.setEnabled(Peripheral.antiTheft.ignitionState != "accessory" || Framework.mapping.getAddress(Framework.structure.currentBranch) != Screens.SETTINGS_CLOCK);
         Framework.focusManager.addFocus(new FocusObject(Layers.MIDDLE,FocusPriority.MAXIMUM,null,Peripheral.listController.onFocusCallBack));
      }
      
      override protected function initView() : void
      {
         breadcrumbTextField = this.assets.title.label;
         super.initView();
      }
      
      override protected function changeLocale(e:LocaleEvent) : void
      {
         super.changeLocale(e);
         this.populate();
      }
      
      override protected function back(e:Event = null) : void
      {
         if(Peripheral.antiTheft.ignitionState == "accessory" || this.VARIANT_PRODUCT == "MP4" && Peripheral.antiTheft.powerModeState == "timed")
         {
            Framework.structure.exit();
         }
         else
         {
            Peripheral.listController.usePreviousIndex();
            Framework.structure.back();
         }
      }
      
      protected function onClose(e:Event) : void
      {
         Framework.structure.exit();
      }
      
      private function onIgnitionState(e:AntiTheftEvent) : void
      {
         this.assets.back_button.setEnabled(Peripheral.antiTheft.ignitionState != "accessory" || Framework.mapping.getAddress(Framework.structure.currentBranch) != Screens.SETTINGS_CLOCK);
         if(Peripheral.antiTheft.ignitionState == "accessory")
         {
            Ancillary.definedDynamicPopups.popup(DynamicPopupNames.PERSONALIZATION_LOCKOUT);
         }
         this.populate();
      }
      
      private function onPowerModeState(e:AntiTheftEvent) : void
      {
         if(this.VARIANT_PRODUCT != "MP4")
         {
            return;
         }
         if(Peripheral.antiTheft.powerModeState == "timed")
         {
            Ancillary.definedDynamicPopups.popup(DynamicPopupNames.PERSONALIZATION_LOCKOUT);
         }
         this.populate();
      }
      
      protected function onItem(e:GlobalEvent) : void
      {
      }
      
      protected function onItemDisabled(e:GlobalEvent) : void
      {
         if(Peripheral.antiTheft.ignitionState == "accessory" || this.VARIANT_PRODUCT == "MP4" && Peripheral.antiTheft.powerModeState == "timed")
         {
            Ancillary.definedDynamicPopups.popup(DynamicPopupNames.PERSONALIZATION_LOCKOUT);
         }
      }
      
      protected function populate() : void
      {
      }
      
      public function get length() : int
      {
         return this.contents.length;
      }
      
      public function set index(index:int) : void
      {
      }
      
      public function set selected(index:int) : void
      {
         this.assets.window.selected = index;
      }
      
      public function set total(total:String) : void
      {
      }
      
      public function refresh(e:Event = null) : void
      {
         Peripheral.listController.invalidate();
      }
      
      public function label(_textField:TextField, _text:String) : void
      {
         Text.format(_textField,_text,false);
         var format:TextFormat = _textField.getTextFormat();
         if(_textField.numLines == 1)
         {
            if(_textField.parent.name == "incrementer")
            {
               format.size = mView.OneLineIncrementerFontSize;
               _textField.setTextFormat(format);
               _textField.y = mView.OneLineIncrementerYCoord;
               _textField.height = mView.OneLineIncrementerHeight;
            }
            else if(_textField.name == "label")
            {
               format.size = mView.OneLineLabelFontSize;
               _textField.y = mView.OneLineLabelYCoord;
               _textField.height = mView.OneLineLabelHeight;
               _textField.setTextFormat(format);
               Text.resizeToFitByFontSize(_textField);
            }
            else
            {
               switch(_textField.name)
               {
                  case "check0":
                  case "check1":
                  case "check2":
                     format.size = mView.OneLineCheckFontSize;
                     _textField.y = mView.OneLineCheckYCoord;
                     _textField.height = mView.OneLineCheckHeight;
                     _textField.setTextFormat(format);
               }
            }
         }
         else
         {
            if(_textField.parent.name == "incrementer")
            {
               format.size = mView.TwoLineIncrementerFontSize;
               _textField.setTextFormat(format);
               _textField.y = mView.TwoLineIncrementerYCoord;
               _textField.height = mView.TwoLineIncrementerHeight;
            }
            else if(_textField.name == "label")
            {
               format.size = mView.OneLineLabelFontSize;
               _textField.y = mView.OneLineLabelYCoord;
               _textField.height = mView.OneLineLabelHeight;
               _textField.setTextFormat(format);
               Text.resizeToFitByFontSize(_textField);
            }
            else
            {
               switch(_textField.name)
               {
                  case "check0":
                  case "check1":
                  case "check2":
                     format.size = mView.TwoLineCheckFontSize;
                     _textField.y = mView.TwoLineCheckYCoord;
                     _textField.height = mView.TwoLineCheckHeight;
                     _textField.setTextFormat(format);
               }
            }
            if(_textField.numLines == 1)
            {
               switch(_textField.name)
               {
                  case "check0":
                  case "check1":
                  case "check2":
                     format.size = mView.TwoLineCheckFontSize;
                     _textField.y = mView.OneLineCheckYCoord;
                     _textField.height = mView.OneLineCheckHeight;
                     _textField.setTextFormat(format);
               }
            }
         }
      }
      
      public function configure(_item:MovieClip, _type:String, _icon:String = "") : void
      {
         _item.icon.visible = _icon != "";
         _item.icon.gotoAndStop(_icon);
         _item.label.x = _item.icon.visible ? mView.LabelXCoordIcon : mView.LabelXCoord;
         var isArabic:Boolean = Boolean(LocaleArchive.getInstance().isMirrored());
         var enabledState:Boolean = !(Peripheral.antiTheft.ignitionState == "accessory" || this.VARIANT_PRODUCT == "MP4" && Peripheral.antiTheft.powerModeState == "timed");
         enabledState = enabledState ? enabledState : Framework.mapping.getAddress(Framework.structure.currentBranch) == Screens.SETTINGS_CLOCK || Framework.mapping.getAddress(Framework.structure.currentBranch) == Screens.SETTINGS_AUDIO || Framework.mapping.getAddress(Framework.structure.currentBranch) == Screens.SETTINGS_BLUETOOTH || Framework.mapping.getAddress(Framework.structure.currentBranch) == Screens.SETTINGS_PHONE_BLUETOOTH;
         switch(_type)
         {
            case this.TYPE_EMPTY:
               _item.id = -1;
               _item.rotary = false;
               _item.sound = SoundEvent.CLICK;
               _item.setEnabled(false);
               _item.label.visible = false;
               _item.arrow.visible = false;
               _item.value.visible = false;
               _item.check0.visible = false;
               _item.check1.visible = false;
               _item.check2.visible = false;
               _item.checkbox0.visible = false;
               _item.checkbox1.visible = false;
               _item.checkbox2.visible = false;
               _item.incrementer.visible = false;
               break;
            case this.TYPE_SIMPLE:
               _item.rotary = false;
               _item.sound = SoundEvent.CLICK;
               _item.setEnabled(enabledState);
               _item.label.visible = true;
               if(isArabic)
               {
                  _item.label.x = mView.LabelArabicXFull;
                  _item.label.width = _item.icon.visible ? mView.LabelWidthFullIcon : mView.LabelWidthFullArabic;
               }
               else
               {
                  _item.label.width = _item.icon.visible ? mView.LabelWidthFullIcon : mView.LabelWidthFull;
               }
               _item.arrow.visible = false;
               _item.value.visible = false;
               _item.check0.visible = false;
               _item.check1.visible = false;
               _item.check2.visible = false;
               _item.checkbox0.visible = false;
               _item.checkbox1.visible = false;
               _item.checkbox2.visible = false;
               _item.incrementer.visible = false;
               break;
            case this.TYPE_SELECT:
               _item.rotary = false;
               _item.sound = SoundEvent.CLICK;
               _item.setEnabled(enabledState);
               if(isArabic)
               {
                  _item.label.x = mView.LabelArabicXSelection;
                  _item.label.width = _item.icon.visible ? mView.LabelWidthSelectionIcon : mView.LabelWidthSelectionArabic;
               }
               else
               {
                  _item.label.width = _item.icon.visible ? mView.LabelWidthSelectionIcon : mView.LabelWidthSelection;
               }
               _item.label.visible = true;
               _item.arrow.visible = true;
               _item.value.visible = true;
               _item.check0.visible = false;
               _item.check1.visible = false;
               _item.check2.visible = false;
               _item.checkbox0.visible = false;
               _item.checkbox1.visible = false;
               _item.checkbox2.visible = false;
               _item.incrementer.visible = false;
               break;
            case this.TYPE_CHECK1:
               _item.rotary = false;
               _item.sound = SoundEvent.SET;
               _item.checkbox0.setEnabled(enabledState);
               _item.setEnabled(enabledState);
               if(isArabic)
               {
                  _item.label.x = mView.LabelArabicXCheck1;
                  _item.label.width = _item.icon.visible ? mView.LabelWidthCheck1Icon : mView.LabelWidthCheck1Arabic;
               }
               else
               {
                  _item.label.width = _item.icon.visible ? mView.LabelWidthCheck1Icon : mView.LabelWidthCheck1;
               }
               _item.label.visible = true;
               _item.arrow.visible = false;
               _item.value.visible = false;
               _item.check0.visible = false;
               _item.check1.visible = false;
               _item.check2.visible = false;
               _item.checkbox0.visible = true;
               _item.checkbox1.visible = false;
               _item.checkbox2.visible = false;
               _item.incrementer.visible = false;
               break;
            case this.TYPE_CHECK2:
               _item.rotary = false;
               _item.sound = SoundEvent.SET;
               _item.checkbox0.setEnabled(enabledState);
               _item.checkbox1.setEnabled(enabledState);
               _item.setEnabled(enabledState);
               if(isArabic)
               {
                  _item.label.x = mView.LabelArabicXCheck2;
                  _item.label.width = _item.icon.visible ? mView.LabelWidthCheck2Icon : mView.LabelWidthCheck2Arabic;
               }
               else
               {
                  _item.label.width = _item.icon.visible ? mView.LabelWidthCheck2Icon : mView.LabelWidthCheck2;
               }
               _item.label.visible = true;
               _item.arrow.visible = false;
               _item.value.visible = false;
               _item.check0.visible = true;
               _item.check1.visible = true;
               _item.check2.visible = false;
               _item.checkbox0.visible = true;
               _item.checkbox1.visible = true;
               _item.checkbox2.visible = false;
               _item.incrementer.visible = false;
               break;
            case this.TYPE_CHECK3:
               _item.rotary = false;
               _item.sound = SoundEvent.SET;
               _item.checkbox0.setEnabled(enabledState);
               _item.checkbox1.setEnabled(enabledState);
               _item.checkbox2.setEnabled(enabledState);
               _item.setEnabled(enabledState);
               if(isArabic)
               {
                  _item.label.x = mView.LabelArabicXCheck3;
                  _item.label.width = _item.icon.visible ? mView.LabelWidthCheck3Icon : mView.LabelWidthCheck3Arabic;
               }
               else
               {
                  _item.label.width = _item.icon.visible ? mView.LabelWidthCheck3Icon : mView.LabelWidthCheck3;
               }
               _item.label.visible = true;
               _item.arrow.visible = false;
               _item.value.visible = false;
               _item.check0.visible = true;
               _item.check1.visible = true;
               _item.check2.visible = true;
               _item.checkbox0.visible = true;
               _item.checkbox1.visible = true;
               _item.checkbox2.visible = true;
               _item.incrementer.visible = false;
               break;
            case this.TYPE_INCREMENT:
               _item.rotary = true;
               _item.sound = SoundEvent.CLICK;
               _item.incrementer.negative.setEnabled(enabledState);
               _item.incrementer.positive.setEnabled(enabledState);
               _item.setEnabled(enabledState);
               if(isArabic)
               {
                  _item.label.x = mView.LabelArabicXIncrement;
                  _item.label.width = _item.icon.visible ? mView.LabelWidthIncrementIcon : mView.LabelWidthIncrementArabic;
               }
               else
               {
                  _item.label.width = _item.icon.visible ? mView.LabelWidthIncrementIcon : mView.LabelWidthIncrement;
               }
               _item.label.visible = true;
               _item.arrow.visible = false;
               _item.value.visible = false;
               _item.check0.visible = false;
               _item.check1.visible = false;
               _item.check2.visible = false;
               _item.checkbox0.visible = false;
               _item.checkbox1.visible = false;
               _item.checkbox2.visible = false;
               _item.incrementer.visible = true;
         }
      }
   }
}

