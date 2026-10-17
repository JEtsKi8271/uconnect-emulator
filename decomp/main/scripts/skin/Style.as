package skin
{
   import com.nfuzion.framework.global.Framework;
   import core.theme.ThemeObject;
   import fl.motion.AdjustColor;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.filters.BitmapFilterQuality;
   import flash.filters.ColorMatrixFilter;
   import flash.filters.GlowFilter;
   import flash.geom.ColorTransform;
   import flash.text.AntiAliasType;
   import flash.text.TextField;
   import flash.text.TextFormat;
   
   public class Style extends MovieClip implements ISkinStyle
   {
      
      private var mCurrentThemeObject:ThemeObject = new ThemeObject();
      
      public function Style()
      {
         super();
      }
      
      public function get currentTheme() : ThemeObject
      {
         return this.mCurrentThemeObject;
      }
      
      public function applyStyle(displayObject:DisplayObject, styleObject:Object) : void
      {
         var styleMethod:String = null;
         if(displayObject != null)
         {
            styleMethod = styleObject.method;
            switch(styleMethod)
            {
               case "colorMatrix":
                  this.applyColorMatrix(MovieClip(displayObject),styleObject);
                  break;
               case "colorTransform":
                  this.applyColorTransform(MovieClip(displayObject),styleObject);
                  break;
               case "format":
                  this.applyTextTransform(TextField(displayObject),styleObject);
                  break;
               case "glowFilter":
                  this.applyGlowFilter(DisplayObject(displayObject),styleObject);
            }
         }
      }
      
      public function applyFont(textField:TextField, fontIdentifier:String) : void
      {
         var textFormat:TextFormat = null;
         var textValue:String = null;
         if(textField != null)
         {
            textFormat = textField.getTextFormat();
            textValue = textField.text;
            textFormat.font = fontIdentifier;
            textField.embedFonts = true;
            textField.defaultTextFormat = textFormat;
            textField.antiAliasType = AntiAliasType.ADVANCED;
            textField.text = textValue;
         }
      }
      
      private function applyColorMatrix(mc:MovieClip, styleObject:Object) : void
      {
         var adjustColor:AdjustColor = new AdjustColor();
         adjustColor.brightness = styleObject.color.brightness;
         adjustColor.contrast = styleObject.color.contrast;
         adjustColor.hue = styleObject.color.hue;
         adjustColor.saturation = styleObject.color.saturation;
         var filter:ColorMatrixFilter = new ColorMatrixFilter(adjustColor.CalculateFinalFlatArray());
         mc.filters = [filter];
         mc.alpha = styleObject.alpha;
      }
      
      private function applyColorTransform(mc:MovieClip, styleObject:Object) : void
      {
         var colorTransform:ColorTransform = null;
         if(styleObject.color.hexValue != -1)
         {
            colorTransform = new ColorTransform();
            colorTransform.color = styleObject.color.hexValue;
            mc.transform.colorTransform = colorTransform;
            mc.alpha = styleObject.alpha;
         }
         else
         {
            mc.transform.colorTransform = new ColorTransform();
            mc.alpha = styleObject.alpha;
         }
      }
      
      private function applyTextTransform(tf:TextField, styleObject:Object) : void
      {
         tf.textColor = styleObject.color.hexValue;
         tf.alpha = styleObject.alpha;
      }
      
      private function applyGlowFilter(obj:DisplayObject, styleObject:Object) : void
      {
         var _color:Number = Number(styleObject.color.hexValue);
         var _alpha:Number = 1;
         var _blurX:Number = 12;
         var _blurY:Number = 12;
         var _strength:Number = 3;
         var _quality:Number = BitmapFilterQuality.HIGH;
         var _glowFilter:GlowFilter = new GlowFilter(_color,_alpha,_blurX,_blurY,_strength,_quality);
         obj.filters = [_glowFilter];
      }
      
      public function getValuesFromThemeSWF(_themeSWF:MovieClip) : void
      {
         this.deleteThemeObjects();
         Framework.Trace("<Style> Reading Theme Values...");
         var mLoadedThemeSWF:MovieClip = _themeSWF;
         this.mCurrentThemeObject.colorValues = mLoadedThemeSWF.colorValues;
         this.mCurrentThemeObject.wallpaperBitmapData = mLoadedThemeSWF.wallpaperBitmapData;
         this.mCurrentThemeObject.barGraphic = mLoadedThemeSWF.barGraphic;
         this.mCurrentThemeObject.standardGraphic = mLoadedThemeSWF.standardGraphic;
         this.mCurrentThemeObject.standardIcon = mLoadedThemeSWF.standardIcon;
         this.mCurrentThemeObject.activeGraphic = mLoadedThemeSWF.activeGraphic;
         this.mCurrentThemeObject.activeIcon = mLoadedThemeSWF.activeIcon;
         this.mCurrentThemeObject.activeMenu = mLoadedThemeSWF.activeMenu;
         this.mCurrentThemeObject.primaryText = mLoadedThemeSWF.primaryText;
         this.mCurrentThemeObject.secondaryText = mLoadedThemeSWF.secondaryText;
         this.mCurrentThemeObject.tertiaryText = mLoadedThemeSWF.tertiaryText;
         this.mCurrentThemeObject.titleText = mLoadedThemeSWF.titleText;
         this.mCurrentThemeObject.LCDText = mLoadedThemeSWF.LCDText;
         this.mCurrentThemeObject.glowActive = {
            "method":"glowFilter",
            "alpha":1,
            "color":mLoadedThemeSWF.colorValues["MainThemeColor"]
         };
         this.mCurrentThemeObject.cursorGlow = {
            "method":"glowFilter",
            "alpha":1,
            "color":mLoadedThemeSWF.colorValues["AlertRed"]
         };
         this.mCurrentThemeObject.cursorActive = {
            "method":"colorTransform",
            "alpha":1,
            "color":mLoadedThemeSWF.colorValues["AlertRed"]
         };
         this.mCurrentThemeObject.HEVHybridGraphic = {
            "method":"colorTransform",
            "alpha":1,
            "color":mLoadedThemeSWF.colorValues["MainThemeColor"]
         };
         this.mCurrentThemeObject.HEVElectricGraphic = {
            "method":"colorTransform",
            "alpha":1,
            "color":{
               "hexValue":653202,
               "hue":0,
               "saturation":100,
               "brightness":100,
               "contrast":0
            }
         };
         this.mCurrentThemeObject.HEVHybridText = {
            "method":"format",
            "alpha":1,
            "color":mLoadedThemeSWF.colorValues["MainThemeColor"]
         };
         this.mCurrentThemeObject.HEVElectricText = {
            "method":"format",
            "alpha":1,
            "color":{
               "hexValue":653202,
               "hue":0,
               "saturation":100,
               "brightness":100,
               "contrast":0
            }
         };
         this.mCurrentThemeObject.disabledGraphic = mLoadedThemeSWF.disabledGraphic;
         this.mCurrentThemeObject.disabledIcon = mLoadedThemeSWF.disabledIcon;
         this.mCurrentThemeObject.disabledText = mLoadedThemeSWF.disabledText;
         this.mCurrentThemeObject.downIcon = mLoadedThemeSWF.downIcon;
         this.mCurrentThemeObject.popupBorder = mLoadedThemeSWF.popupBorder;
         this.mCurrentThemeObject.upStateStandard = mLoadedThemeSWF.upStateStandard;
         this.mCurrentThemeObject.downStateStandard = mLoadedThemeSWF.downStateStandard;
         this.mCurrentThemeObject.activeStateStandard = mLoadedThemeSWF.activeStateStandard;
         this.mCurrentThemeObject.disabledStateStandard = mLoadedThemeSWF.disabledStateStandard;
         this.mCurrentThemeObject.standardUpIcon = mLoadedThemeSWF.standardUpIcon;
         this.mCurrentThemeObject.standardDownIcon = mLoadedThemeSWF.standardDownIcon;
         this.mCurrentThemeObject.standardActiveIcon = mLoadedThemeSWF.standardActiveIcon;
         this.mCurrentThemeObject.standardDisabledIcon = mLoadedThemeSWF.standardDisabledIcon;
         this.mCurrentThemeObject.desaturateUpIcon = mLoadedThemeSWF.desaturateUpIcon;
         this.mCurrentThemeObject.desaturateDownIcon = mLoadedThemeSWF.desaturateDownIcon;
         this.mCurrentThemeObject.desaturateActiveIcon = mLoadedThemeSWF.desaturateActiveIcon;
         this.mCurrentThemeObject.desaturateDisabledIcon = mLoadedThemeSWF.desaturateDisabledIcon;
         this.mCurrentThemeObject.phoneactiveUpIcon = mLoadedThemeSWF.phoneactiveUpIcon;
         this.mCurrentThemeObject.phoneactiveDownIcon = mLoadedThemeSWF.phoneactiveDownIcon;
         this.mCurrentThemeObject.phoneactiveActiveIcon = mLoadedThemeSWF.phoneactiveActiveIcon;
         this.mCurrentThemeObject.phoneactiveDisabledIcon = mLoadedThemeSWF.phoneactiveDisabledIcon;
         this.mCurrentThemeObject.deactiveUpIcon = mLoadedThemeSWF.deactiveUpIcon;
         this.mCurrentThemeObject.deactiveDownIcon = mLoadedThemeSWF.deactiveDownIcon;
         this.mCurrentThemeObject.deactiveActiveIcon = mLoadedThemeSWF.deactiveActiveIcon;
         this.mCurrentThemeObject.deactiveDisabledIcon = mLoadedThemeSWF.deactiveDisabledIcon;
         this.mCurrentThemeObject.keylockUpIcon = mLoadedThemeSWF.keylockUpIcon;
         this.mCurrentThemeObject.keylockDownIcon = mLoadedThemeSWF.keylockDownIcon;
         this.mCurrentThemeObject.keylockActiveIcon = mLoadedThemeSWF.keylockActiveIcon;
         this.mCurrentThemeObject.keylockDisabledIcon = mLoadedThemeSWF.keylockDisabledIcon;
         this.mCurrentThemeObject.scrollerUpIcon = mLoadedThemeSWF.scrollerUpIcon;
         this.mCurrentThemeObject.scrollerDownIcon = mLoadedThemeSWF.scrollerDownIcon;
         this.mCurrentThemeObject.scrollerActiveIcon = mLoadedThemeSWF.scrollerActiveIcon;
         this.mCurrentThemeObject.scrollerDisabledIcon = mLoadedThemeSWF.scrollerDisabledIcon;
         this.mCurrentThemeObject.listUpIcon = mLoadedThemeSWF.listUpIcon;
         this.mCurrentThemeObject.listDownIcon = mLoadedThemeSWF.listDownIcon;
         this.mCurrentThemeObject.listActiveIcon = mLoadedThemeSWF.listActiveIcon;
         this.mCurrentThemeObject.listDisabledIcon = mLoadedThemeSWF.listDisabledIcon;
         this.mCurrentThemeObject.upStateList = mLoadedThemeSWF.upStateList;
         this.mCurrentThemeObject.downStateList = mLoadedThemeSWF.downStateList;
         this.mCurrentThemeObject.activeStateList = mLoadedThemeSWF.activeStateList;
         this.mCurrentThemeObject.disabledStateList = mLoadedThemeSWF.disabledStateList;
         this.mCurrentThemeObject.commandUpIcon = mLoadedThemeSWF.commandUpIcon;
         this.mCurrentThemeObject.commandDownIcon = mLoadedThemeSWF.commandDownIcon;
         this.mCurrentThemeObject.commandActiveIcon = mLoadedThemeSWF.commandActiveIcon;
         this.mCurrentThemeObject.commandDisabledIcon = mLoadedThemeSWF.commandDisabledIcon;
         this.mCurrentThemeObject.upStateKeylock = mLoadedThemeSWF.upStateKeylock;
         this.mCurrentThemeObject.downStateKeylock = mLoadedThemeSWF.downStateKeylock;
         this.mCurrentThemeObject.activeStateKeylock = mLoadedThemeSWF.activeStateKeylock;
         this.mCurrentThemeObject.disabledStateKeylock = mLoadedThemeSWF.disabledStateKeylock;
         this.mCurrentThemeObject.browseUpIcon = mLoadedThemeSWF.browseUpIcon;
         this.mCurrentThemeObject.browseDownIcon = mLoadedThemeSWF.browseDownIcon;
         this.mCurrentThemeObject.browseActiveIcon = mLoadedThemeSWF.browseActiveIcon;
         this.mCurrentThemeObject.browseDisabledIcon = mLoadedThemeSWF.browseDisabledIcon;
         this.mCurrentThemeObject.upStateClose = mLoadedThemeSWF.upStateClose;
         this.mCurrentThemeObject.downStateClose = mLoadedThemeSWF.downStateClose;
         this.mCurrentThemeObject.activeStateClose = mLoadedThemeSWF.activeStateClose;
         this.mCurrentThemeObject.disabledStateClose = mLoadedThemeSWF.disabledStateClose;
         this.mCurrentThemeObject.closeUpIcon = mLoadedThemeSWF.closeUpIcon;
         this.mCurrentThemeObject.closeDownIcon = mLoadedThemeSWF.closeDownIcon;
         this.mCurrentThemeObject.closeActiveIcon = mLoadedThemeSWF.closeActiveIcon;
         this.mCurrentThemeObject.closeDisabledIcon = mLoadedThemeSWF.closeDisabledIcon;
         this.mCurrentThemeObject.alertNoneText = mLoadedThemeSWF.alertNoneText;
         this.mCurrentThemeObject.alertCautionText = mLoadedThemeSWF.alertCautionText;
         this.mCurrentThemeObject.alertWarningText = mLoadedThemeSWF.alertWarningText;
         this.mCurrentThemeObject.alertNoneIcon = mLoadedThemeSWF.alertNoneIcon;
         this.mCurrentThemeObject.alertCautionIcon = mLoadedThemeSWF.alertCautionIcon;
         this.mCurrentThemeObject.alertWarningIcon = mLoadedThemeSWF.alertWarningIcon;
         this.mCurrentThemeObject.heatIcon = mLoadedThemeSWF.heatIcon;
         this.mCurrentThemeObject.coldIcon = mLoadedThemeSWF.coldIcon;
         this.mCurrentThemeObject.heatText = mLoadedThemeSWF.heatText;
         this.mCurrentThemeObject.coldText = mLoadedThemeSWF.coldText;
         this.mCurrentThemeObject.heatActive = mLoadedThemeSWF.heatActive;
         this.mCurrentThemeObject.coldActive = mLoadedThemeSWF.coldActive;
         this.mCurrentThemeObject.vrOk = mLoadedThemeSWF.vrOk;
         this.mCurrentThemeObject.vrHelp = mLoadedThemeSWF.vrHelp;
         this.mCurrentThemeObject.vrFail = mLoadedThemeSWF.vrFail;
         this.mCurrentThemeObject.volumeBar = mLoadedThemeSWF.volumeBar;
         this.mCurrentThemeObject.volumeIcon = mLoadedThemeSWF.volumeIcon;
         this.mCurrentThemeObject.muteIcon = mLoadedThemeSWF.muteIcon;
         this.mCurrentThemeObject.upStateEco = mLoadedThemeSWF.upStateEco;
         this.mCurrentThemeObject.downStateEco = mLoadedThemeSWF.downStateEco;
         this.mCurrentThemeObject.activeStateEco = mLoadedThemeSWF.activeStateEco;
         this.mCurrentThemeObject.disabledStateEco = mLoadedThemeSWF.disabledStateEco;
         mLoadedThemeSWF = null;
         Framework.Trace("<Style> Saved Theme Values!");
      }
      
      public function deleteThemeObjects() : void
      {
         Framework.Trace("<Style> Delete Old Theme Values...");
         this.mCurrentThemeObject.colorValues = null;
         this.mCurrentThemeObject.wallpaperBitmapData = null;
         this.mCurrentThemeObject.barGraphic = null;
         this.mCurrentThemeObject.standardGraphic = null;
         this.mCurrentThemeObject.standardIcon = null;
         this.mCurrentThemeObject.activeGraphic = null;
         this.mCurrentThemeObject.activeIcon = null;
         this.mCurrentThemeObject.activeMenu = null;
         this.mCurrentThemeObject.primaryText = null;
         this.mCurrentThemeObject.secondaryText = null;
         this.mCurrentThemeObject.tertiaryText = null;
         this.mCurrentThemeObject.titleText = null;
         this.mCurrentThemeObject.LCDText = null;
         this.mCurrentThemeObject.glowActive = null;
         this.mCurrentThemeObject.cursorActive = null;
         this.mCurrentThemeObject.HEVHybridGraphic = null;
         this.mCurrentThemeObject.HEVElectricGraphic = null;
         this.mCurrentThemeObject.HEVHybridText = null;
         this.mCurrentThemeObject.HEVElectricText = null;
         this.mCurrentThemeObject.disabledGraphic = null;
         this.mCurrentThemeObject.disabledIcon = null;
         this.mCurrentThemeObject.disabledText = null;
         this.mCurrentThemeObject.downIcon = null;
         this.mCurrentThemeObject.popupBorder = null;
         this.mCurrentThemeObject.upStateStandard = null;
         this.mCurrentThemeObject.downStateStandard = null;
         this.mCurrentThemeObject.activeStateStandard = null;
         this.mCurrentThemeObject.disabledStateStandard = null;
         this.mCurrentThemeObject.standardUpIcon = null;
         this.mCurrentThemeObject.standardDownIcon = null;
         this.mCurrentThemeObject.standardActiveIcon = null;
         this.mCurrentThemeObject.standardDisabledIcon = null;
         this.mCurrentThemeObject.desaturateUpIcon = null;
         this.mCurrentThemeObject.desaturateDownIcon = null;
         this.mCurrentThemeObject.desaturateActiveIcon = null;
         this.mCurrentThemeObject.desaturateDisabledIcon = null;
         this.mCurrentThemeObject.phoneactiveUpIcon = null;
         this.mCurrentThemeObject.phoneactiveDownIcon = null;
         this.mCurrentThemeObject.phoneactiveActiveIcon = null;
         this.mCurrentThemeObject.phoneactiveDisabledIcon = null;
         this.mCurrentThemeObject.deactiveUpIcon = null;
         this.mCurrentThemeObject.deactiveDownIcon = null;
         this.mCurrentThemeObject.deactiveActiveIcon = null;
         this.mCurrentThemeObject.deactiveDisabledIcon = null;
         this.mCurrentThemeObject.keylockUpIcon = null;
         this.mCurrentThemeObject.keylockDownIcon = null;
         this.mCurrentThemeObject.keylockActiveIcon = null;
         this.mCurrentThemeObject.keylockDisabledIcon = null;
         this.mCurrentThemeObject.scrollerUpIcon = null;
         this.mCurrentThemeObject.scrollerDownIcon = null;
         this.mCurrentThemeObject.scrollerActiveIcon = null;
         this.mCurrentThemeObject.scrollerDisabledIcon = null;
         this.mCurrentThemeObject.listUpIcon = null;
         this.mCurrentThemeObject.listDownIcon = null;
         this.mCurrentThemeObject.listActiveIcon = null;
         this.mCurrentThemeObject.listDisabledIcon = null;
         this.mCurrentThemeObject.upStateList = null;
         this.mCurrentThemeObject.downStateList = null;
         this.mCurrentThemeObject.activeStateList = null;
         this.mCurrentThemeObject.disabledStateList = null;
         this.mCurrentThemeObject.commandUpIcon = null;
         this.mCurrentThemeObject.commandDownIcon = null;
         this.mCurrentThemeObject.commandActiveIcon = null;
         this.mCurrentThemeObject.commandDisabledIcon = null;
         this.mCurrentThemeObject.upStateKeylock = null;
         this.mCurrentThemeObject.downStateKeylock = null;
         this.mCurrentThemeObject.activeStateKeylock = null;
         this.mCurrentThemeObject.disabledStateKeylock = null;
         this.mCurrentThemeObject.browseUpIcon = null;
         this.mCurrentThemeObject.browseDownIcon = null;
         this.mCurrentThemeObject.browseActiveIcon = null;
         this.mCurrentThemeObject.browseDisabledIcon = null;
         this.mCurrentThemeObject.upStateClose = null;
         this.mCurrentThemeObject.downStateClose = null;
         this.mCurrentThemeObject.activeStateClose = null;
         this.mCurrentThemeObject.disabledStateClose = null;
         this.mCurrentThemeObject.closeUpIcon = null;
         this.mCurrentThemeObject.closeDownIcon = null;
         this.mCurrentThemeObject.closeActiveIcon = null;
         this.mCurrentThemeObject.closeDisabledIcon = null;
         this.mCurrentThemeObject.alertNoneText = null;
         this.mCurrentThemeObject.alertCautionText = null;
         this.mCurrentThemeObject.alertWarningText = null;
         this.mCurrentThemeObject.alertNoneIcon = null;
         this.mCurrentThemeObject.alertCautionIcon = null;
         this.mCurrentThemeObject.alertWarningIcon = null;
         this.mCurrentThemeObject.heatIcon = null;
         this.mCurrentThemeObject.coldIcon = null;
         this.mCurrentThemeObject.heatText = null;
         this.mCurrentThemeObject.coldText = null;
         this.mCurrentThemeObject.heatActive = null;
         this.mCurrentThemeObject.coldActive = null;
         this.mCurrentThemeObject.vrOk = null;
         this.mCurrentThemeObject.vrHelp = null;
         this.mCurrentThemeObject.vrFail = null;
         this.mCurrentThemeObject.volumeBar = null;
         this.mCurrentThemeObject.volumeIcon = null;
         this.mCurrentThemeObject.muteIcon = null;
         this.mCurrentThemeObject.upStateEco = null;
         this.mCurrentThemeObject.downStateEco = null;
         this.mCurrentThemeObject.activeStateEco = null;
         this.mCurrentThemeObject.disabledStateEco = null;
         Framework.Trace("<Style> Deleted Old Theme Values!");
      }
   }
}

