package com.nfuzion.moduleLinkAPI
{
   public interface IPhoneBook extends IModule
   {
      
      function initBt(param1:IBluetooth) : void;
      
      function addFavorite(param1:PhoneBookContact) : void;
      
      function get contactsCount() : Number;
      
      function contactsList(param1:uint) : Vector.<PhoneBookContact>;
      
      function contactStartCharactersAvailable() : Vector.<String>;
      
      function deleteFavorite(param1:PhoneBookContact) : void;
      
      function deleteFavoriteById(param1:uint) : void;
      
      function get favoritesCount() : Number;
      
      function get favoritesDbFull() : Boolean;
      
      function favoritesList(param1:uint) : Vector.<PhoneBookContact>;
      
      function indexFromStartCharacter(param1:String) : int;
      
      function requestAlphaJumpInformation() : void;
      
      function requestNextValidCharacters(param1:String) : void;
      
      function requestContactByName(param1:String, param2:String) : uint;
      
      function requestContactByNumber(param1:String) : uint;
      
      function requestContactsByRange(param1:uint, param2:uint, param3:String, param4:String) : uint;
      
      function requestContactDetails(param1:int) : void;
      
      function requestContactsCount() : void;
      
      function requestContactsList(param1:uint, param2:uint, param3:String, param4:String, param5:String) : uint;
      
      function requestFavoritesCount() : void;
      
      function replaceFavorite(param1:PhoneBookContact) : void;
      
      function requestFavoritesByRange(param1:uint, param2:uint) : uint;
      
      function requestPhoneBookReady() : void;
      
      function isPhoneBookReady() : Boolean;
      
      function get startIndex() : int;
      
      function set startIndex(param1:int) : void;
      
      function editSpecialNumber(param1:String, param2:String) : void;
      
      function get emergencyNumber() : String;
      
      function get towingAssistanceNumber() : String;
      
      function resetToDefault(param1:String) : void;
      
      function get phonebookSyncUpdateStatus() : Boolean;
      
      function refreshPhonebook() : void;
      
      function get nextSmartSpeller() : String;
      
      function get smartSpellerIndex() : int;
      
      function get smartSpellerCount() : int;
      
      function get phoneBookSyncStatus() : String;
      
      function set localLangEmeregencyString(param1:String) : void;
      
      function set localLangTowAssistString(param1:String) : void;
      
      function get multipleContactNumberPresent() : Boolean;
      
      function get multipleContactNumberInfo() : Object;
      
      function set multiNumberFromMessageFlag(param1:Boolean) : void;
      
      function get multiNumberFromMessageFlagGet() : Boolean;
      
      function get lastModePhonebookScreen() : String;
      
      function set lastModePhonebookScreen(param1:String) : void;
      
      function requestFilteredCount(param1:String) : void;
      
      function forceRequestContactsList(param1:uint, param2:uint, param3:String) : uint;
   }
}

