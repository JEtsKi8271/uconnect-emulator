package com.harman.moduleLinkAPI
{
   public class DABTunerStationInstance
   {
      
      public var flags:int = 0;
      
      public var genres:Array = new Array();
      
      public var names:Array = new Array();
      
      public var quality:Array = new Array();
      
      public var deviceType:int = 0;
      
      public var frequency:int = 0;
      
      public var id:Vector.<uint> = new Vector.<uint>(3,true);
      
      public var receptionState:int = 0;
      
      public var stationType:int = 0;
      
      public var meta:Array = new Array();
      
      public var DLPlusAvailable:Boolean = false;
      
      public var autoSeekState:int = 0;
      
      public var displayName:String = "";
      
      public function DABTunerStationInstance(TunerStation:Object = null)
      {
         var genre:String = null;
         var name:String = null;
         var qual:int = 0;
         var i:int = 0;
         super();
         if(TunerStation == null)
         {
            return;
         }
         if(TunerStation.hasOwnProperty("flags"))
         {
            this.flags = TunerStation.flags;
         }
         if(TunerStation.hasOwnProperty("genre"))
         {
            for each(genre in TunerStation.genre)
            {
               this.genres.push(genre);
            }
         }
         if(TunerStation.hasOwnProperty("meta"))
         {
            this.meta = new Array();
            this.DLPlusAvailable = this.parseMetaList(TunerStation.meta);
         }
         if(TunerStation.hasOwnProperty("name"))
         {
            for each(name in TunerStation.name)
            {
               this.names.push(name);
            }
         }
         if(TunerStation.hasOwnProperty("quality"))
         {
            for each(qual in TunerStation.quality)
            {
               this.quality.push(qual);
            }
         }
         if(TunerStation.hasOwnProperty("receptionState"))
         {
            this.receptionState = TunerStation.receptionState;
         }
         if(TunerStation.hasOwnProperty("sel"))
         {
            this.deviceType = TunerStation.sel.deviceType;
            this.frequency = TunerStation.sel.frequency;
            for(i = 0; i < 3; i++)
            {
               this.id[i] = TunerStation.sel.id[i];
            }
         }
         if(TunerStation.hasOwnProperty("stationType"))
         {
            this.stationType = TunerStation.stationType;
         }
         if(TunerStation.hasOwnProperty("autoSeekContinuedFlag"))
         {
            this.autoSeekState = TunerStation.autoSeekContinuedFlag;
         }
         if(TunerStation.hasOwnProperty("displayName"))
         {
            this.displayName = TunerStation.displayName;
         }
      }
      
      private function parseMetaList(metaTbl:Array) : Boolean
      {
         var bArtist:Boolean = false;
         var bTitle:Boolean = false;
         for(var i:int = 0; i < metaTbl.length; i++)
         {
            if(metaTbl[i].type == DABIndexIdHelper.DAB_DLP_ARTIST)
            {
               bArtist = true;
               this.meta[DABIndexIdHelper.DAB_DLP_ARTIST] = metaTbl[i].str;
            }
            else if(metaTbl[i].type == DABIndexIdHelper.DAB_DLP_TITLE)
            {
               bTitle = true;
               this.meta[DABIndexIdHelper.DAB_DLP_TITLE] = metaTbl[i].str;
            }
         }
         return bArtist && bTitle;
      }
   }
}

