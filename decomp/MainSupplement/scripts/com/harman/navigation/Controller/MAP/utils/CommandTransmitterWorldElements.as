package com.harman.navigation.Controller.MAP.utils
{
   import com.harman.navigation.Controller.MAP.enums.MapSettingTypes;
   import com.harman.navigation.NavigationApi;
   import com.harman.navigation.NavigationEvent;
   import com.harman.navigation.NavigationImpl;
   import com.harman.navigation.NavigationNamespace;
   import com.harman.navigation.global.NavigationPackage;
   import com.nfuzion.framework.global.Framework;
   
   use namespace NavigationNamespace;
   
   public class CommandTransmitterWorldElements
   {
      
      private static var LAST_FUNCTION_HIDE:String = "";
      
      private static var LAST_FUNCTION_ZOOM:String = "";
      
      private static var LAST_FUNCTION_HIGHLIGHT:String = "";
      
      private static var LAST_FUNCTION_VISIBLE:String = "";
      
      private static var LAST_FUNCTION_SET_ITEM_VISIBILITIES:String = "";
      
      private static var LAST_FUNCTION_SET_TEMPORARY_ITEMS:String = "";
      
      private static var LAST_FUNCTION_ZOOM_VISIBLE:String = "";
      
      public function CommandTransmitterWorldElements()
      {
         super();
         NavigationApi.impl = NavigationImpl.create();
         NavigationApi.api.addEventListener(NavigationEvent.MAP_UPDATED_WORLD_ELEMENT_CMD,this.onWorldCommandUpdate,false,0,true);
      }
      
      public function sendWorldElements(weArray:Array) : void
      {
         var i:int = 0;
         switch(NavigationPackage.peripheral.navigation.navMapControl.mapConfiguration)
         {
            case MapConfiguration.MAP_ZOOM_TMC:
            case MapConfiguration.MAP_FULL:
            case MapConfiguration.MAP_MEDIA:
            case MapConfiguration.MAP_HALF_MAP:
            case MapConfiguration.UNDEFINED:
            case MapConfiguration.MAP_GARAGE:
               LAST_FUNCTION_HIDE = "";
               LAST_FUNCTION_ZOOM = "";
               LAST_FUNCTION_HIGHLIGHT = "";
               LAST_FUNCTION_VISIBLE = "";
               LAST_FUNCTION_SET_ITEM_VISIBILITIES = "";
               LAST_FUNCTION_SET_TEMPORARY_ITEMS = "";
               LAST_FUNCTION_ZOOM_VISIBLE = "";
         }
         if(weArray != null)
         {
            for(i = 0; i < weArray.length; i++)
            {
               if(Object(weArray[i])["WEF"] == MapSettingTypes.WORLD_ELEMENT_FUNCTION_ZOOM)
               {
                  LAST_FUNCTION_VISIBLE = "";
                  LAST_FUNCTION_ZOOM_VISIBLE = "";
               }
               if(this.checkIsSendingRequired(Object(weArray[i])))
               {
                  NavigationApi.api.mapSendWorldElementlCmd(Object(weArray[i])["WEF"],Object(weArray[i])["ITEMS"] as Array);
               }
            }
         }
         else
         {
            Framework.Trace("Nav.Map.CommandTransmitterWorldElements.sendWorldElements(null) !!!");
         }
      }
      
      private function checkIsSendingRequired(weFunction:Object) : Boolean
      {
         var newString:String = "";
         for(var i:int = 0; i < (weFunction["ITEMS"] as Array).length; i++)
         {
            newString += String((weFunction["ITEMS"] as Array)[i]);
         }
         switch(int(Object(weFunction)["WEF"]))
         {
            case MapSettingTypes.WORLD_ELEMENT_FUNCTION_HIDE:
               if(newString == LAST_FUNCTION_HIDE)
               {
                  return false;
               }
               LAST_FUNCTION_HIDE = newString;
               break;
            case MapSettingTypes.WORLD_ELEMENT_FUNCTION_ZOOM:
               if(newString == LAST_FUNCTION_ZOOM)
               {
                  return false;
               }
               LAST_FUNCTION_ZOOM = newString;
               break;
            case MapSettingTypes.WORLD_ELEMENT_FUNCTION_HIGHLIGHT:
               if(newString == LAST_FUNCTION_HIGHLIGHT)
               {
                  return false;
               }
               LAST_FUNCTION_HIGHLIGHT = newString;
               break;
            case MapSettingTypes.WORLD_ELEMENT_FUNCTION_VISIBLE:
               if(newString == LAST_FUNCTION_VISIBLE)
               {
                  return false;
               }
               LAST_FUNCTION_VISIBLE = newString;
               break;
            case MapSettingTypes.WORLD_ELEMENT_FUNCTION_SET_ITEM_VISIBILITIES:
               if(newString == LAST_FUNCTION_SET_ITEM_VISIBILITIES)
               {
                  return false;
               }
               LAST_FUNCTION_SET_ITEM_VISIBILITIES = newString;
               break;
            case MapSettingTypes.WORLD_ELEMENT_FUNCTION_SET_TEMPORARY_ITEMS:
               if(newString == LAST_FUNCTION_SET_TEMPORARY_ITEMS)
               {
                  return false;
               }
               LAST_FUNCTION_SET_TEMPORARY_ITEMS = newString;
               break;
            case MapSettingTypes.WORLD_ELEMENT_FUNCTION_ZOOM | MapSettingTypes.WORLD_ELEMENT_FUNCTION_VISIBLE:
               if(newString == LAST_FUNCTION_ZOOM_VISIBLE)
               {
                  return false;
               }
               LAST_FUNCTION_ZOOM_VISIBLE = newString;
         }
         return true;
      }
      
      private function onWorldCommandUpdate(e:NavigationEvent) : void
      {
      }
   }
}

