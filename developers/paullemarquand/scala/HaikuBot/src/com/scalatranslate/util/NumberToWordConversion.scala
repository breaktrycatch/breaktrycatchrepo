package com.scalatranslate.util

import java.text.DecimalFormat

class NumberToWordConversion
{
  val tensNames :Array[String] = Array[String](
    "",
    " ten",
    " twenty",
    " thirty",
    " forty",
    " fifty",
    " sixty",
    " seventy",
    " eighty",
    " ninety")

  def numNames : Array[String] = Array[String](
    "",
    " one",
    " two",
    " three",
    " four",
    " five",
    " six",
    " seven",
    " eight",
    " nine",
    " ten",
    " eleven",
    " twelve",
    " thirteen",
    " fourteen",
    " fifteen",
    " sixteen",
    " seventeen",
    " eighteen",
    " nineteen")

   def convertLessThanOneThousand(value: Int): String = {
    var soFar: String = "";
    var number: Int = value;
     
    if (number % 100 < 20){
      soFar = numNames(number % 100);
      number /= 100;
    }
    else {
      soFar = numNames(number % 10);
      number /= 10;

      soFar = tensNames(number % 10) + soFar;
      number /= 10;
    }

    if (number == 0) return soFar;
    return numNames(number) + " hundred" + soFar;
  }
  
  def convert(value: Int) : String = {
    // 0 to 999 999 999 999
    if (value == 0) return "zero"

    // pad with "0"
    val snumber = new DecimalFormat("000000000000").format(value);

    val billions = Integer.parseInt(snumber.substring(0,3));
    val millions  = Integer.parseInt(snumber.substring(3,6));
    val hundredThousands = Integer.parseInt(snumber.substring(6,9));
    val thousands = Integer.parseInt(snumber.substring(9,12));    


    var result = billions match {
      case 0 => "";
      case 1 => convertLessThanOneThousand(billions) + " billion ";
      case _ => convertLessThanOneThousand(billions) + " billion ";
    }

    result = result + (millions match {
      case 0 => "";
      case 1 => convertLessThanOneThousand(millions) + " million ";
      case _ => convertLessThanOneThousand(millions) + " million ";
    }).toString()

    result = result + (hundredThousands match {
      case 0 => "";
      case 1 => "one thousand ";
      case _ => convertLessThanOneThousand(hundredThousands) + " thousand ";
    }).toString()

    result = result + convertLessThanOneThousand(thousands);

    // remove extra spaces
    return result.replaceAll("^\\s+", "").replaceAll("\\b\\s{2,}\\b", " ");
  }

}