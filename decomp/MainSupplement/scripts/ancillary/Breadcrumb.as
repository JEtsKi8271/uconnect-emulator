package ancillary
{
   public class Breadcrumb
   {
      
      public static const INERT:int = 0;
      
      public static const PAGE:int = 1;
      
      public static const FUNCTION:int = 2;
      
      public static const DELTA_FUNCTION:int = 3;
      
      public var composition:Array;
      
      public var type:int;
      
      public var args:*;
      
      public function Breadcrumb(composition:*, type:int = 0, ... args)
      {
         super();
         if(!(composition is Array))
         {
            composition = [composition];
         }
         this.composition = composition;
         this.type = type;
         this.args = args;
      }
   }
}

