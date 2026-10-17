package apps
{
   import core.utils.Text;
   import flash.display.MovieClip;
   import locale.T;
   import peripheral.Peripheral;
   
   public class AppScreenOff extends App
   {
      
      public function AppScreenOff()
      {
         super();
         id = ID.SCREENOFF;
      }
      
      override public function get cp() : IApp
      {
         return new AppScreenOff();
      }
      
      override public function get id() : String
      {
         return ID.SCREENOFF;
      }
      
      override public function get label() : String
      {
         if(favorite)
         {
            return Text.getText(T.STRB_MENU_SCREEN_OFF);
         }
         return Text.getText(T.STRB_SCREEN_OFF_ML);
      }
      
      override public function get button() : MovieClip
      {
         if(super.button == null)
         {
            button = new C_Button_ScreenOff();
         }
         return mButton;
      }
      
      override public function set wave(_visible:Boolean) : void
      {
      }
      
      override public function set favorite(_favorite:Boolean) : void
      {
         super.favorite = _favorite;
         super.adjustLabel(this.button.label);
      }
      
      override public function addListeners() : void
      {
         super.addListeners();
      }
      
      override public function removeListeners() : void
      {
         super.removeListeners();
      }
      
      override public function press() : void
      {
         Peripheral.ics.sendScreenOffSKPressed();
      }
      
      override public function refresh() : void
      {
         this.updateLocale();
      }
      
      override public function updateLocale() : void
      {
         if(favorite)
         {
            Text.format(this.button.label,T.STRB_MENU_SCREEN_OFF);
         }
         else
         {
            Text.format(this.button.label,T.STRB_SCREEN_OFF_ML);
         }
      }
   }
}

