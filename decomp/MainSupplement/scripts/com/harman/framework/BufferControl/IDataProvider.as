package com.harman.framework.BufferControl
{
   public interface IDataProvider
   {
      
      function requestNewFrame(param1:int, param2:int, param3:int = -1, param4:int = -1, param5:int = -1) : void;
      
      function FillBuffer(param1:ListBuffer, param2:int, param3:int) : int;
      
      function screenUpdate(param1:FrameRequestReturn) : void;
   }
}

