package extensions.nav
{
   public interface INavMenuWhereToExtension
   {
      
      function addListeners() : void;
      
      function removeListeners() : void;
      
      function onBtn(param1:int) : void;
      
      function onBack() : void;
      
      function onCancel() : void;
   }
}

