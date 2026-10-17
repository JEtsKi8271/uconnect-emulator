package com.harman.types
{
   import flash.utils.describeType;
   import flash.utils.getQualifiedClassName;
   
   public class Enum
   {
      
      private static var _pendingDb:Object = {};
      
      private static var _enumDb:Object = {};
      
      private var _name:String = null;
      
      private var _index:int = -1;
      
      public function Enum()
      {
         super();
         var typeName:String = getQualifiedClassName(this);
         if(_enumDb[typeName] != null)
         {
            throw new Error("Enum constants can only be constructed as static consts " + "in their own enum class " + "(bad type=\'" + typeName + "\')");
         }
         var constants:Array = _pendingDb[typeName];
         if(constants == null)
         {
            _pendingDb[typeName] = constants = [];
         }
         this._index = constants.length;
         constants.push(this);
      }
      
      public static function GetConstants(i_type:Class) : Array
      {
         var constants:EnumConstants = _enumDb[getQualifiedClassName(i_type)];
         if(constants == null)
         {
            return null;
         }
         return constants.ByIndex.slice();
      }
      
      public static function ParseConstant(i_type:Class, i_constantName:String, i_caseSensitive:Boolean = false) : Enum
      {
         var constants:EnumConstants = _enumDb[getQualifiedClassName(i_type)];
         if(constants == null)
         {
            return null;
         }
         var constant:Enum = constants.ByName[i_constantName.toLowerCase()];
         if(i_caseSensitive && constant != null && i_constantName != constant.Name)
         {
            return null;
         }
         return constant;
      }
      
      protected static function initEnum(i_type:Class) : void
      {
         var constant:XML = null;
         var enumConstant:Enum = null;
         var enumConstantType:* = undefined;
         var typeName:String = getQualifiedClassName(i_type);
         if(_enumDb[typeName] != null)
         {
            throw new Error("Can\'t initialize enum twice (type=\'" + typeName + "\')");
         }
         var constants:Array = _pendingDb[typeName];
         if(constants == null)
         {
            throw new Error("Can\'t have an enum without any constants (type=\'" + typeName + "\')");
         }
         var type:XML = describeType(i_type);
         for each(constant in type.constant)
         {
            enumConstant = i_type[constant.@name];
            enumConstantType = Object(enumConstant).constructor;
            if(enumConstantType != i_type)
            {
               throw new Error("Constant type \'" + enumConstantType + "\' " + "does not match its enum class \'" + i_type + "\'");
            }
            enumConstant._name = constant.@name;
         }
         _pendingDb[typeName] = null;
         _enumDb[typeName] = new EnumConstants(constants);
      }
      
      public function get Name() : String
      {
         return this._name;
      }
      
      public function get Index() : int
      {
         return this._index;
      }
      
      public function toString() : String
      {
         return this.Name;
      }
   }
}

import com.harman.types.Enum;

class EnumConstants
{
   
   public var ByIndex:Array;
   
   public var ByName:Object = {};
   
   public function EnumConstants(i_byIndex:Array)
   {
      var enumConstant:Enum = null;
      super();
      this.ByIndex = i_byIndex;
      for(var i:int = 0; i < this.ByIndex.length; i++)
      {
         enumConstant = this.ByIndex[i];
         this.ByName[enumConstant.Name.toLowerCase()] = enumConstant;
      }
   }
}
