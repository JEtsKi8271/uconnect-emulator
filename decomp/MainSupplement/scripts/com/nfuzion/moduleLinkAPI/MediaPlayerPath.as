package com.nfuzion.moduleLinkAPI
{
   public class MediaPlayerPath
   {
      
      public static const FILE_ROOT:String = "fs:";
      
      public static const METADATA_ROOT:String = "db:";
      
      public static const BACK:String = "@back";
      
      public static const FORWARD:String = "@forward";
      
      public static const UP:String = "@up";
      
      public static const ALL:String = "*";
      
      public static const DOWN:String = ALL;
      
      public static const ITEM:String = "@";
      
      public static const CATEGORIES:String = "categories";
      
      public static const ARTISTS:String = "artists";
      
      public static const ALBUMS:String = "albums";
      
      public static const SONGS:String = "songs";
      
      public static const SONG:String = "song";
      
      public static const GENRES:String = "genres";
      
      public static const AUDIOBOOK:String = "audiobook";
      
      public static const AUDIOBOOKS:String = "audiobooks";
      
      public static const PLAYLISTS:String = "playlists";
      
      public static const PODCASTS:String = "podcasts";
      
      public static const FOLDERS:String = "folders";
      
      public var id:uint;
      
      public var itemCount:uint;
      
      public var name:String;
      
      public var path:String;
      
      public var type:String;
      
      public var alphaJumpAvailable:Boolean;
      
      public function MediaPlayerPath()
      {
         super();
      }
      
      public function toString(pad:String = "") : String
      {
         return "{\n" + pad + "  id = " + this.id + "\n" + pad + "  name = \"" + this.name + "\"\n" + pad + "  type = \"" + this.type + "\"\n" + pad + "  path = \"" + this.path + "\"\n" + pad + "  itemCount = " + this.itemCount + "\n" + pad + "}";
      }
   }
}

