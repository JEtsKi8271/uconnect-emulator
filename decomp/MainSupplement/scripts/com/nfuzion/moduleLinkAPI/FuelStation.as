package com.nfuzion.moduleLinkAPI
{
   import com.nfuzion.geographic.Coordinates;
   import com.nfuzion.geographic.Direction;
   import com.nfuzion.geographic.Distance;
   
   public class FuelStation
   {
      
      public var id:int = -1;
      
      public var brand:String;
      
      public var name:String;
      
      public var address:String;
      
      public var city:String;
      
      public var state:String;
      
      public var zip:String;
      
      public var phone:String;
      
      public var defaultPrice:String;
      
      public var daysOld:String;
      
      public var prices:Vector.<FuelPrice>;
      
      public var coordinates:Coordinates;
      
      public var favorite:Boolean;
      
      public var distance:Distance;
      
      public var bearing:Direction;
      
      public function FuelStation()
      {
         super();
      }
   }
}

