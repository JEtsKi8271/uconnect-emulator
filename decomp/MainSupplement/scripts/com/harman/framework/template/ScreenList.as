package com.harman.framework.template
{
   import ancillary.Breadcrumb;
   import com.nfuzion.framework.global.Framework;
   import core.locale.LocaleArchive;
   import core.utils.Text;
   import events.LocaleEvent;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import peripheral.Peripheral;
   import skin.Skin;
   import skin.StyleEvent;
   
   public class ScreenList extends ScreenEnhanced
   {
      
      public var mBreadcrumbs:Array;
      
      private var mBreadcrumbTextField:TextField = null;
      
      public function ScreenList()
      {
         super();
      }
      
      override protected function addListeners() : void
      {
         super.addListeners();
         if(this.mBreadcrumbTextField)
         {
            this.mBreadcrumbTextField.addEventListener(MouseEvent.CLICK,this.onBreadcrumbClick,false,0,true);
         }
         Skin.style.addEventListener(StyleEvent.THEME_CHANGE,this.onThemeChange,false,0,true);
      }
      
      override protected function removeListeners() : void
      {
         if(this.mBreadcrumbTextField)
         {
            this.mBreadcrumbTextField.removeEventListener(MouseEvent.CLICK,this.onBreadcrumbClick);
         }
         Skin.style.removeEventListener(StyleEvent.THEME_CHANGE,this.onThemeChange);
         super.removeListeners();
      }
      
      protected function onThemeChange(e:StyleEvent) : void
      {
         this.updateBreadcrumbs();
      }
      
      override protected function changeLocale(e:LocaleEvent) : void
      {
         this.updateBreadcrumbs();
         super.changeLocale(e);
      }
      
      protected function pushBreadcrumb(breadcrumb:Breadcrumb) : void
      {
         this.mBreadcrumbs.push(breadcrumb);
         this.updateBreadcrumbs();
      }
      
      protected function popBreadcrumb() : void
      {
         this.mBreadcrumbs.pop();
         this.updateBreadcrumbs();
      }
      
      protected function clearBreadcrumbs() : void
      {
         this.mBreadcrumbs = new Array();
      }
      
      protected function updateBreadcrumbs() : void
      {
         if(this.mBreadcrumbTextField)
         {
            Text.formatBreadcrumb(this.mBreadcrumbTextField,Text.getBreadcrumb(this.mBreadcrumbs),Skin.style.currentTheme.titleText.color.hexValue);
         }
      }
      
      protected function onBreadcrumbClick(e:MouseEvent) : void
      {
         var text:String = this.mBreadcrumbTextField.text;
         var index:int = this.mBreadcrumbTextField.getCharIndexAtPoint(e.localX,e.localY);
         var offset:int = text.length - 1;
         var delta:* = int(this.mBreadcrumbs.length - 1);
         var separator:String = ">";
         if(LocaleArchive.getInstance().isMirrored())
         {
            index = text.length - index;
            separator = "<";
            text = text.split("").reverse().join("");
         }
         while(offset > index && offset > 0)
         {
            offset = text.lastIndexOf(separator,offset - 1);
            if(offset > index)
            {
               delta--;
            }
         }
         this.igniteBreadcrumb(this.mBreadcrumbs[delta],delta);
      }
      
      public function igniteBreadcrumb(breadcrumb:Breadcrumb, delta:int) : void
      {
         var callback:Function = null;
         var branch:String = null;
         var historyIndex:int = 0;
         switch(breadcrumb.type)
         {
            case Breadcrumb.DELTA_FUNCTION:
               callback = breadcrumb.args.shift() as Function;
               if(breadcrumb.args.length == 0)
               {
                  callback(delta);
               }
               else
               {
                  callback(delta,breadcrumb.args);
               }
               breadcrumb.args.unshift(callback);
               break;
            case Breadcrumb.FUNCTION:
               callback = breadcrumb.args.shift() as Function;
               if(breadcrumb.args.length == 0)
               {
                  callback();
               }
               else
               {
                  callback(breadcrumb.args);
               }
               breadcrumb.args.unshift(callback);
               this.mBreadcrumbs.splice(delta + 1);
               this.updateBreadcrumbs();
               break;
            case Breadcrumb.INERT:
               Peripheral.audioMixerManager.sendConfirmationTone(Peripheral.audioMixerManager.TONE_REJECTION);
               break;
            case Breadcrumb.PAGE:
               branch = breadcrumb.args[0] as String;
               historyIndex = int(Framework.structure.historyIndexOf(branch));
               if(historyIndex > 0 && historyIndex == this.mBreadcrumbs.length - 1 - delta)
               {
                  Peripheral.audioMixerManager.sendConfirmationTone(Peripheral.audioMixerManager.TONE_NORMAL);
                  Framework.structure.returnTo(branch);
               }
               else
               {
                  Peripheral.audioMixerManager.sendConfirmationTone(Peripheral.audioMixerManager.TONE_REJECTION);
               }
         }
      }
      
      protected function get breadcrumbCount() : int
      {
         return this.mBreadcrumbs.length;
      }
      
      protected function set breadcrumbTextField(textField:TextField) : void
      {
         this.mBreadcrumbTextField = textField;
         this.updateBreadcrumbs();
      }
   }
}

