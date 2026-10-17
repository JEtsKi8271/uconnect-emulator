package com.harman.navigation.liveServices
{
   import com.harman.navigation.Controller.LiveServices.AuthenticationTypes;
   
   public class SimulationDataProvider
   {
      
      public function SimulationDataProvider()
      {
         super();
      }
      
      public static function provideSimulationData() : Object
      {
         var list:Array = new Array();
         list.push("TT.LOCALSEARCH");
         list.push("TT.TEC");
         list.push("TT.WEA");
         list.push("TT.SAA");
         list.push("TT.SAAFL");
         var authenticationStatus:Object = new Object();
         authenticationStatus["authenticationStatus"] = AuthenticationTypes.UC_AUTH_AUTHORIZED;
         authenticationStatus["sessionToken"] = "QWERTY-1234567890";
         authenticationStatus["subscriptionList"] = list;
         authenticationStatus["connectivityStatus"] = AuthenticationTypes.UC_CONNECTED_WIFI;
         return authenticationStatus;
      }
      
      public static function weatherSimulationData() : Object
      {
         var result:Object = new Object();
         var weatherList:Array = new Array();
         var location:Object = {
            "latitude":"43.87313",
            "longitude":"-93.13634"
         };
         var weatherReportList:Array = new Array();
         var weatherDefinition1:Object = {"period":35};
         var weatherReport1:Object = {
            "reportType":1,
            "weatherDefinition":weatherDefinition1
         };
         weatherReportList.push(weatherReport1);
         var subTableType2_1:Object = {
            "subTableType":1,
            "subTableValue":0
         };
         var subTableType2_2:Object = {
            "subTableType":21,
            "subTableValue":7
         };
         var weatherDescription2:Array = new Array(subTableType2_1,subTableType2_2);
         var date2:Object = {
            "year":2014,
            "month":8,
            "day":1
         };
         var statistics2:Object = {
            "temperature":21,
            "maxTemperature":25,
            "minTemperature":18,
            "windDirection":5,
            "relativeHumidity":33,
            "windSpeed":55,
            "cloudCover":8,
            "rainfallTotal":75,
            "uvIndex":0
         };
         var weatherDefinition2:Object = {
            "period":5,
            "weatherDescription":weatherDescription2,
            "date":date2,
            "statistics":statistics2
         };
         var weatherReport2:Object = {
            "reportType":2,
            "weatherDefinition":weatherDefinition2
         };
         weatherReportList.push(weatherReport2);
         var subTableType3_1:Object = {
            "subTableType":1,
            "subTableValue":0
         };
         var subTableType3_2:Object = {
            "subTableType":21,
            "subTableValue":90
         };
         var subTableType3_3:Object = {
            "subTableType":5,
            "subTableValue":6
         };
         var weatherDescription3:Array = new Array(subTableType3_1,subTableType3_2,subTableType3_3);
         var date3:Object = {
            "year":2014,
            "month":8,
            "day":2
         };
         var statistics3:Object = {
            "maxTemperature":31,
            "minTemperature":11,
            "windDirection":5,
            "uvIndex":1,
            "relativeHumidity":65,
            "windSpeed":26,
            "cloudCover":3,
            "rainfallTotal":5
         };
         var weatherDefinition3:Object = {
            "period":5,
            "weatherDescription":weatherDescription3,
            "date":date3,
            "statistics":statistics3
         };
         var weatherReport3:Object = {
            "reportType":2,
            "weatherDefinition":weatherDefinition3
         };
         weatherReportList.push(weatherReport3);
         var weatherItem1:Object = {
            "Id":10000,
            "geographicalSignificance":6,
            "location":location,
            "weatherReport":weatherReportList
         };
         var subTableType4_1:Object = {
            "subTableType":1,
            "subTableValue":0
         };
         var subTableType4_2:Object = {
            "subTableType":21,
            "subTableValue":28
         };
         var subTableType4_3:Object = {
            "subTableType":10,
            "subTableValue":9
         };
         var weatherDescription4:Array = new Array(subTableType4_1,subTableType4_2,subTableType4_3);
         var date4:Object = {
            "year":2014,
            "month":8,
            "day":3
         };
         var statistics4:Object = {
            "maxTemperature":16,
            "minTemperature":15,
            "windDirection":5,
            "uvIndex":11,
            "relativeHumidity":65,
            "windSpeed":7,
            "cloudCover":7,
            "rainfallTotal":12
         };
         var weatherDefinition4:Object = {
            "period":5,
            "weatherDescription":weatherDescription4,
            "date":date4,
            "statistics":statistics4
         };
         var weatherReport4:Object = {
            "reportType":2,
            "weatherDefinition":weatherDefinition4
         };
         weatherReportList.push(weatherReport4);
         var subTableType5_1:Object = {
            "subTableType":1,
            "subTableValue":6
         };
         var subTableType5_2:Object = {
            "subTableType":21,
            "subTableValue":56
         };
         var subTableType5_3:Object = {
            "subTableType":1,
            "subTableValue":11
         };
         var weatherDescription5:Array = new Array(subTableType5_1,subTableType5_2,subTableType5_3);
         var date5:Object = {
            "year":2014,
            "month":8,
            "day":4
         };
         var statistics5:Object = {
            "maxTemperature":42,
            "minTemperature":32,
            "windDirection":5,
            "uvIndex":12,
            "relativeHumidity":65,
            "windSpeed":100,
            "cloudCover":5,
            "rainfallTotal":45
         };
         var weatherDefinition5:Object = {
            "period":5,
            "weatherDescription":weatherDescription5,
            "date":date5,
            "statistics":statistics5
         };
         var weatherReport5:Object = {
            "reportType":2,
            "weatherDefinition":weatherDefinition5
         };
         weatherReportList.push(weatherReport5);
         weatherList.push(weatherItem1);
         result["weatherList"] = weatherList;
         return result;
      }
      
      public static function localSearchSimulationData() : Object
      {
         var result:Object = new Object();
         var placesArray:Array = new Array();
         var place1:Object = new Object();
         place1["id"] = 1310061613;
         place1["name"] = "Sunset Motor Inn";
         place1["latitude"] = "48.37484";
         place1["longitude"] = "10.046031";
         place1["distance"] = "5.361765299123138";
         place1["phone"] = "+1 603 2988721";
         place1["city"] = "West Lebanon";
         place1["street"] = "N Main St";
         place1["province"] = "New Hampshire";
         place1["houseNumber"] = "123";
         place1["zipcode"] = "03784";
         place1["formattedAddress"] = "305 N Main St, West Lebanon, 03784, United States";
         place1["country"] = "United States";
         place1["website"] = "http://places.tomtom.com/en_us/detail/sunset-motor-inn/west-lebanon/291179478440981179";
         var place2:Object = new Object();
         place2["id"] = 1310061611;
         place2["name"] = "Harman";
         place2["latitude"] = "48.419934";
         place2["longitude"] = "10.037568";
         place2["phone"] = "+1 156 2988721";
         place2["distance"] = "6.361765299123138";
         place2["city"] = "Farmington Hills";
         place2["street"] = "W 12 Mile Rd";
         place2["province"] = "Michigan";
         place2["houseNumber"] = "39001";
         place2["zipcode"] = "48168";
         place2["formattedAddress"] = "39001, W 12 Mile Rd, Farmington Hills, 48168, United States";
         place2["country"] = "United States";
         place2["website"] = "http://places.tomtom.com/en_us/detail/sunset-motor-inn/west-lebanon/291179478440981179";
         var place3:Object = new Object();
         place3["id"] = 1310061612;
         place3["name"] = "Panera Bread";
         place3["latitude"] = "48.412278";
         place3["longitude"] = "9.921905";
         place3["distance"] = "9.361765299123138";
         place3["phone"] = "+1 248 1231231234";
         place3["city"] = "Farmington Hills";
         place3["street"] = "W 12 Mile Rd";
         place3["province"] = "Michigan";
         place3["houseNumber"] = "39001";
         place3["zipcode"] = "48168";
         place3["formattedAddress"] = "39001, W 12 Mile Rd, Farmington Hills, 48168, United States";
         place3["country"] = "United States";
         place3["website"] = "http://places.tomtom.com/en_us/detail/sunset-motor-inn/west-lebanon/291179478440981179";
         var place4:Object = new Object();
         place4["id"] = 1310061614;
         place4["name"] = "Zanera Bread";
         place4["latitude"] = "48.412278";
         place4["longitude"] = "9.921905";
         place4["distance"] = "8.361765299123138";
         place4["phone"] = "+1 248 1231231234";
         place4["city"] = "Farmington Hills";
         place4["street"] = "W 12 Mile Rd";
         place4["province"] = "Michigan";
         place4["houseNumber"] = "39001";
         place4["zipcode"] = "48168";
         place4["formattedAddress"] = "39001, W 12 Mile Rd, Farmington Hills, 48168, United States";
         place4["country"] = "United States";
         place4["website"] = "http://places.tomtom.com/en_us/detail/sunset-motor-inn/west-lebanon/291179478440981179";
         var place5:Object = new Object();
         place5["id"] = 1310061615;
         place5["name"] = "Asia like";
         place5["latitude"] = "48.412278";
         place5["longitude"] = "9.921905";
         place5["distance"] = "8.361765299123138";
         place5["phone"] = "+1 248 1231231234";
         place5["city"] = "Farmington Hills";
         place5["street"] = "W 12 Mile Rd";
         place5["province"] = "Michigan";
         place5["houseNumber"] = "39001";
         place5["zipcode"] = "48168";
         place5["formattedAddress"] = "39001, W 12 Mile Rd, Farmington Hills, 48168, United States";
         place5["country"] = "United States";
         place5["website"] = "http://places.tomtom.com/en_us/detail/sunset-motor-inn/west-lebanon/291179478440981179";
         var place6:Object = new Object();
         place6["id"] = 1310061616;
         place6["name"] = "Ambassador";
         place6["latitude"] = "48.412278";
         place6["longitude"] = "9.921905";
         place6["distance"] = "8.361765299123138";
         place6["phone"] = "+1 248 1231231234";
         place6["city"] = "Farmington Hills";
         place6["street"] = "W 12 Mile Rd";
         place6["province"] = "Michigan";
         place6["houseNumber"] = "39001";
         place6["zipcode"] = "48168";
         place6["formattedAddress"] = "39001, W 12 Mile Rd, Farmington Hills, 48168, United States";
         place6["country"] = "United States";
         place6["website"] = "http://places.tomtom.com/en_us/detail/sunset-motor-inn/west-lebanon/291179478440981179";
         var place7:Object = new Object();
         place7["id"] = 1310061617;
         place7["name"] = "amdassador";
         place7["latitude"] = "48.412278";
         place7["longitude"] = "9.921905";
         place7["distance"] = "8.361765299123138";
         place7["phone"] = "+1 248 1231231234";
         place7["city"] = "Farmington Hills";
         place7["street"] = "W 12 Mile Rd";
         place7["province"] = "Michigan";
         place7["houseNumber"] = "39001";
         place7["zipcode"] = "48168";
         place7["formattedAddress"] = "39001, W 12 Mile Rd, Farmington Hills, 48168, United States";
         place7["country"] = "United States";
         place7["website"] = "http://places.tomtom.com/en_us/detail/sunset-motor-inn/west-lebanon/291179478440981179";
         var place8:Object = new Object();
         place8["id"] = 1310061618;
         place8["name"] = "amcassador";
         place8["latitude"] = "48.412278";
         place8["longitude"] = "9.921905";
         place8["distance"] = "8.361765299123138";
         place8["phone"] = "+1 248 1231231234";
         place8["city"] = "Farmington Hills";
         place8["street"] = "W 12 Mile Rd";
         place8["province"] = "Michigan";
         place8["houseNumber"] = "39001";
         place8["zipcode"] = "48168";
         place8["formattedAddress"] = "39001, W 12 Mile Rd, Farmington Hills, 48168, United States";
         place8["country"] = "United States";
         place8["website"] = "http://places.tomtom.com/en_us/detail/sunset-motor-inn/west-lebanon/291179478440981179";
         var place9:Object = new Object();
         place9["id"] = 1310061619;
         place9["name"] = "Asia like";
         place9["latitude"] = "48.412278";
         place9["longitude"] = "9.921905";
         place9["distance"] = "8.361765299123138";
         place9["phone"] = "+1 248 1231231234";
         place9["city"] = "Farmington Hills";
         place9["street"] = "W 12 Mile Rd";
         place9["province"] = "Michigan";
         place9["houseNumber"] = "39001";
         place9["zipcode"] = "48168";
         place9["formattedAddress"] = "39001, W 12 Mile Rd, Farmington Hills, 48168, United States";
         place9["country"] = "United States";
         place9["website"] = "http://places.tomtom.com/en_us/detail/sunset-motor-inn/west-lebanon/291179478440981179";
         var place10:Object = new Object();
         place10["id"] = 1310061620;
         place10["name"] = "Aaea";
         place10["latitude"] = "48.412278";
         place10["longitude"] = "9.921905";
         place10["distance"] = "8.361765299123138";
         place10["phone"] = "+1 248 1231231234";
         place10["city"] = "Farmington Hills";
         place10["street"] = "W 12 Mile Rd";
         place10["province"] = "Michigan";
         place10["houseNumber"] = "39001";
         place10["zipcode"] = "48168";
         place10["formattedAddress"] = "39001, W 12 Mile Rd, Farmington Hills, 48168, United States";
         place10["country"] = "United States";
         place10["website"] = "http://places.tomtom.com/en_us/detail/sunset-motor-inn/west-lebanon/291179478440981179";
         var place11:Object = new Object();
         place11["id"] = 1310061621;
         place11["name"] = "Aäa";
         place11["latitude"] = "48.412278";
         place11["longitude"] = "9.921905";
         place11["distance"] = "8.361765299123138";
         place11["phone"] = "+1 248 1231231234";
         place11["city"] = "Farmington Hills";
         place11["street"] = "W 12 Mile Rd";
         place11["province"] = "Michigan";
         place11["houseNumber"] = "39001";
         place11["zipcode"] = "48168";
         place11["formattedAddress"] = "39001, W 12 Mile Rd, Farmington Hills, 48168, United States";
         place11["country"] = "United States";
         place11["website"] = "http://places.tomtom.com/en_us/detail/sunset-motor-inn/west-lebanon/291179478440981179";
         var place12:Object = new Object();
         place12["id"] = 1310061622;
         place12["name"] = "Aåa";
         place12["latitude"] = "48.412278";
         place12["longitude"] = "9.921905";
         place12["distance"] = "8.361765299123138";
         place12["phone"] = "+1 248 1231231234";
         place12["city"] = "Farmington Hills";
         place12["street"] = "W 12 Mile Rd";
         place12["province"] = "Michigan";
         place12["houseNumber"] = "39001";
         place12["zipcode"] = "48168";
         place12["formattedAddress"] = "39001, W 12 Mile Rd, Farmington Hills, 48168, United States";
         place12["country"] = "United States";
         place12["website"] = "http://places.tomtom.com/en_us/detail/sunset-motor-inn/west-lebanon/291179478440981179";
         var place13:Object = new Object();
         place13["id"] = 1310061623;
         place13["name"] = "Aæa";
         place13["latitude"] = "48.412278";
         place13["longitude"] = "9.921905";
         place13["distance"] = "8.361765299123138";
         place13["phone"] = "+1 248 1231231234";
         place13["city"] = "Farmington Hills";
         place13["street"] = "W 12 Mile Rd";
         place13["province"] = "Michigan";
         place13["houseNumber"] = "39001";
         place13["zipcode"] = "48168";
         place13["formattedAddress"] = "39001, W 12 Mile Rd, Farmington Hills, 48168, United States";
         place13["country"] = "United States";
         place13["website"] = "http://places.tomtom.com/en_us/detail/sunset-motor-inn/west-lebanon/291179478440981179";
         var place14:Object = new Object();
         place14["id"] = 1310061624;
         place14["name"] = "Aza";
         place14["latitude"] = "48.412278";
         place14["longitude"] = "9.921905";
         place14["distance"] = "8.361765299123138";
         place14["phone"] = "+1 248 1231231234";
         place14["city"] = "Farmington Hills";
         place14["street"] = "W 12 Mile Rd";
         place14["province"] = "Michigan";
         place14["houseNumber"] = "39001";
         place14["zipcode"] = "48168";
         place14["formattedAddress"] = "39001, W 12 Mile Rd, Farmington Hills, 48168, United States";
         place14["country"] = "United States";
         place14["website"] = "http://places.tomtom.com/en_us/detail/sunset-motor-inn/west-lebanon/291179478440981179";
         var place15:Object = new Object();
         place15["id"] = 1310061625;
         place15["name"] = "Aüa";
         place15["latitude"] = "48.412278";
         place15["longitude"] = "9.921905";
         place15["distance"] = "8.361765299123138";
         place15["phone"] = "+1 248 1231231234";
         place15["city"] = "Farmington Hills";
         place15["street"] = "W 12 Mile Rd";
         place15["province"] = "Michigan";
         place15["houseNumber"] = "39001";
         place15["zipcode"] = "48168";
         place15["formattedAddress"] = "39001, W 12 Mile Rd, Farmington Hills, 48168, United States";
         place15["country"] = "United States";
         place15["website"] = "http://places.tomtom.com/en_us/detail/sunset-motor-inn/west-lebanon/291179478440981179";
         var place16:Object = new Object();
         place16["id"] = 1310061626;
         place16["name"] = "123";
         place16["latitude"] = "48.412278";
         place16["longitude"] = "9.921905";
         place16["distance"] = "8.361765299123138";
         place16["phone"] = "+1 248 1231231234";
         place16["city"] = "Farmington Hills";
         place16["street"] = "W 12 Mile Rd";
         place16["province"] = "Michigan";
         place16["houseNumber"] = "39001";
         place16["zipcode"] = "48168";
         place16["formattedAddress"] = "39001, W 12 Mile Rd, Farmington Hills, 48168, United States";
         place16["country"] = "United States";
         place16["website"] = "http://places.tomtom.com/en_us/detail/sunset-motor-inn/west-lebanon/291179478440981179";
         var place17:Object = new Object();
         place17["id"] = 1310061627;
         place17["name"] = "321";
         place17["latitude"] = "48.412278";
         place17["longitude"] = "9.921905";
         place17["distance"] = "8.361765299123138";
         place17["phone"] = "+1 248 1231231234";
         place17["city"] = "Farmington Hills";
         place17["street"] = "W 12 Mile Rd";
         place17["province"] = "Michigan";
         place17["houseNumber"] = "39001";
         place17["zipcode"] = "48168";
         place17["formattedAddress"] = "39001, W 12 Mile Rd, Farmington Hills, 48168, United States";
         place17["country"] = "United States";
         place17["website"] = "http://places.tomtom.com/en_us/detail/sunset-motor-inn/west-lebanon/291179478440981179";
         placesArray.push(place1);
         placesArray.push(place2);
         placesArray.push(place3);
         placesArray.push(place4);
         placesArray.push(place5);
         placesArray.push(place6);
         placesArray.push(place7);
         placesArray.push(place8);
         placesArray.push(place9);
         placesArray.push(place10);
         placesArray.push(place11);
         placesArray.push(place12);
         placesArray.push(place13);
         placesArray.push(place14);
         placesArray.push(place15);
         placesArray.push(place16);
         placesArray.push(place17);
         result["places"] = placesArray;
         return result;
      }
   }
}

