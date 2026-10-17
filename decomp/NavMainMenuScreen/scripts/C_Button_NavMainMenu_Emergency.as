package
{
   import com.harman.ui.ButtonNavMenu;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol32")]
   public dynamic class C_Button_NavMainMenu_Emergency extends ButtonNavMenu
   {
      
      public function C_Button_NavMainMenu_Emergency()
      {
         super();
         addFrameScript(0,this.frame1);
      }
      
      internal function frame1() : *
      {
         stop();
      }
   }
}

