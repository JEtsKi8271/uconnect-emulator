package com.nfuzion.display.ui
{
   import flash.display.MovieClip;
   import flash.text.TextField;
   import skin.Skin;
   
   public dynamic class TravelLinkSportsDefaultScreenViewMovieClip extends BaseMovieClip
   {
      
      public var list_scroller:ScrollbarComponent;
      
      public var views_group:MovieClip;
      
      public var viewButtons_group:MovieClip;
      
      public var itemsInList_label:TextField;
      
      public var displayTitle:DisplayTitleMovieClip;
      
      public var back_button:ButtonMovieClip;
      
      public var travelLink_button:NoIconButtonMovieClip;
      
      public function TravelLinkSportsDefaultScreenViewMovieClip()
      {
         super();
      }
      
      override protected function updateTheme() : void
      {
         var style:Object = Skin.style;
         var primFont:String = Skin.style.currentTheme.FONT_PRIMARY;
         var primText:Object = Skin.style.currentTheme.primaryText;
         var msgGrp:MovieClip = this.views_group.message_group;
         var teamGrp:MovieClip = this.views_group.teamInfo_group;
         var gameGrp:MovieClip = this.views_group.gameInfo_group;
         style.applyFont(msgGrp.message_label,primFont);
         style.applyFont(teamGrp.row1column1_label,primFont);
         style.applyFont(teamGrp.row2column1_label,primFont);
         style.applyFont(teamGrp.row3column1_label,primFont);
         style.applyFont(teamGrp.row4column1_label,primFont);
         style.applyFont(teamGrp.row5column1_label,primFont);
         style.applyFont(teamGrp.row6column1_label,primFont);
         style.applyFont(teamGrp.row1column2_label,primFont);
         style.applyFont(teamGrp.row2column2_label,primFont);
         style.applyFont(teamGrp.row3column2_label,primFont);
         style.applyFont(teamGrp.row4column2_label,primFont);
         style.applyFont(teamGrp.row5column2_label,primFont);
         style.applyFont(teamGrp.row6column2_label,primFont);
         style.applyFont(teamGrp.row1column3_label,primFont);
         style.applyFont(teamGrp.row2column3_label,primFont);
         style.applyFont(teamGrp.row3column3_label,primFont);
         style.applyFont(teamGrp.row4column3_label,primFont);
         style.applyFont(teamGrp.row5column3_label,primFont);
         style.applyFont(teamGrp.row6column3_label,primFont);
         style.applyFont(gameGrp.team1_label,primFont);
         style.applyFont(gameGrp.team2_label,primFont);
         style.applyFont(gameGrp.score1_label,primFont);
         style.applyFont(gameGrp.score2_label,primFont);
         style.applyFont(gameGrp.inning_label,primFont);
         style.applyFont(gameGrp.time_label,primFont);
         style.applyFont(gameGrp.status_label,primFont);
         style.applyFont(this.views_group.noData_group.label_translate,primFont);
         style.applyFont(this.views_group.headlineDetails_group.headlineDetails.description_label,primFont);
         style.applyStyle(msgGrp.message_label,primText);
         style.applyStyle(teamGrp.row1column1_label,primText);
         style.applyStyle(teamGrp.row2column1_label,primText);
         style.applyStyle(teamGrp.row3column1_label,primText);
         style.applyStyle(teamGrp.row4column1_label,primText);
         style.applyStyle(teamGrp.row5column1_label,primText);
         style.applyStyle(teamGrp.row6column1_label,primText);
         style.applyStyle(teamGrp.row1column2_label,primText);
         style.applyStyle(teamGrp.row2column2_label,primText);
         style.applyStyle(teamGrp.row3column2_label,primText);
         style.applyStyle(teamGrp.row4column2_label,primText);
         style.applyStyle(teamGrp.row5column2_label,primText);
         style.applyStyle(teamGrp.row6column2_label,primText);
         style.applyStyle(teamGrp.row1column3_label,primText);
         style.applyStyle(teamGrp.row2column3_label,primText);
         style.applyStyle(teamGrp.row3column3_label,primText);
         style.applyStyle(teamGrp.row4column3_label,primText);
         style.applyStyle(teamGrp.row5column3_label,primText);
         style.applyStyle(teamGrp.row6column3_label,primText);
         style.applyStyle(gameGrp.team1_label,primText);
         style.applyStyle(gameGrp.team2_label,primText);
         style.applyStyle(gameGrp.score1_label,primText);
         style.applyStyle(gameGrp.score2_label,primText);
         style.applyStyle(gameGrp.inning_label,primText);
         style.applyStyle(gameGrp.time_label,primText);
         style.applyStyle(gameGrp.status_label,primText);
         style.applyStyle(this.views_group.noData_group.label_translate,primText);
         style.applyStyle(this.views_group.headlineDetails_group.headlineDetails.description_label,primText);
      }
   }
}

