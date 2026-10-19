package extensions.drivemode
{
   public interface IDriveModeDetailSetupExtension
   {
      
      function initScreen(param1:String = "") : void;
      
      function addListeners() : void;
      
      function removeListeners() : void;
      
      function setAWDState() : void;
      
      function setEngineState() : void;
      
      function setMainState() : void;
      
      function setPaddleShifterState() : void;
      
      function setStabilityControlState() : void;
      
      function setSteeringState() : void;
      
      function setSuspensionState() : void;
      
      function setTitleBar(param1:String) : void;
      
      function setTransState() : void;
      
      function sendEngine(param1:String) : void;
      
      function showPopup(param1:Object) : Boolean;
   }
}

