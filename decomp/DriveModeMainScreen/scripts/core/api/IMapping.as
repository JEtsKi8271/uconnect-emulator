package core.api
{
   public interface IMapping
   {
      
      function getAddress(param1:String) : String;
      
      function getDomain(param1:String) : String;
      
      function isNavDomain(param1:String) : Boolean;
      
      function modifyHistory(param1:String) : void;
   }
}

