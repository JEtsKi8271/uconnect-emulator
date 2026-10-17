package peripheral.helper
{
   import flash.filesystem.File;
   import flash.filesystem.FileMode;
   import flash.filesystem.FileStream;
   
   public class SaveLoad_AIR
   {
      
      public function SaveLoad_AIR()
      {
         super();
      }
      
      public static function readXML(file:File) : XML
      {
         var str:String = readFile(file);
         if(str != null)
         {
            return new XML(str);
         }
         return null;
      }
      
      public static function readFile(file:File) : String
      {
         var stream:FileStream = null;
         var str:String = null;
         if(file.exists)
         {
            stream = new FileStream();
            stream.open(file,FileMode.READ);
            str = stream.readUTFBytes(stream.bytesAvailable);
            stream.close();
            return str;
         }
         return null;
      }
      
      public static function writeFile(file:File, utf:String) : Boolean
      {
         var stream:FileStream = new FileStream();
         try
         {
            stream.open(file,FileMode.WRITE);
            stream.writeUTFBytes(utf);
            stream.close();
         }
         catch(e:Error)
         {
            return false;
         }
         return true;
      }
   }
}

