package
{
   import core.widgets.WidgetButton;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol48")]
   public dynamic class C_Button_Regular_45x45_Aha extends WidgetButton
   {
      
      public function C_Button_Regular_45x45_Aha()
      {
         super();
         addFrameScript(0,this.frame1,1,this.frame2);
      }
      
      internal function frame1() : *
      {
         stop();
      }
      
      internal function frame2() : *
      {
         stop();
      }
   }
}

