package com.harman.navigation.global.vServices
{
   public class VServiceContainer
   {
      
      private var mHmiUtils:VServiceHmiUtils = new VServiceHmiUtils();
      
      private var mDirectionTracker:VServiceDirectionTracker = new VServiceDirectionTracker();
      
      private var mGenericPopup:VServicePopupGeneric = new VServicePopupGeneric();
      
      private var mSpellerGeneric:VServiceSpellerGeneric = new VServiceSpellerGeneric();
      
      private var mEventDispatcher:VServiceEventDispatcher = new VServiceEventDispatcher();
      
      private var mListOptionsPopup:VServiceListOptionsPopup = new VServiceListOptionsPopup();
      
      private var mScreenHelper:VServiceScreenHelper = new VServiceScreenHelper();
      
      private var mDistanceCalc:VServiceDistanceCalculator = new VServiceDistanceCalculator();
      
      private var mDistanceListCtrl:VServiceDistanceListController = new VServiceDistanceListController();
      
      private var mGlobalSettingsCtrl:VServiceGlobalSettings = new VServiceGlobalSettings();
      
      public function VServiceContainer()
      {
         super();
      }
      
      public function get spellerGeneric() : VServiceSpellerGeneric
      {
         return this.mSpellerGeneric;
      }
      
      public function get hmiUtils() : VServiceHmiUtils
      {
         return this.mHmiUtils;
      }
      
      public function get genericPopup() : VServicePopupGeneric
      {
         return this.mGenericPopup;
      }
      
      public function get directionTracker() : VServiceDirectionTracker
      {
         return this.mDirectionTracker;
      }
      
      public function get eventDispatcher() : VServiceEventDispatcher
      {
         return this.mEventDispatcher;
      }
      
      public function get listOptionsPopup() : VServiceListOptionsPopup
      {
         return this.mListOptionsPopup;
      }
      
      public function get screenHelper() : VServiceScreenHelper
      {
         return this.mScreenHelper;
      }
      
      public function get distanceCalculator() : VServiceDistanceCalculator
      {
         return this.mDistanceCalc;
      }
      
      public function get distanceListCtrl() : VServiceDistanceListController
      {
         return this.mDistanceListCtrl;
      }
      
      public function get globalSettingsCtrl() : VServiceGlobalSettings
      {
         return this.mGlobalSettingsCtrl;
      }
   }
}

