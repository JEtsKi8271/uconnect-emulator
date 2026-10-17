package com.harman.navigation.utils
{
   import com.harman.navigation.global.vServices.VServiceGlobalSettings;
   
   public class TurnListElement
   {
      
      private var mIconArray:Array = new Array();
      
      private var mTextArray:Array = new Array();
      
      private var turnElementArray:Object = {
         "<RSG>":"",
         "<MNT>":"",
         "<MNN>":"",
         "<STR>":"",
         "<MND>":"",
         "<GEO>":"",
         "<TRT>":"",
         "<IC>":""
      };
      
      public function TurnListElement()
      {
         super();
      }
      
      public function getValue(eisType:String) : String
      {
         return this.turnElementArray[eisType];
      }
      
      public function get streetnameTextOnly() : String
      {
         var additionalText:String = null;
         var cmpText:String = null;
         var positionOfAdditionalText:int = 0;
         var tmp:String = this.turnElementTextRaw;
         var pos:int = tmp.indexOf("%s");
         var index:int = 0;
         while(pos != -1 && this.mTextArray.length > index)
         {
            additionalText = " " + this.mTextArray[index] + " ";
            cmpText = " " + tmp + " ";
            positionOfAdditionalText = cmpText.indexOf(additionalText);
            if(positionOfAdditionalText == -1)
            {
               tmp = tmp.substring(0,pos) + this.mTextArray[index] + tmp.substr(pos + 2,tmp.length - pos);
            }
            else
            {
               tmp = tmp.substring(0,pos) + tmp.substr(pos + 2,tmp.length - pos);
            }
            pos = tmp.indexOf("%s");
            index++;
         }
         return tmp;
      }
      
      public function streetnameWithoutIcons(removeFirstXIcons:int) : String
      {
         var tmp:String = this.turnElementTextRaw;
         var pos:int = tmp.indexOf("%s");
         var index:int = 0;
         while(pos != -1 && this.mTextArray.length > index)
         {
            if(index >= removeFirstXIcons)
            {
               tmp = tmp.substring(0,pos) + this.mTextArray[index] + tmp.substr(pos + 2,tmp.length - pos);
            }
            else
            {
               tmp = tmp.substring(0,pos) + tmp.substr(pos + 2,tmp.length - pos);
            }
            pos = tmp.indexOf("%s");
            index++;
         }
         return tmp;
      }
      
      public function get streetIcon() : String
      {
         if(this.mIconArray.length > 0)
         {
            return String(this.mIconArray[0]);
         }
         return "";
      }
      
      public function toEIS() : String
      {
         var endSection:String = new String("<*>");
         var erg:String = new String();
         var i:int = 0;
         if(this.turnElementArray["<RSG>"] != "")
         {
            erg += "<RSG>" + this.turnElementArray["<RSG>"] + endSection;
         }
         if(this.turnElementArray["<MNT>"] != "")
         {
            erg += "<MNT>" + this.turnElementArray["<MNT>"] + endSection;
         }
         if(this.turnElementArray["<MNN>"] != "")
         {
            erg += "<MNN>" + this.turnElementArray["<MNN>"] + endSection;
         }
         if(this.turnElementArray["<STR>"] != "")
         {
            erg += "<STR>" + this.turnElementArray["<STR>"] + endSection;
         }
         i = 0;
         while(i < this.mIconArray.length && i < this.mTextArray.length)
         {
            erg += "<ICON>" + this.mIconArray[i] + endSection;
            erg += "<TXT>" + this.mTextArray[i] + endSection;
            i++;
         }
         if(this.turnElementArray["<MND>"] != "")
         {
            erg += "<MND>" + this.turnElementArray["<MND>"] + endSection;
         }
         if(this.turnElementArray["<GEO>"] != "")
         {
            erg += "<GEO>" + this.turnElementArray["<GEO>"] + endSection;
         }
         if(this.turnElementArray["<TRT>"] != "")
         {
            erg += "<TRT>" + this.turnElementArray["<TRT>"] + endSection;
         }
         if(this.turnElementArray["<IC>"] != "")
         {
            erg += "<IC>" + this.turnElementArray["<IC>"] + endSection;
         }
         return erg;
      }
      
      public function addEisString(eisString:String) : void
      {
         var eisType:String = null;
         var eisValue:String = null;
         var endSection:String = new String("<*>");
         while(eisString.length > 0 && eisString.indexOf(endSection) > -1)
         {
            eisType = eisString.substring(0,eisString.indexOf(">") + 1);
            eisValue = eisString.substring(eisString.indexOf(">") + 1,eisString.indexOf(endSection));
            if(eisType == "<ICON>")
            {
               this.mIconArray.push(eisValue);
            }
            else if(eisType == "<TXT>")
            {
               this.mTextArray.push(eisValue);
            }
            else
            {
               this.turnElementArray[eisType] = eisValue;
            }
            eisString = eisString.slice(eisString.indexOf(endSection) + 3,eisString.length + 1);
         }
      }
      
      public function isManeuverOffRoad() : Boolean
      {
         return this.turnElementArray["<MNT>"] == 6 || this.turnElementArray["<MNT>"] == 7;
      }
      
      private function get turnElementTextRaw() : String
      {
         var res:String = "";
         if(this.turnElementArray["<POI>"] != "" && this.turnElementArray["<POI>"] != null)
         {
            res = String(this.turnElementArray["<POI>"]);
         }
         else if(this.turnElementArray["<ITR>"] != "" && this.turnElementArray["<ITR>"] != null)
         {
            res += String(this.turnElementArray["<STR>"]) + " x " + String(this.turnElementArray["<ITR>"]);
         }
         else
         {
            switch(VServiceGlobalSettings.navMarketConfig)
            {
               case VServiceGlobalSettings.MARKET_EUROPE:
               case VServiceGlobalSettings.MARKET_ROW:
                  if(this.turnElementArray["<HNO>"] != "" && this.turnElementArray["<HNO>"] != null)
                  {
                     res = String(this.turnElementArray["<STR>"]) + " " + String(this.turnElementArray["<HNO>"]);
                  }
                  else
                  {
                     res += String(this.turnElementArray["<STR>"]);
                  }
                  break;
               case VServiceGlobalSettings.MARKET_NORTH_AMERICA:
               default:
                  if(this.turnElementArray["<HNO>"] != "" && this.turnElementArray["<HNO>"] != null)
                  {
                     res = String(this.turnElementArray["<HNO>"]) + " " + String(this.turnElementArray["<STR>"]);
                  }
                  else
                  {
                     res += String(this.turnElementArray["<STR>"]);
                  }
            }
         }
         return res;
      }
   }
}

