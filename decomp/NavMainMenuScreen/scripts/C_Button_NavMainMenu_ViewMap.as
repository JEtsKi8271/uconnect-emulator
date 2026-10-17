package
{
   import com.harman.ui.ButtonNavMenu;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol45")]
   public dynamic class C_Button_NavMainMenu_ViewMap extends ButtonNavMenu
   {
      
      public function C_Button_NavMainMenu_ViewMap()
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

