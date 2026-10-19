package core.api
{
   public interface ILocaleResolver
   {
      
      function getTextByResID(param1:int) : String;
      
      function setLanguage(param1:int, param2:int, param3:Function) : void;
   }
}

