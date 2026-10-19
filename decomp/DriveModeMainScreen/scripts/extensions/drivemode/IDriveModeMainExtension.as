package extensions.drivemode
{
   public interface IDriveModeMainExtension
   {
      
      function addListeners() : void;
      
      function removeListeners() : void;
      
      function initView() : void;
      
      function initScreen(param1:Object = null) : void;
      
      function changeLocale() : void;
      
      function cleanup() : void;
      
      function onLockOut() : void;
      
      function updateMainScreen() : void;
   }
}

