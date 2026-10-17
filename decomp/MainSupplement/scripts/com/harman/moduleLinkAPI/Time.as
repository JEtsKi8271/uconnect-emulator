package com.harman.moduleLinkAPI
{
   public class Time
   {
      
      public var year:int;
      
      public var month:int;
      
      public var day:int;
      
      public var hour:int;
      
      public var minute:int;
      
      public function Time(_year:int = 2012, _month:int = 1, _day:int = 1, _hour:int = 12, _minute:int = 0)
      {
         super();
         this.year = _year;
         this.month = _month;
         this.day = _day;
         this.hour = _hour;
         this.minute = _minute;
      }
   }
}

