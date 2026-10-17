package decorators
{
   import core.api.IDecorator;
   import decorations.Button;
   import flash.display.MovieClip;
   
   public dynamic class ButtonDecorator implements IDecorator
   {
      
      private static const SUFFIX:String = "button";
      
      private static const FUNCTION_DESCRIPTORS:Array = [{
         "name":"show",
         "type":"function",
         "uiElement":"unknown",
         "setter":"show"
      },{
         "name":"hide",
         "type":"function",
         "uiElement":"unknown",
         "setter":"hide"
      },{
         "name":"enabled",
         "type":"boolean",
         "uiElement":"checkBox",
         "getter":"getEnabled",
         "setter":"setEnabled"
      },{
         "name":"beepEnabled",
         "type":"boolean",
         "uiElement":"checkBox",
         "getter":"getBeepEnabled",
         "setter":"setBeepEnabled"
      },{
         "name":"interactive",
         "type":"boolean",
         "uiElement":"checkBox",
         "getter":"getInteractive",
         "setter":"setInteractive"
      },{
         "name":"selected",
         "type":"boolean",
         "uiElement":"checkBox",
         "getter":"getSelected",
         "setter":"setSelected"
      },{
         "name":"rollOver",
         "type":"boolean",
         "uiElement":"checkBox",
         "getter":"getRollOver",
         "setter":"setRollOver"
      },{
         "name":"toggleMode",
         "type":"boolean",
         "uiElement":"checkBox",
         "getter":"getToggleMode",
         "setter":"setToggleMode"
      },{
         "name":"toggle",
         "type":"function",
         "setter":"toggle"
      },{
         "name":"longPressDelay(ms)",
         "type":"uint",
         "uiElement":"textInput",
         "getter":"getLongPressDelay",
         "setter":"setLongPressDelay"
      },{
         "name":"autoRepeatDelay(ms)",
         "type":"uint",
         "uiElement":"textInput",
         "getter":"getAutoRepeatDelay",
         "setter":"setAutoRepeatDelay"
      },{
         "name":"autoRepeatPeriod(ms)",
         "type":"uint",
         "uiElement":"textInput",
         "getter":"getAutoRepeatPeriod",
         "setter":"setAutoRepeatPeriod"
      },{
         "name":"frameSuffix",
         "type":"string",
         "uiElement":"textInput",
         "getter":"getFrameSuffix",
         "setter":"setFrameSuffix"
      },{
         "name":"update",
         "type":"call",
         "uiElement":"button",
         "setter":"update"
      }];
      
      public function ButtonDecorator()
      {
         super();
      }
      
      public function get suffix() : String
      {
         return SUFFIX;
      }
      
      public function get functionDescriptors() : Array
      {
         return FUNCTION_DESCRIPTORS;
      }
      
      public function decorate(movieClip:MovieClip) : *
      {
         var descriptor:Object = null;
         var decoration:Button = new Button(movieClip);
         movieClip.mouseChildren = false;
         for each(descriptor in this.functionDescriptors)
         {
            if(descriptor.getter)
            {
               movieClip[descriptor.getter] = decoration[descriptor.getter];
            }
            if(descriptor.setter)
            {
               movieClip[descriptor.setter] = decoration[descriptor.setter];
            }
         }
         movieClip["getHighlight"] = decoration["getSelected"];
         movieClip["setHighlight"] = decoration["setSelected"];
         movieClip.parseChildren = false;
         return decoration;
      }
   }
}

