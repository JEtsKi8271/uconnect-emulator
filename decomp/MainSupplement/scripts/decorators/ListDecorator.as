package decorators
{
   import core.api.IDecorator;
   import decorations.List;
   import flash.display.MovieClip;
   
   public dynamic class ListDecorator implements IDecorator
   {
      
      private static const SUFFIX:String = "list";
      
      private static const FUNCTION_DESCRIPTORS:Array = [{
         "name":"reset",
         "type":"function",
         "uiElement":"unknown",
         "setter":"reset"
      },{
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
         "name":"selectedData",
         "type":"object",
         "getter":"getSelectedData"
      },{
         "name":"interactive",
         "type":"boolean",
         "uiElement":"checkBox",
         "getter":"getInteractive",
         "setter":"setInteractive"
      },{
         "name":"rowCount",
         "type":"uint",
         "uiElement":"label",
         "getter":"getRowCount"
      },{
         "name":"data",
         "type":"object",
         "getter":"getData",
         "setter":"setData"
      },{
         "name":"length",
         "type":"uint",
         "uiElement":"textInput",
         "getter":"getLength",
         "setter":"setLength"
      },{
         "name":"cursor",
         "type":"int",
         "uiElement":"textInput",
         "getter":"getCursor",
         "setter":"setCursor"
      },{
         "name":"position",
         "type":"uint",
         "uiElement":"textInput",
         "getter":"getPosition",
         "setter":"setPosition"
      },{
         "name":"rowUpdater",
         "type":"function",
         "setter":"setRowUpdater"
      },{
         "name":"dataRequester",
         "type":"function",
         "getter":"getDataRequester",
         "setter":"setDataRequester"
      },{
         "name":"selectionChanger",
         "type":"function",
         "setter":"setSelectionChanger"
      },{
         "name":"update",
         "type":"call",
         "uiElement":"button",
         "setter":"update"
      },{
         "name":"requestData",
         "type":"call",
         "uiElement":"button",
         "setter":"requestData"
      },{
         "name":"reserveHeader",
         "type":"boolean",
         "uiElement":"checkBox",
         "setter":"reserveHeader"
      },{
         "name":"attachScroller",
         "type":"moveiClip",
         "setter":"attachScroller"
      },{
         "name":"detachScroller",
         "type":"moveiClip",
         "setter":"detachScroller"
      },{
         "name":"bufferSize",
         "type":"uint",
         "uiElement":"textInput",
         "getter":"getBufferSize",
         "setter":"setBufferSize"
      },{
         "name":"dataEventHandler",
         "type":"eventHandler",
         "setter":"dataEventHandler"
      },{
         "name":"positionEventHandler",
         "type":"eventHandler",
         "setter":"positionEventHandler"
      },{
         "name":"onFocusCallBack",
         "type":"eventHandler",
         "setter":"onFocusCallBack"
      },{
         "name":"scrollEventHandler",
         "type":"eventHandler",
         "setter":"scrollEventHandler"
      },{
         "name":"selectEventHandler",
         "type":"eventHandler",
         "setter":"selectEventHandler"
      },{
         "name":"select2SecondPressEventHandler",
         "type":"eventHandler",
         "setter":"select2SecondPressEventHandler"
      }];
      
      public function ListDecorator()
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
         var decoration:List = new List(movieClip);
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

