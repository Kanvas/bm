package com.kvs.utils
{
	public class MathUtil
	{
		public function MathUtil()
		{
	
		}
		
		public static function angleToRadian(angle:Number):Number
		{
			return angle * Math.PI / 180;
		}
		
		public static function radianToAngle(radian:Number):Number
		{
			return radian * 180 / Math.PI;
		}
		
		public static function modRotation(value:Number):Number
		{
			value = value % 360;
			if (value < 0) value += 360;
			return value;
		}
		
		/**
		 */		
		public static function ifOddNumber(value:uint):Boolean
		{
			return !Boolean((value % 2));
		}
		
		/**
		 */		
		public static function numChange(value:String, from:uint, to:uint):String
		{
			var num:Number = parseInt(value, from); 
			return num.toString(to);
		}
		
		/**
		 * 按照小数点的位数四舍五入
		 */		
		public static function round(value:Number, length:uint):String
		{
			var factor:Number = 1;
			for (var i:uint = 0; i < length; i ++)
			{
				factor *= 10;
			}
			
			var result:Number = Math.round(value * factor) / factor;
			var integer:String = String(result).split('.')[0];
			var decimal:String = String(result).split('.')[1];
			
			if (decimal && decimal.length < length)
			{
				for (i = 0; i < length - decimal.length; i ++)
					decimal = decimal + '0';
				
				return integer + '.' + decimal;
			}
			else
			{
				return result.toString();
			}
		}
		
		/**
		 * 判断2个数是否相等，
		 * 
		 * @param value1
		 * @param value2
		 * @param accuracy 精度
		 * @return 
		 * 
		 */
		public static function equals(value1:Number, value2:Number, accuracy:int = 10):Boolean
		{
			var factor:Number = Math.pow(10, accuracy);
			return Math.floor(value1 * factor) == Math.floor(value2 * factor);
		}
		
		/**
		 * 按照保留小数点的位数向上取整
		 */		
	    public static function ceil(value:Number, length:uint):Number
		{
			var factor:Number = 1;
			for (var i:uint = 0; i < length; i ++)
			{
				factor *= 10;
			}
			
			return Math.ceil(value * factor) / factor; 
		}
		
		/**
		 * 按照保留小数点的位数向下取整
		 */		
		public static function floor(value:Number, length:uint):Number
		{
			var factor:Number = 1;
			for (var i:uint = 0; i < length; i ++)
			{
				factor *= 10;
			}
			
			return Math.floor(value * factor) / factor; 
		}
		
	}
}