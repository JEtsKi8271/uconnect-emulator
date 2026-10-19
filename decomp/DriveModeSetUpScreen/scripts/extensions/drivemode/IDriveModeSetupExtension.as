package extensions.drivemode
{
   import com.harman.moduleLinkAPI.DriveModeEvent;
   
   public interface IDriveModeSetupExtension
   {
      
      function addListeners() : void;
      
      function removeListeners() : void;
      
      function modeChanged(param1:DriveModeEvent) : void;
      
      function initView() : void;
      
      function initScreen(param1:String = "") : void;
      
      function setTitleBar() : void;
      
      function showPopup(param1:Object) : Boolean;
   }
}

