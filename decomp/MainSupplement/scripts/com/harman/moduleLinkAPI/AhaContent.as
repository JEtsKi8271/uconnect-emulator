package com.harman.moduleLinkAPI
{
   public class AhaContent
   {
      
      private var contentId:int = 0;
      
      private var linePrimary:String = "";
      
      private var lineSecondary:String = "";
      
      private var lineTertiary:String = "";
      
      private var title:String = "";
      
      private var phone:String = "";
      
      private var likeUnselectUrl:String = "";
      
      private var likeselectUrl:String = "";
      
      private var dislikeUnselectUrl:String = "";
      
      private var dislikeselectUrl:String = "";
      
      private var contentImage:String = "";
      
      private var contentProviderImage:String = "";
      
      private var rating:Number = 0;
      
      private var numOfReviews:Number = 0;
      
      private var latitude:Number = 0;
      
      private var longitude:Number = 0;
      
      private var canPause:Boolean;
      
      private var canBack:Boolean;
      
      private var canNext:Boolean;
      
      private var canTimeShift:Boolean;
      
      private var canChange:Boolean;
      
      private var canLike:Boolean;
      
      private var canDislike:Boolean;
      
      private var canUnvote:Boolean;
      
      private var hideProgressBar:Boolean;
      
      public var liked:Boolean;
      
      public var disliked:Boolean;
      
      public var addToPreset:int;
      
      public function AhaContent(id:int, properties:Object)
      {
         var prop:String = null;
         super();
         this.contentId = id;
         for(prop in properties)
         {
            try
            {
               this[prop] = properties[prop];
               trace("*<HMIModule> AhaContent <adding> \'" + prop + "\' : " + properties[prop]);
            }
            catch(e:Error)
            {
               trace("*<HMIModule> AhaContent <ignore> \'" + prop + "\' not recognized!");
            }
         }
      }
      
      public function set lines(properties:Object) : void
      {
         this.linePrimary = properties.hasOwnProperty("currentContentInfo1") ? properties.currentContentInfo1 : "";
         this.lineSecondary = properties.hasOwnProperty("currentContentInfo2") ? properties.currentContentInfo2 : "";
         this.lineTertiary = properties.hasOwnProperty("currentContentInfo3") ? properties.currentContentInfo3 : "";
      }
      
      public function get ID() : int
      {
         return this.contentId;
      }
      
      public function get LINE_PRIMARY() : String
      {
         return this.linePrimary;
      }
      
      public function get LINE_SECONDARY() : String
      {
         return this.lineSecondary;
      }
      
      public function get LINE_TERTIARY() : String
      {
         return this.lineTertiary;
      }
      
      public function get TITLE() : String
      {
         return this.title;
      }
      
      public function get PHONE() : String
      {
         return this.phone;
      }
      
      public function get LIKE_URL() : String
      {
         return this.likeUnselectUrl;
      }
      
      public function get LIKE_URL_SEL() : String
      {
         return this.likeselectUrl;
      }
      
      public function get DISLIKE_URL() : String
      {
         return this.dislikeUnselectUrl;
      }
      
      public function get DISLIKE_URL_SEL() : String
      {
         return this.dislikeselectUrl;
      }
      
      public function get IMAGE() : String
      {
         return this.contentImage;
      }
      
      public function get PROVIDER_IMAGE() : String
      {
         return this.contentProviderImage;
      }
      
      public function get RATING() : Number
      {
         return this.rating;
      }
      
      public function get NUM_OF_REVIEWS() : Number
      {
         return this.numOfReviews;
      }
      
      public function get LAT() : Number
      {
         return this.latitude;
      }
      
      public function get LON() : Number
      {
         return this.longitude;
      }
      
      public function get HAS_PAUSE() : Boolean
      {
         return this.canPause;
      }
      
      public function get HAS_BACK() : Boolean
      {
         return this.canBack;
      }
      
      public function get HAS_NEXT() : Boolean
      {
         return this.canNext;
      }
      
      public function get HAS_TIME_SHIFT() : Boolean
      {
         return this.canTimeShift;
      }
      
      public function get HAS_DYNAMIC_CONTENT() : Boolean
      {
         return this.canChange;
      }
      
      public function get HAS_PROGRESS_BAR() : Boolean
      {
         return !this.hideProgressBar;
      }
      
      public function get CAN_LIKE() : Boolean
      {
         return this.canLike;
      }
      
      public function get CAN_DISLIKE() : Boolean
      {
         return this.canDislike;
      }
      
      public function get CAN_UNVOTE() : Boolean
      {
         return this.canUnvote;
      }
      
      public function get LIKED() : Boolean
      {
         return this.liked;
      }
      
      public function get DISLIKED() : Boolean
      {
         return this.disliked;
      }
      
      public function get ADD_TO_PRESET() : int
      {
         return this.addToPreset;
      }
   }
}

