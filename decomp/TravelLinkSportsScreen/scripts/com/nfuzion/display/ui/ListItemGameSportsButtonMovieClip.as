package com.nfuzion.display.ui
{
   import flash.display.IMovieClip;
   import flash.text.TextField;
   import skin.Skin;
   
   public dynamic class ListItemGameSportsButtonMovieClip extends ButtonMovieClip implements IMovieClip
   {
      
      public var team1_label:TextField;
      
      public var team2_label:TextField;
      
      public var team1Score_label:TextField;
      
      public var team2Score_label:TextField;
      
      public var inning_label:TextField;
      
      public var status_label:TextField;
      
      public function ListItemGameSportsButtonMovieClip()
      {
         super();
      }
      
      override protected function setButtonFont() : void
      {
         Skin.style.applyFont(this.team1_label,Skin.style.currentTheme.FONT_PRIMARY);
         Skin.style.applyFont(this.team2_label,Skin.style.currentTheme.FONT_PRIMARY);
         Skin.style.applyFont(this.team1Score_label,Skin.style.currentTheme.FONT_PRIMARY);
         Skin.style.applyFont(this.team2Score_label,Skin.style.currentTheme.FONT_PRIMARY);
         Skin.style.applyFont(this.inning_label,Skin.style.currentTheme.FONT_PRIMARY);
         Skin.style.applyFont(this.status_label,Skin.style.currentTheme.FONT_PRIMARY);
      }
      
      override protected function setButtonTextColors() : void
      {
         Skin.style.applyStyle(this.team1_label,Skin.style.currentTheme.primaryText);
         Skin.style.applyStyle(this.team2_label,Skin.style.currentTheme.primaryText);
         Skin.style.applyStyle(this.team1Score_label,Skin.style.currentTheme.primaryText);
         Skin.style.applyStyle(this.team2Score_label,Skin.style.currentTheme.primaryText);
         Skin.style.applyStyle(this.inning_label,Skin.style.currentTheme.primaryText);
         Skin.style.applyStyle(this.status_label,Skin.style.currentTheme.primaryText);
      }
   }
}

