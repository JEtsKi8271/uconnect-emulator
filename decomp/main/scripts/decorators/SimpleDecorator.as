package decorators
{
   import core.api.IDecorator;
   import decorations.Simple;
   import flash.display.MovieClip;
   
   public dynamic class SimpleDecorator implements IDecorator
   {
      
      private static const SUFFIX:String = "simple";
      
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
      }];
      
      public function SimpleDecorator()
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
         var decoration:Simple = new Simple(movieClip);
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
         movieClip.parseChildren = false;
         return decoration;
      }
   }
}

