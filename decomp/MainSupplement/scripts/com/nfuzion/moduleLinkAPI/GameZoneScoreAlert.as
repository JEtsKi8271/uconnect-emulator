package com.nfuzion.moduleLinkAPI
{
   public class GameZoneScoreAlert
   {
      
      private var mChannel:int = -1;
      
      private var mGameArtist:String = "";
      
      private var mGameTitle:String = "";
      
      public function GameZoneScoreAlert()
      {
         super();
      }
      
      public function get channel() : int
      {
         return this.mChannel;
      }
      
      public function set channel(c:int) : void
      {
         this.mChannel = c;
      }
      
      public function get gameArtist() : String
      {
         return this.mGameArtist;
      }
      
      public function set gameArtist(s:String) : void
      {
         this.mGameArtist = s;
      }
      
      public function get gameTitle() : String
      {
         return this.mGameTitle;
      }
      
      public function set gameTitle(s:String) : void
      {
         this.mGameTitle = s;
      }
   }
}

