package decorators
{
   import core.api.IDecorator;
   import decorations.Chain;
   import flash.display.MovieClip;
   
   public dynamic class ChainDecorator implements IDecorator
   {
      
      private static const SUFFIX:String = "chain";
      
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
         "name":"itemCount",
         "type":"uint",
         "uiElement":"label",
         "getter":"getItemCount"
      },{
         "name":"linkCount",
         "type":"uint",
         "uiElement":"label",
         "getter":"getLinkCount"
      },{
         "name":"links",
         "type":"array",
         "uiElement":"unknown",
         "setter":"setLinks"
      },{
         "name":"itemUpdater",
         "type":"function",
         "uiElement":"unknown",
         "setter":"setItemUpdater"
      },{
         "name":"update",
         "type":"call",
         "uiElement":"button",
         "setter":"update"
      }];
      
      public function ChainDecorator()
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
         var decoration:Chain = new Chain(movieClip);
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

