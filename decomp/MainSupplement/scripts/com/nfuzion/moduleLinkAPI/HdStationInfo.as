package com.nfuzion.moduleLinkAPI
{
   public class HdStationInfo
   {
      
      public var programsAvailable:Vector.<int> = new Vector.<int>(0);
      
      public var hdStationLongName:String = "";
      
      public var hdStationShortName:String = "";
      
      public var hdAudioPlaying:int = 1;
      
      public var hdArtistName:String = "";
      
      public var hdSongTitle:String = "";
      
      public var hdAlbumName:String = "";
      
      public var hdPTY:String = "";
      
      public var hdTagId:String = "";
      
      public var hdTagged:Boolean = false;
      
      public function HdStationInfo()
      {
         super();
      }
      
      public function updateHdStationInfo(newHdStationInfo:Object) : void
      {
         var channel:int = 0;
         if(newHdStationInfo.hasOwnProperty("programsAvailable"))
         {
            this.programsAvailable = new Vector.<int>(0);
            for each(channel in newHdStationInfo.programsAvailable)
            {
               this.programsAvailable.push(channel);
            }
         }
         this.hdStationLongName = newHdStationInfo.hdStationLongName;
         this.hdStationShortName = newHdStationInfo.hdStationShortName;
         this.hdAudioPlaying = newHdStationInfo.hdAudioPlaying;
         this.hdArtistName = newHdStationInfo.hdArtistName;
         this.hdSongTitle = newHdStationInfo.hdSongTitle;
         this.hdAlbumName = newHdStationInfo.hdAlbumName;
         this.hdPTY = newHdStationInfo.hdPTY;
         if(this.hdAudioPlaying < 1 || this.hdAudioPlaying > 8)
         {
            this.hdAudioPlaying = 1;
         }
         if(Boolean(this.hdStationLongName) && this.hdStationLongName.length > 32)
         {
            this.hdStationLongName = this.hdStationLongName.slice(0,32) + "...";
         }
         if(Boolean(this.hdArtistName) && this.hdArtistName.length > 32)
         {
            this.hdArtistName = this.hdArtistName.slice(0,32) + "...";
         }
         if(Boolean(this.hdSongTitle) && this.hdSongTitle.length > 32)
         {
            this.hdSongTitle = this.hdSongTitle.slice(0,32) + "...";
         }
         if(Boolean(this.hdAlbumName) && this.hdAlbumName.length > 32)
         {
            this.hdAlbumName = this.hdAlbumName.slice(0,32) + "...";
         }
      }
   }
}

