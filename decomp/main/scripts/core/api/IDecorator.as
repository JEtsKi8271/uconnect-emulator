package core.api
{
   import flash.display.MovieClip;
   
   public interface IDecorator
   {
      
      function get suffix() : String;
      
      function get functionDescriptors() : Array;
      
      function decorate(param1:MovieClip) : *;
   }
}

