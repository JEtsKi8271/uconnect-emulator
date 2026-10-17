package core.api
{
   import flash.events.IEventDispatcher;
   
   public interface IThemeEngine extends IEventDispatcher
   {
      
      function init(param1:String = "default", param2:String = "Default/001_Uconnect.swf", param3:String = "fontSwfs/HelveticaNeueLTStd-Roman.swf") : void;
      
      function get ready() : Boolean;
      
      function get theme() : String;
      
      function set theme(param1:String) : void;
      
      function get font() : String;
      
      function set font(param1:String) : void;
      
      function loadTheme(param1:String) : void;
   }
}

