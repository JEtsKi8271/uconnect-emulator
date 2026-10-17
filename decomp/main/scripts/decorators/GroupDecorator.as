package decorators
{
   import core.api.IDecorator;
   import decorations.Group;
   import flash.display.MovieClip;
   
   public dynamic class GroupDecorator implements IDecorator
   {
      
      private static const SUFFIX:String = "group";
      
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
         "name":"interactive",
         "type":"boolean",
         "uiElement":"checkBox",
         "getter":"getInteractive",
         "setter":"setInteractive"
      },{
         "name":"exclusiveChildren",
         "type":"boolean",
         "uiElement":"checkBox",
         "getter":"getExclusiveChildren",
         "setter":"setExclusiveChildren"
      },{
         "name":"hideChildren",
         "type":"function",
         "setter":"hideChildren"
      },{
         "name":"radioButtons",
         "type":"boolean",
         "uiElement":"checkBox",
         "getter":"getRadioButtons",
         "setter":"setRadioButtons"
      },{
         "name":"requireSelection",
         "type":"boolean",
         "uiElement":"checkBox",
         "getter":"getRequireSelection",
         "setter":"setRequireSelection"
      },{
         "name":"selection",
         "type":"string",
         "uiElement":"textinput",
         "getter":"getSelection",
         "setter":"setSelection"
      },{
         "name":"previousSelection",
         "type":"funciton",
         "setter":"previousSelection"
      },{
         "name":"nextSelection",
         "type":"funciton",
         "setter":"nextSelection"
      },{
         "name":"eventsRequireChange",
         "type":"boolean",
         "uiElement":"checkBox",
         "getter":"getEventsRequireChange",
         "setter":"setEventsRequireChange"
      }];
      
      public function GroupDecorator()
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
         var decoration:Group = new Group(movieClip);
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
         movieClip.parseChildren = true;
         return decoration;
      }
   }
}

