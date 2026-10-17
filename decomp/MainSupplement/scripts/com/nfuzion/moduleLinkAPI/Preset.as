package com.nfuzion.moduleLinkAPI
{
   public class Preset
   {
      
      private var m_Key:String;
      
      private var m_Position:int;
      
      private var m_Band:String;
      
      private var m_Freq_Channel:int;
      
      private var m_SubChannel:int;
      
      private var m_StationName:String;
      
      private var m_Genre:String;
      
      private var m_Active:Boolean;
      
      private var m_DabEnsemID:Vector.<uint>;
      
      private var m_AmFMPI:int;
      
      public function Preset()
      {
         super();
         this.m_Key = null;
         this.m_Position = -1;
         this.m_Band = TunerBand.UNKNOWN;
         this.m_Freq_Channel = -1;
         this.m_SubChannel = -1;
         this.m_StationName = null;
         this.m_Genre = null;
         this.m_Active = false;
         this.m_DabEnsemID = new Vector.<uint>(3,true);
         this.m_AmFMPI = 0;
      }
      
      public function updatePreset(newPreset:Object) : void
      {
         this.Position = newPreset.Position;
         this.Band = newPreset.Band;
         this.Freq_Channel = newPreset.Freq_Channel;
         this.SubChannel = newPreset.SubChannel;
         this.StationName = newPreset.StationName;
         this.Genre = newPreset.Genre;
         this.Active = newPreset.Active;
         this.DAB_EnsembleIDs[0] = newPreset.EnsembID[0];
         this.DAB_EnsembleIDs[1] = newPreset.EnsembID[1];
         this.DAB_EnsembleIDs[2] = newPreset.EnsembID[2];
         this.PI = newPreset.PID;
      }
      
      public function updatePresetNewAPI(newPreset:Object) : void
      {
         this.Position = newPreset.presetId;
         this.Band = newPreset.waveband;
         this.Band = this.Band.toLowerCase();
         this.Freq_Channel = newPreset.frequency;
         this.SubChannel = newPreset.SubChannel;
         this.StationName = newPreset.senderName;
         this.Active = newPreset.selected;
         this.PI = newPreset.pi;
      }
      
      public function get Key() : String
      {
         return this.m_Key;
      }
      
      public function get Position() : int
      {
         return this.m_Position;
      }
      
      public function set Position(p:int) : void
      {
         if(p >= 0 && p < PresetPersistencyConstants.MAX_NUMBER_OF_PRESETS_PER_BAND)
         {
            this.m_Position = p;
         }
         else
         {
            this.m_Position = -1;
         }
         if(this.m_Band != TunerBand.UNKNOWN && this.m_Position != -1)
         {
            this.m_Key = this.m_Band + this.zeroPad(this.m_Position,2);
         }
         else
         {
            this.m_Key = null;
         }
      }
      
      public function get Band() : String
      {
         return this.m_Band;
      }
      
      public function set Band(bt:String) : void
      {
         this.m_Band = bt;
         if(this.m_Band != TunerBand.UNKNOWN && this.m_Position != -1)
         {
            this.m_Key = this.m_Band + this.zeroPad(this.m_Position,2);
         }
         else
         {
            this.m_Key = null;
         }
      }
      
      public function get Freq_Channel() : int
      {
         return this.m_Freq_Channel;
      }
      
      public function set Freq_Channel(f:int) : void
      {
         this.m_Freq_Channel = f;
      }
      
      public function get SubChannel() : int
      {
         return this.m_SubChannel;
      }
      
      public function set SubChannel(s:int) : void
      {
         this.m_SubChannel = s;
      }
      
      public function get StationName() : String
      {
         return this.m_StationName;
      }
      
      public function set StationName(s:String) : void
      {
         this.m_StationName = s;
      }
      
      public function get Genre() : String
      {
         return this.m_Genre;
      }
      
      public function set Genre(g:String) : void
      {
         this.m_Genre = g;
      }
      
      public function get Active() : Boolean
      {
         return this.m_Active;
      }
      
      public function set Active(g:Boolean) : void
      {
         this.m_Active = g;
      }
      
      public function get DAB_EnsembleIDs() : Vector.<uint>
      {
         return this.m_DabEnsemID;
      }
      
      public function set DAB_EnsembleIDs(ids:Vector.<uint>) : void
      {
         this.m_DabEnsemID[0] = ids[0];
         this.m_DabEnsemID[1] = ids[1];
         this.m_DabEnsemID[2] = ids[2];
      }
      
      public function get PI() : int
      {
         return this.m_AmFMPI;
      }
      
      public function set PI(picode:int) : void
      {
         this.m_AmFMPI = picode;
      }
      
      private function zeroPad(number:int, width:int) : String
      {
         var ret:String = "" + number;
         while(ret.length < width)
         {
            ret = "0" + ret;
         }
         return ret;
      }
   }
}

