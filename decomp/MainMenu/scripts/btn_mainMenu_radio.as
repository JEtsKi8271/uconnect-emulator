package
{
   import com.nfuzion.display.ui.MainMenuButtonMovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol170")]
   public dynamic class btn_mainMenu_radio extends MainMenuButtonMovieClip
   {
      
      public function btn_mainMenu_radio()
      {
         super();
         addFrameScript(0,this.frame1,9,this.frame10,19,this.frame20,29,this.frame30,39,this.frame40,49,this.frame50,59,this.frame60,69,this.frame70);
      }
      
      internal function frame1() : *
      {
         stop();
         glow.visible = false;
      }
      
      internal function frame10() : *
      {
         glow.visible = false;
      }
      
      internal function frame20() : *
      {
         glow.visible = true;
      }
      
      internal function frame30() : *
      {
         glow.visible = true;
      }
      
      internal function frame40() : *
      {
         glow.visible = false;
      }
      
      internal function frame50() : *
      {
         glow.visible = false;
      }
      
      internal function frame60() : *
      {
         glow.visible = true;
      }
      
      internal function frame70() : *
      {
         glow.visible = true;
      }
   }
}

