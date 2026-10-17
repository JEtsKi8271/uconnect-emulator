package com.harman.moduleLinkAPI
{
   public class ProductVariantID
   {
      
      public var VARIANT_DAB:String = "";
      
      public var VARIANT_ECELL:String = "";
      
      public var VARIANT_HWTYPE:String = "";
      
      public var VARIANT_MARKET:String = "";
      
      public var VARIANT_MODEL:String = "";
      
      public var VARIANT_MODELYEAR:String = "";
      
      public var VARIANT_PRODUCT:String = "";
      
      public var VARIANT_REVISION:String = "";
      
      public var VARIANT_SDARS:String = "";
      
      public var VARIANT_TMCPRO:String = "";
      
      public function ProductVariantID()
      {
         super();
      }
      
      public function copyProductVariantID(value:Object) : ProductVariantID
      {
         this.VARIANT_DAB = value.VARIANT_DAB;
         this.VARIANT_ECELL = value.VARIANT_ECELL;
         this.VARIANT_HWTYPE = value.VARIANT_HWTYPE;
         this.VARIANT_MARKET = value.VARIANT_MARKET;
         this.VARIANT_MODEL = value.VARIANT_MODEL;
         this.VARIANT_MODELYEAR = value.VARIANT_MODELYEAR;
         this.VARIANT_PRODUCT = value.VARIANT_PRODUCT;
         this.VARIANT_REVISION = value.VARIANT_REVISION;
         this.VARIANT_SDARS = value.VARIANT_SDARS;
         this.VARIANT_TMCPRO = value.VARIANT_TMCPRO;
         return this;
      }
   }
}

