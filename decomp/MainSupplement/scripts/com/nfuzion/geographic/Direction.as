package com.nfuzion.geographic
{
   public class Direction
   {
      
      private var mDegrees:Number;
      
      public function Direction(direction:Direction = null)
      {
         super();
         if(direction != null)
         {
            this.mDegrees = direction.degrees;
         }
         else
         {
            this.mDegrees = 0;
         }
      }
      
      public function set degrees(degrees:Number) : void
      {
         var extra:int = 0;
         if(degrees > int.MAX_VALUE || degrees < int.MIN_VALUE)
         {
            trace("Value is too large or too small.");
            this.mDegrees = 0;
         }
         else
         {
            extra = degrees;
            extra /= 360;
            extra *= 360;
            degrees -= extra;
            if(degrees > 360)
            {
               degrees -= 360;
            }
            if(degrees < 0)
            {
               degrees += 360;
            }
            this.mDegrees = degrees;
         }
      }
      
      public function get degrees() : Number
      {
         return this.mDegrees;
      }
      
      public function set cardinal(cardinal:String) : void
      {
         switch(cardinal.toUpperCase())
         {
            case "N":
            case "NORTH":
               this.mDegrees = 0;
               break;
            case "E":
            case "EAST":
               this.mDegrees = 90;
               break;
            case "S":
            case "SOUTH":
               this.mDegrees = 180;
               break;
            case "W":
            case "WEST":
               this.mDegrees = 270;
               break;
            default:
               this.mDegrees = 0;
               trace("Unrecognized cardinale direction.");
         }
      }
      
      public function get cardinal() : String
      {
         var direction:String = "";
         if(this.mDegrees >= 315 && this.mDegrees <= 360 || this.mDegrees >= 0 && this.mDegrees <= 45)
         {
            direction = "north";
         }
         else if(this.mDegrees > 45 && this.mDegrees < 135)
         {
            direction = "east";
         }
         else if(this.mDegrees >= 135 && this.mDegrees <= 225)
         {
            direction = "south";
         }
         else if(this.mDegrees > 225 && this.mDegrees < 315)
         {
            direction = "west";
         }
         return direction;
      }
      
      public function get cardinalAbbreviation() : String
      {
         var direction:String = null;
         switch(this.ordinal)
         {
            case "north":
               direction = "N";
               break;
            case "east":
               direction = "E";
               break;
            case "south":
               direction = "S";
               break;
            case "west":
               direction = "W";
               break;
            default:
               direction = "";
         }
         return direction;
      }
      
      public function set ordinal(ordinal:String) : void
      {
         switch(ordinal.toUpperCase())
         {
            case "N":
            case "NORTH":
               this.mDegrees = 0;
               break;
            case "NE":
            case "NORTHEAST":
               this.mDegrees = 45;
               break;
            case "E":
            case "EAST":
               this.mDegrees = 90;
               break;
            case "SE":
            case "SOUTHEAST":
               this.mDegrees = 135;
               break;
            case "S":
            case "SOUTH":
               this.mDegrees = 180;
               break;
            case "SW":
            case "SOUTHWEST":
               this.mDegrees = 225;
               break;
            case "W":
            case "WEST":
               this.mDegrees = 270;
               break;
            case "NW":
            case "NORTHWEST":
               this.mDegrees = 315;
               break;
            default:
               trace("Unrecognized ordinal direction.");
         }
      }
      
      public function get ordinal() : String
      {
         var direction:String = "";
         if(this.mDegrees >= 337.5 && this.mDegrees <= 360 || this.mDegrees >= 0 && this.mDegrees <= 22.5)
         {
            direction = "north";
         }
         else if(this.mDegrees > 22.5 && this.mDegrees < 67.5)
         {
            direction = "northeast";
         }
         else if(this.mDegrees >= 67.5 && this.mDegrees <= 112.5)
         {
            direction = "east";
         }
         else if(this.mDegrees > 112.5 && this.mDegrees < 157.5)
         {
            direction = "southeast";
         }
         else if(this.mDegrees >= 157.5 && this.mDegrees <= 202.5)
         {
            direction = "south";
         }
         else if(this.mDegrees > 202.5 && this.mDegrees < 247.5)
         {
            direction = "southwest";
         }
         else if(this.mDegrees >= 247.5 && this.mDegrees <= 292.5)
         {
            direction = "west";
         }
         else if(this.mDegrees > 292.5 && this.mDegrees < 337.5)
         {
            direction = "northwest";
         }
         return direction;
      }
      
      public function get ordinalAbbreviation() : String
      {
         var direction:String = null;
         switch(this.ordinal)
         {
            case "north":
               direction = "N";
               break;
            case "northeast":
               direction = "NE";
               break;
            case "east":
               direction = "E";
               break;
            case "southeast":
               direction = "SE";
               break;
            case "south":
               direction = "S";
               break;
            case "southwest":
               direction = "SW";
               break;
            case "west":
               direction = "W";
               break;
            case "northwest":
               direction = "NW";
               break;
            default:
               direction = "";
         }
         return direction;
      }
   }
}

