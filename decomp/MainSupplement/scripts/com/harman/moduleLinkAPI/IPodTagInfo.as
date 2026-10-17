package com.harman.moduleLinkAPI
{
   public class IPodTagInfo
   {
      
      private var mArtist:String;
      
      private var mSongId:uint = 0;
      
      private var mTitle:String;
      
      public function IPodTagInfo()
      {
         super();
         this.clear();
      }
      
      public function set artist(value:String) : void
      {
         this.mArtist = value;
      }
      
      public function set songId(value:uint) : void
      {
         this.mSongId = value;
      }
      
      public function set title(value:String) : void
      {
         this.mTitle = value;
      }
      
      public function get artist() : String
      {
         return this.mArtist;
      }
      
      public function get songId() : uint
      {
         return this.mSongId;
      }
      
      public function get title() : String
      {
         return this.mTitle;
      }
      
      public function clear() : void
      {
         this.mArtist = "";
         this.mSongId = 0;
         this.mTitle = "";
      }
      
      public function isSame(other:IPodTagInfo) : Boolean
      {
         if(other != null)
         {
            if(this.mArtist == other.artist && this.mSongId == other.songId && this.mTitle == other.title)
            {
               return true;
            }
         }
         return false;
      }
      
      public function isDifferent(other:IPodTagInfo) : Boolean
      {
         return !this.isSame(other);
      }
   }
}

