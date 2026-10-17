package
{
   import com.harman.ui.WindowApps;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol70")]
   public dynamic class C_Window_AppsMain extends WindowApps
   {
      
      public function C_Window_AppsMain()
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

