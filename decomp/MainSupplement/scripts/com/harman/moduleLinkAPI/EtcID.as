package com.harman.moduleLinkAPI
{
   import mx.utils.Base64Decoder;
   
   public class EtcID
   {
      
      public static const INITIALIZING:uint = 0;
      
      public static const COMMUNICATION_ERROR:uint = 1;
      
      public static const DEVICE_ERROR:uint = 2;
      
      public static const DEVICE_UNREGISTERED:uint = 3;
      
      public static const DEVICE_REGISTRATION_INVALID:uint = 4;
      
      public static const CARD_AVAILABLE:uint = 5;
      
      public static const NO_CARD_INSERTED:uint = 6;
      
      public static const CARD_INSERT_ERROR:uint = 7;
      
      public static const CARD_READWRITE_ERROR:uint = 8;
      
      public static const STANDARD:uint = 0;
      
      public static const BIG:uint = 1;
      
      public static const SPECIAL_BIG:uint = 2;
      
      public static const MEDIUM:uint = 3;
      
      public static const KEICAR:uint = 4;
      
      public static const LIGHTCAR:uint = 5;
      
      public static const NOTLIMITED:uint = 6;
      
      public static const DEVTYPE_UNKNOWN:uint = 0;
      
      public static const DEVTYPE_ETC:uint = 1;
      
      public static const DEVTYPE_DSRC:uint = 2;
      
      public static const GET_SUCCESS:uint = 0;
      
      public static const GET_NO_INFO:uint = 1;
      
      public static const GET_UNAVAILABLE:uint = 2;
      
      public var ENTRIES:Vector.<VicsEtcPaymentInfo> = new Vector.<VicsEtcPaymentInfo>();
      
      public var CONTINUE:Boolean = false;
      
      public var GET_HISTORY_RESULT:uint = 0;
      
      public var ENG:String = "";
      
      public var JPN:String = "";
      
      public var EXPIRATION_YEAR:uint = 0;
      
      public var EXPIRATION_MONTH:uint = 0;
      
      public var EXPIRATION_DAY:uint = 0;
      
      public var REMAINING_DAYS:uint = 0;
      
      public var STATUS:uint = 0;
      
      public var DEVICE_TYPE:uint = 0;
      
      public var UNIT_NUMBER:String = "";
      
      public var CHECK_DIGIT:String = "";
      
      public function EtcID()
      {
         super();
      }
      
      public function copyCardExpirationDate(value:Object) : EtcID
      {
         if(value != null)
         {
            this.EXPIRATION_YEAR = value.Year;
            this.EXPIRATION_MONTH = value.Month;
            this.EXPIRATION_DAY = value.Day;
            this.REMAINING_DAYS = value.RemainingDays;
         }
         return this;
      }
      
      public function copyPaymentHistory(value:Object) : EtcID
      {
         var base64Decoder:Base64Decoder = null;
         var newEntries:VicsEtcPaymentInfo = null;
         if(value != null)
         {
            base64Decoder = new Base64Decoder();
            newEntries = new VicsEtcPaymentInfo();
            base64Decoder.decode(value.Entries.EnterGateName.Jpn);
            newEntries.ENTER_GATE_NAME_JPN = base64Decoder.toByteArray().toString();
            base64Decoder.decode(value.Entries.ExitGateName.Jpn);
            newEntries.EXIT_GATE_NAME_JPN = base64Decoder.toByteArray().toString();
            newEntries.ENTER_GATE_NAME_ENG = value.Entries.EnterGateName.Eng;
            newEntries.EXIT_GATE_NAME_ENG = value.Entries.ExitGateName.Eng;
            newEntries.YEAR = value.Entries.Year;
            newEntries.MONTH = value.Entries.Month;
            newEntries.DAY = value.Entries.Day;
            newEntries.HOUR = value.Entries.Hour;
            newEntries.MINUTE = value.Entries.Minute;
            newEntries.CAR_TYPE = value.Entries.CarType;
            newEntries.FARE = value.Entries.Fare;
            this.ENTRIES.push(newEntries);
            this.CONTINUE = value.Continue;
            this.GET_HISTORY_RESULT = value.GetHistoryResult;
         }
         return this;
      }
      
      public function copyEtcState(value:Object) : EtcID
      {
         var data:Array = null;
         if(value != null)
         {
            this.STATUS = value.status;
            this.DEVICE_TYPE = value.deviceType;
            data = value.unitNumber.split("_");
            this.UNIT_NUMBER = data[0];
            this.CHECK_DIGIT = data[1];
         }
         return this;
      }
      
      public function deletePaymentHistory() : EtcID
      {
         var length:uint = this.ENTRIES.length;
         for(var count:int = 0; count < length; count++)
         {
            this.ENTRIES.pop();
         }
         return this;
      }
   }
}

