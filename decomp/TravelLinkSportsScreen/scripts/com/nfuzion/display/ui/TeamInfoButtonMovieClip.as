package com.nfuzion.display.ui
{
   import flash.display.IMovieClip;
   import flash.text.TextField;
   import skin.Skin;
   
   public dynamic class TeamInfoButtonMovieClip extends ButtonMovieClip implements IMovieClip
   {
      
      public var team_label:TextField;
      
      public var teamInfo_translate:TextField;
      
      public function TeamInfoButtonMovieClip()
      {
         super();
      }
      
      override protected function setButtonFont() : void
      {
         Skin.style.applyFont(this.team_label,Skin.style.currentTheme.FONT_PRIMARY);
         Skin.style.applyFont(this.teamInfo_translate,Skin.style.currentTheme.FONT_PRIMARY);
      }
      
      override protected function setButtonTextColors() : void
      {
         switch(mCurrentState)
         {
            case STATE_UP:
               Skin.style.applyStyle(this.team_label,Skin.style.currentTheme.primaryText);
               Skin.style.applyStyle(this.teamInfo_translate,Skin.style.currentTheme.primaryText);
               break;
            case STATE_DOWN:
               Skin.style.applyStyle(this.team_label,Skin.style.currentTheme.disabledText);
               Skin.style.applyStyle(this.teamInfo_translate,Skin.style.currentTheme.disabledText);
               break;
            case STATE_ACTIVE:
               Skin.style.applyStyle(this.team_label,Skin.style.currentTheme.primaryText);
               Skin.style.applyStyle(this.teamInfo_translate,Skin.style.currentTheme.primaryText);
               break;
            case STATE_DISABLED:
               Skin.style.applyStyle(this.team_label,Skin.style.currentTheme.disabledText);
               Skin.style.applyStyle(this.teamInfo_translate,Skin.style.currentTheme.disabledText);
         }
      }
   }
}

