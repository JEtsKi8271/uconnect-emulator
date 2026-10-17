package decorators
{
   import com.nfuzion.framework.global.Framework;
   import core.api.IDecorator;
   import decorations.Scroller;
   import events.WidgetEvent;
   import flash.display.MovieClip;
   
   public dynamic class ScrollerDecorator implements IDecorator
   {
      
      private static const SUFFIX:String = "scroller";
      
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
         "name":"horizontalEnabled",
         "type":"boolean",
         "uiElement":"checkBox",
         "getter":"getHorizontalEnabled",
         "setter":"setHorizontalEnabled"
      },{
         "name":"verticalEnabled",
         "type":"boolean",
         "uiElement":"checkBox",
         "getter":"getVerticalEnabled",
         "setter":"setVerticalEnabled"
      },{
         "name":"roundValues",
         "type":"boolean",
         "uiElement":"checkBox",
         "getter":"getRoundValues",
         "setter":"setRoundValues"
      },{
         "name":"sensitiveTrack",
         "type":"boolean",
         "uiElement":"checkBox",
         "getter":"getSensitiveTrack",
         "setter":"setSensitiveTrack"
      },{
         "name":"hideIfUselss",
         "type":"boolean",
         "uiElement":"checkBox",
         "getter":"getHideIfUseless",
         "setter":"setHideIfUseless"
      },{
         "name":"disableButtons",
         "type":"boolean",
         "uiElement":"checkBox",
         "getter":"getDisableButtons",
         "setter":"setDisableButtons"
      },{
         "name":"reportingPeriod",
         "type":"uint",
         "uiElement":"textInput",
         "getter":"getReportingPeriod",
         "setter":"setReportingPeriod",
         "changeEvent":WidgetEvent.POSITION
      },{
         "name":"progressTracksThumb",
         "type":"boolean",
         "uiElement":"checkBox",
         "getter":"getProgressTracksThumb",
         "setter":"setProgressTracksThumb"
      },{
         "name":"value",
         "type":"number",
         "uiElement":"textInput",
         "getter":"getValue",
         "setter":"setValue",
         "changeEvent":WidgetEvent.POSITION
      },{
         "name":"hValue",
         "type":"number",
         "uiElement":"textInput",
         "getter":"getHValue",
         "setter":"setHValue",
         "changeEvent":WidgetEvent.HORIZONTAL_POSITION
      },{
         "name":"hTrackValue",
         "type":"number",
         "uiElement":"textInput",
         "getter":"getHTrackValue"
      },{
         "name":"vValue",
         "type":"number",
         "uiElement":"textInput",
         "getter":"getVValue",
         "setter":"setVValue",
         "changeEvent":WidgetEvent.VERTICAL_POSITION
      },{
         "name":"vTrackValue",
         "type":"number",
         "uiElement":"textInput",
         "getter":"getVTrackValue",
         "setter":"setVValue"
      },{
         "name":"minimum",
         "type":"number",
         "uiElement":"textInput",
         "getter":"getMinimum",
         "setter":"setMinimum"
      },{
         "name":"hMinimum",
         "type":"number",
         "uiElement":"textInput",
         "getter":"getHMinimum",
         "setter":"setHMinimum"
      },{
         "name":"vMinimum",
         "type":"number",
         "uiElement":"textInput",
         "getter":"getVMinimum",
         "setter":"setVMinimum"
      },{
         "name":"maximum",
         "type":"int",
         "uiElement":"textInput",
         "getter":"getMaximum",
         "setter":"setMaximum"
      },{
         "name":"hMaximum",
         "type":"int",
         "uiElement":"textInput",
         "getter":"getHMaximum",
         "setter":"setHMaximum"
      },{
         "name":"vMaximum",
         "type":"int",
         "uiElement":"textInput",
         "getter":"getVMaximum",
         "setter":"setVMaximum"
      },{
         "name":"pageSize",
         "type":"number",
         "uiElement":"textInput",
         "getter":"getPageSize",
         "setter":"setPageSize"
      },{
         "name":"hPageSize",
         "type":"number",
         "uiElement":"textInput",
         "getter":"getHPageSize",
         "setter":"setHPageSize"
      },{
         "name":"vPageSize",
         "type":"number",
         "uiElement":"textInput",
         "getter":"getVPageSize",
         "setter":"setVPageSize"
      },{
         "name":"progress",
         "type":"number",
         "uiElement":"textInput",
         "getter":"getProgress",
         "setter":"setProgress"
      },{
         "name":"hProgress",
         "type":"number",
         "uiElement":"textInput",
         "getter":"getHProgress",
         "setter":"setHProgress"
      },{
         "name":"vProgress",
         "type":"number",
         "uiElement":"textInput",
         "getter":"getVProgress",
         "setter":"setVProgress"
      },{
         "name":"hLimit",
         "type":"number",
         "uiElement":"textInput",
         "getter":"getHLimit",
         "setter":"setHLimit"
      },{
         "name":"maximumEventHandler",
         "type":"event",
         "setter":"maximumEventHandler"
      },{
         "name":"hMaximumEventHandler",
         "type":"event",
         "setter":"hMaximumEventHandler"
      },{
         "name":"vMaximumEventHandler",
         "type":"event",
         "setter":"vMaximumEventHandler"
      },{
         "name":"pageSizeEventHandler",
         "type":"event",
         "setter":"pageSizeEventHandler"
      },{
         "name":"hPageSizeEventHandler",
         "type":"event",
         "setter":"hPageSizeEventHandler"
      },{
         "name":"vPageSizeEventHandler",
         "type":"event",
         "setter":"vPageSizeEventHandler"
      },{
         "name":"thumbDown",
         "type":"boolean",
         "uiElement":"checkBox",
         "getter":"getThumbDown",
         "changeEvent":WidgetEvent.POSITION
      },{
         "name":"popupPageThreshold",
         "type":"uint",
         "uiElement":"textInput",
         "getter":"getPopupPageThreshold",
         "setter":"setPopupPageThreshold"
      },{
         "name":"popupUpdater",
         "type":"function",
         "setter":"setPopupUpdater"
      }];
      
      public function ScrollerDecorator()
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
         var decoration:Scroller = new Scroller(movieClip);
         for each(descriptor in this.functionDescriptors)
         {
            try
            {
               if(descriptor.getter)
               {
                  movieClip[descriptor.getter] = decoration[descriptor.getter];
               }
            }
            catch(e:Error)
            {
               Framework.Trace("Error adding getter " + descriptor.getter + "() method to \"" + suffix + "\" decorator");
            }
            try
            {
               if(descriptor.setter)
               {
                  movieClip[descriptor.setter] = decoration[descriptor.setter];
               }
            }
            catch(e:Error)
            {
               Framework.Trace("Error adding setter " + descriptor.setter + "() method to \"" + suffix + "\" decorator");
            }
         }
         movieClip.parseChildren = true;
         return decoration;
      }
   }
}

