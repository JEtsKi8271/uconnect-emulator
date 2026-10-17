package com.harman.framework.controller
{
   import flash.display.MovieClip;
   
   public interface IList
   {
      
      function get view() : MovieClip;
      
      function get length() : int;
      
      function set index(param1:int) : void;
      
      function set selected(param1:int) : void;
      
      function set total(param1:String) : void;
   }
}

