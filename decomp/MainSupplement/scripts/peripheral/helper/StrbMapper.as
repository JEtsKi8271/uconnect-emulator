package peripheral.helper
{
   import flash.events.TimerEvent;
   import flash.filesystem.File;
   import flash.filesystem.FileMode;
   import flash.filesystem.FileStream;
   import flash.utils.Timer;
   import locale.T;
   
   public class StrbMapper
   {
      
      private static var _mapFile:File;
      
      private static var _isRunningOnPc:Boolean;
      
      private static var _mapXML:XML;
      
      private static var _fileWriteTimer:Timer;
      
      private static var _mapChangedSinceWrite:Boolean;
      
      public static var _shouldWriteMap:Boolean = false;
      
      public function StrbMapper()
      {
         super();
      }
      
      public static function setupMapper(isRunningOnPc:Boolean, projectName:String = "ProjectName") : void
      {
         var stream:FileStream = null;
         _isRunningOnPc = isRunningOnPc;
         if(_isRunningOnPc)
         {
            _mapFile = new File(File.documentsDirectory.nativePath).resolvePath("strbMap.xml");
            _shouldWriteMap = true;
         }
         else
         {
            _mapFile = new File("file:///fs/etfs/strbMap.xml");
            _shouldWriteMap = _mapFile.exists;
         }
         if(_shouldWriteMap)
         {
            if(_mapFile.exists)
            {
               stream = new FileStream();
               stream.open(_mapFile,FileMode.READ);
               _mapXML = SaveLoad_AIR.readXML(_mapFile);
               stream.close();
            }
            if(_mapXML == null || _mapXML.toString() == "" || _mapXML.toString().indexOf("<_" + projectName + ">") == -1 || _mapXML.toString().indexOf("</_" + projectName + ">") == -1 || _mapXML.toString().indexOf("ver=\"1.00\"") == -1)
            {
               _mapXML = new XML("<_" + projectName + " ver=\"1.00\"/>");
               _mapChangedSinceWrite = true;
            }
            _fileWriteTimer = new Timer(5000);
            _fileWriteTimer.addEventListener(TimerEvent.TIMER,onTimer);
            _fileWriteTimer.start();
         }
      }
      
      private static function onTimer(e:TimerEvent) : void
      {
         if(_mapChangedSinceWrite)
         {
            _mapChangedSinceWrite = false;
            SaveLoad_AIR.writeFile(_mapFile,_mapXML);
         }
      }
      
      public static function mapStrbUsage(flaName:String, linkageName:String, textFieldName:String, composition:uint) : void
      {
         var labelAlias:String = null;
         var compositionID:String = null;
         if(!_shouldWriteMap)
         {
            return;
         }
         flaName = flaName.substring(flaName.lastIndexOf("/") + 1,flaName.lastIndexOf("."));
         var textfieldID:String = flaName + "--" + linkageName + "--" + textFieldName;
         if(composition == 12648430)
         {
            labelAlias = "UNKNOWN_LABEL";
         }
         else
         {
            compositionID = "_" + composition.toString();
            labelAlias = T[compositionID];
         }
         if(_mapXML.map.toString() == "")
         {
            _mapXML.map = new XML();
         }
         if(_mapXML.map[labelAlias].toString() == "")
         {
            _mapXML.map[labelAlias] = new XML();
         }
         _mapXML.map[labelAlias][textfieldID] = new XML();
         _mapChangedSinceWrite = true;
      }
   }
}

