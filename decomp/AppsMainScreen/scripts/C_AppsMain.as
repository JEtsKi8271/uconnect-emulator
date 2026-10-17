package
{
   import com.harman.ui.ListApps;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol105")]
   public dynamic class C_AppsMain extends ListApps
   {
      
      public function C_AppsMain()
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

