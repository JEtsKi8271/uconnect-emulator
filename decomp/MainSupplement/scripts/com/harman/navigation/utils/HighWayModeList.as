package com.harman.navigation.utils
{
   import com.harman.navigation.enums.AdditionalHighwayManeuverInfo;
   import com.harman.navigation.enums.PictogramType;
   import com.harman.navigation.global.NavigationPackage;
   
   public class HighWayModeList
   {
      
      private static const MANEUVER_ICON_TAG:String = "<MAN_ICON>";
      
      private var mList:Array = new Array();
      
      private var mDistance:int = 0;
      
      private var mTime:int = 0;
      
      private var mPageIndex:int = 0;
      
      public function HighWayModeList(list:Array)
      {
         super();
         this.mList = list;
      }
      
      public function get itemCount() : int
      {
         if(this.mList != null)
         {
            return this.mList.length;
         }
         return 0;
      }
      
      public function getExitNameForListIndex(index:int) : String
      {
         if(this.mList != null && index < this.mList.length && index >= 0)
         {
            return EisHelper.getValueOfType(String(this.mList[index]),"<EXT>");
         }
         return "";
      }
      
      public function getTollForListIndex(index:int) : String
      {
         return "";
      }
      
      public function getDistanceForListIndex(index:int) : int
      {
         if(this.mList != null && index < this.mList.length && index >= 0)
         {
            return int(EisHelper.getValueOfType(String(this.mList[index]),"<MND>"));
         }
         return 0;
      }
      
      public function getTimeForListIndex(index:int) : int
      {
         if(this.mList != null && index < this.mList.length && index >= 0)
         {
            return int(EisHelper.getValueOfType(String(this.mList[index]),"<TRT>"));
         }
         return 0;
      }
      
      public function getSAPAIconForListIndex(index:int) : Array
      {
         var ptg:String = null;
         var arryResult:Array = new Array();
         if(this.mList != null && index < this.mList.length && index >= 0)
         {
            ptg = EisHelper.getValueOfType(String(this.mList[index]),"<PTG>");
            if(ptg != "")
            {
               if(int(ptg) & PictogramType.TOILET)
               {
                  arryResult.push(2);
               }
               if(int(ptg) & PictogramType.RESTAURANT)
               {
                  arryResult.push(3);
               }
               if(int(ptg) & PictogramType.PETROL_STATION)
               {
                  arryResult.push(4);
               }
            }
         }
         return arryResult;
      }
      
      public function getTurnIconForListIndex(index:int) : int
      {
         var savMan:String = null;
         var maneuver:String = null;
         var direction:String = null;
         var man:int = 0;
         var art:String = null;
         if(this.mList != null && index < this.mList.length && index >= 0)
         {
            savMan = EisHelper.getValueOfType(String(this.mList[index]),MANEUVER_ICON_TAG);
            if(savMan != "")
            {
               return int(savMan);
            }
            maneuver = EisHelper.getValueOfType(String(this.mList[index]),"<MNT>");
            direction = EisHelper.getValueOfType(String(this.mList[index]),"<MNN>");
            if(maneuver != "")
            {
               man = 0;
               if(maneuver == "0" || EisHelper.getValueOfType(String(this.mList[index]),"<ART>") != "")
               {
                  art = EisHelper.getValueOfType(String(this.mList[index]),"<ART>");
                  switch(int(art))
                  {
                     case AdditionalHighwayManeuverInfo.ADDITIONAL_HIGHWAY_INFO_SA:
                        man = 102;
                        break;
                     case AdditionalHighwayManeuverInfo.ADDITIONAL_HIGHWAY_INFO_PA:
                        man = 101;
                        break;
                     case AdditionalHighwayManeuverInfo.ADDITIONAL_HIGHWAY_INFO_JCT:
                        man = 100;
                        break;
                     case AdditionalHighwayManeuverInfo.ADDITIONAL_HIGHWAY_INFO_IC:
                        man = 99;
                        break;
                     case AdditionalHighwayManeuverInfo.ADDITIONAL_HIGHWAY_INFO_SMART_IC:
                        man = 104;
                  }
               }
               else if(maneuver == "34")
               {
                  man = 103;
               }
               else
               {
                  man = int(NavigationPackage.peripheral.navigation.navVServices.hmiUtils.getManeuverIcon(int(maneuver),int(direction)));
               }
               this.mList[index] = String(this.mList[index]) + MANEUVER_ICON_TAG + man + "<*>";
               return man;
            }
            this.mList[index] = String(this.mList[index]) + MANEUVER_ICON_TAG + 0 + "<*>";
            return 0;
         }
         return 0;
      }
      
      public function getGeoForListIndex(index:int) : String
      {
         if(this.mList != null && index < this.mList.length && index >= 0)
         {
            return EisHelper.getValueOfType(String(this.mList[index]),"<GEO>");
         }
         return "";
      }
      
      public function getIDForListIndex(index:int) : String
      {
         if(this.mList != null && index < this.mList.length && index >= 0)
         {
            return EisHelper.getValueOfType(String(this.mList[index]),"<EXT_NNG>");
         }
         return "";
      }
      
      public function getItemForListIndex(index:int) : String
      {
         if(this.mList != null && index < this.mList.length && index >= 0)
         {
            return String(this.mList[index]);
         }
         return "";
      }
      
      public function setFacilityInfo(distance:int, time:int) : void
      {
         this.mDistance = distance;
         this.mTime = time;
      }
      
      public function get facilityDistance() : int
      {
         return this.mDistance;
      }
      
      public function get facilityTime() : int
      {
         return this.mTime;
      }
      
      public function incPageIndex() : Boolean
      {
         if(this.mPageIndex + 3 < this.itemCount)
         {
            ++this.mPageIndex;
            return true;
         }
         return false;
      }
      
      public function decPageIndex() : Boolean
      {
         if(this.mPageIndex > 0)
         {
            --this.mPageIndex;
            return true;
         }
         return false;
      }
      
      public function setPageIndex(idx:int) : void
      {
         if(idx < 0 || idx + 3 > this.itemCount)
         {
            return;
         }
         this.mPageIndex = idx;
      }
      
      public function get pageIndex() : int
      {
         return this.mPageIndex;
      }
   }
}

