package com.harman.navigation.Controller.LiveServices
{
   import com.harman.navigation.utils.LocationDescription;
   
   public class WeatherResultList
   {
      
      private var mList:Array = new Array();
      
      private var mOrder:Array = new Array();
      
      private var mLocationDetailsRequestPerformed:Boolean = false;
      
      public function WeatherResultList()
      {
         super();
      }
      
      public function importData(weatherList:Array) : void
      {
         this.mList = weatherList;
         this.orderList();
      }
      
      public function setLocationDetails(loc:LocationDescription) : void
      {
         this.mLocationDetailsRequestPerformed = true;
         this.mList[0].location["details"] = loc;
      }
      
      public function getDataForDay(day:int) : Object
      {
         if(this.mList.length > 0 && this.mOrder.length > day)
         {
            if(this.mList[0].hasOwnProperty("weatherReport"))
            {
               return this.mList[0].weatherReport[int(this.mOrder[day]["listIndex"])];
            }
         }
         return new Object();
      }
      
      public function get list() : Array
      {
         return this.mList;
      }
      
      public function get locationDetailsRequestPerformed() : Boolean
      {
         return this.mLocationDetailsRequestPerformed;
      }
      
      private function orderList() : void
      {
         var j:int = 0;
         var date:Date = null;
         this.mOrder.splice(this.mOrder.length);
         for(var i:int = 0; i < this.mList.length; i++)
         {
            if(this.mList[i].hasOwnProperty("weatherReport"))
            {
               for(j = 0; j < this.mList[i].weatherReport.length; j++)
               {
                  if(Boolean(this.mList[i].weatherReport[j].hasOwnProperty("weatherDefinition")) && Boolean(this.mList[i].weatherReport[j].weatherDefinition.hasOwnProperty("date")) && Boolean(this.mList[i].weatherReport[j].weatherDefinition.hasOwnProperty("period")) && Boolean(this.mList[i].weatherReport[j].hasOwnProperty("reportType")))
                  {
                     if(Boolean(this.mList[i].weatherReport[j].weatherDefinition.date.hasOwnProperty("year") && this.mList[i].weatherReport[j].weatherDefinition.date.hasOwnProperty("month") && this.mList[i].weatherReport[j].weatherDefinition.date.hasOwnProperty("day")) && Boolean(this.mList[i].weatherReport[j].reportType as int == WeatherTypes.REPORT_TYPE_DAILY) && this.checkPeriod(this.mList[i].weatherReport[j].weatherDefinition.period))
                     {
                        date = new Date(int(this.mList[i].weatherReport[j].weatherDefinition.date.year),int(this.mList[i].weatherReport[j].weatherDefinition.date.month - 1),int(this.mList[i].weatherReport[j].weatherDefinition.date.day));
                        this.mList[i].weatherReport[j].weatherDefinition.date = date;
                        this.addDateToOrder(date,j);
                     }
                  }
               }
            }
         }
      }
      
      private function checkPeriod(period:Object) : Boolean
      {
         if(!(period is Array))
         {
            return false;
         }
         if((period as Array).length <= 0)
         {
            return false;
         }
         switch(int((period as Array)[0]))
         {
            case WeatherTypes.PERIOD_NOW:
            case WeatherTypes.PERIOD_TODAY:
            case WeatherTypes.PERIOD_TONIGHT:
            case WeatherTypes.PERIOD_TOMORROW:
            case WeatherTypes.PERIOD_NEXT_FEW_DAYS:
            case WeatherTypes.PERIOD_MONDAY_FRIDAY:
            case WeatherTypes.PERIOD_BEGINNING_OF_THE_WEEK:
            case WeatherTypes.PERIOD_MONDAY:
            case WeatherTypes.PERIOD_TUESDAY:
            case WeatherTypes.PERIOD_WEDNESDAY:
            case WeatherTypes.PERIOD_THURSDAY:
            case WeatherTypes.PERIOD_FRIDAY:
            case WeatherTypes.PERIOD_SATURDAY:
            case WeatherTypes.PERIOD_SUNDAY:
            case WeatherTypes.PERIOD_WEEKEND:
               return true;
            default:
               return false;
         }
      }
      
      private function addDateToOrder(newDate:Date, index:int) : void
      {
         var i:int = 0;
         var newOrderObj:Object = new Object();
         newOrderObj["date"] = newDate;
         newOrderObj["listIndex"] = index;
         for(i = 0; i < this.mOrder.length; i++)
         {
            if(newDate < (this.mOrder[i]["date"] as Date))
            {
               break;
            }
         }
         this.mOrder.splice(i,0,newOrderObj);
      }
   }
}

