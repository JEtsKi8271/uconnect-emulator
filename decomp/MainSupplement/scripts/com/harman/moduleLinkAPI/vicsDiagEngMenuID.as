package com.harman.moduleLinkAPI
{
   public class vicsDiagEngMenuID
   {
      
      public var STATUS_VICS_BEACON_LINE1:String = "";
      
      public var STATUS_VICS_BEACON_LINE2:String = "";
      
      public var STATUS_ETC_DSRC_LINE1:String = "";
      
      public var STATUS_ETC_DSRC_LINE2:String = "";
      
      public var STATUS_ETC_DSRC_LINE3:String = "";
      
      public var STATUS_ETC_DSRC_LINE4:String = "";
      
      public var STATUS_ETC_DSRC_LINE5:String = "";
      
      public var STATUS_ETC_DSRC_LINE6:String = "";
      
      public var STATUS_ETC_DSRC_LINE7:String = "";
      
      public var STATUS_VICS_TUNER_LINE1:String = "";
      
      public var STATUS_VICS_TUNER_LINE2:String = "";
      
      public var STATUS_VICS_TUNER_LINE3:String = "";
      
      public function vicsDiagEngMenuID()
      {
         super();
      }
      
      public function copyStatusVicsBeacon(value:Object) : vicsDiagEngMenuID
      {
         if(value != null)
         {
            this.STATUS_VICS_BEACON_LINE1 = value.line1;
            this.STATUS_VICS_BEACON_LINE2 = value.line2;
         }
         return this;
      }
      
      public function copyStatusEtcDsrc(value:Object) : vicsDiagEngMenuID
      {
         var data:Array = null;
         if(value != null)
         {
            this.STATUS_ETC_DSRC_LINE1 = value.line1;
            this.STATUS_ETC_DSRC_LINE2 = value.line2;
            data = value.line3.split(": ");
            this.STATUS_ETC_DSRC_LINE3 = data[1];
            this.STATUS_ETC_DSRC_LINE4 = value.line4;
            this.STATUS_ETC_DSRC_LINE5 = value.line5;
            this.STATUS_ETC_DSRC_LINE6 = value.line6;
            this.STATUS_ETC_DSRC_LINE7 = value.line7;
         }
         return this;
      }
      
      public function copyStatusVicsTuner(value:Object) : vicsDiagEngMenuID
      {
         if(value != null)
         {
            this.STATUS_VICS_TUNER_LINE1 = value.line1;
            this.STATUS_VICS_TUNER_LINE2 = value.line2;
            this.STATUS_VICS_TUNER_LINE3 = value.line3;
         }
         return this;
      }
   }
}

