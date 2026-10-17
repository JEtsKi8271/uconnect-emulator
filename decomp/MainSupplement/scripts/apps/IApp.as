package apps
{
   import flash.display.MovieClip;
   
   public interface IApp
   {
      
      function get cp() : IApp;
      
      function get id() : String;
      
      function get label() : String;
      
      function get button() : MovieClip;
      
      function set button(param1:MovieClip) : void;
      
      function get embedded() : Boolean;
      
      function get vr() : Boolean;
      
      function set vr(param1:Boolean) : void;
      
      function set wave(param1:Boolean) : void;
      
      function get favorite() : Boolean;
      
      function set favorite(param1:Boolean) : void;
      
      function slay() : void;
      
      function press() : void;
      
      function refresh() : void;
      
      function updateIcon() : void;
      
      function updateLocale() : void;
      
      function addListeners() : void;
      
      function removeListeners() : void;
   }
}

