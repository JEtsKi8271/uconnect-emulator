package flash.display
{
   public interface IMovieClip extends ISprite
   {
      
      function addFrameScript(... rest) : void;
      
      function get currentFrame() : int;
      
      function get currentFrameLabel() : String;
      
      function get currentLabel() : String;
      
      function get currentLabels() : Array;
      
      function get currentScene() : Scene;
      
      function get enabled() : Boolean;
      
      function set enabled(param1:Boolean) : void;
      
      function get framesLoaded() : int;
      
      function gotoAndPlay(param1:Object, param2:String = null) : void;
      
      function gotoAndStop(param1:Object, param2:String = null) : void;
      
      function nextFrame() : void;
      
      function nextScene() : void;
      
      function play() : void;
      
      function prevFrame() : void;
      
      function prevScene() : void;
      
      function get scenes() : Array;
      
      function stop() : void;
      
      function get totalFrames() : int;
      
      function get trackAsMenu() : Boolean;
      
      function set trackAsMenu(param1:Boolean) : void;
   }
}

