package com.nfuzion.moduleLinkAPI
{
   public class MediaPlayerItem
   {
      
      public static const ARTIST:String = "artist";
      
      public static const ALBUM:String = "album";
      
      public static const DIRECTORY:String = "directory";
      
      public static const SONG:String = "song";
      
      public static const GENRE:String = "genre";
      
      public static const FILE:String = "file";
      
      public static const FOLDER:String = "folder";
      
      public static const PARTITION:String = "partition";
      
      public static const AUDIOBOOK:String = "audiobook";
      
      public static const PLAYLIST:String = "playlist";
      
      public static const PODCAST:String = "podcast";
      
      public static const EPISODE:String = "episode";
      
      public static const CHAPTER:String = "chapter";
      
      public static const WILDCARD_UNKNOWN:String = "$unknown$";
      
      public var id:uint;
      
      public var type:String;
      
      public var name:String;
      
      public var playable:Boolean;
      
      public var browsable:Boolean;
      
      public var nowPlaying:Boolean;
      
      public function MediaPlayerItem()
      {
         super();
      }
      
      public function toString(pad:String = "") : String
      {
         return "{\n" + pad + "  id = " + this.id + "\n" + pad + "  name = \"" + this.name + "\"\n" + pad + "  type = \"" + this.type + "\"\n" + pad + "  playable = \"" + this.playable + "\"\n" + pad + "}";
      }
   }
}

