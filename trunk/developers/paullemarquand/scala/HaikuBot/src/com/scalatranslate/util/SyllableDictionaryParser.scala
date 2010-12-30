package com.scalatranslate.util

import java.io.{BufferedReader, FileReader}
import collection.mutable.Map
import java.util.StringTokenizer

class SyllableDictionaryParser
{
  def parse(filename: String): Map[String, Int] = {
    val map: Map[String, Int] = Map();
    val fileReader: FileReader = new FileReader( filename );
    val in: BufferedReader = new BufferedReader( fileReader );

    var s: String = ""
    while (s != null)
    {
      s = in.readLine();
      if (s != null && s.charAt(0) != '#')
        map.put( s.split(' ').head, parseEntry(s) );
    }
    return map
  }

  def parseEntry(str: String) : Int = {
    val st: StringTokenizer = new StringTokenizer(str)
    if(!st.hasMoreTokens()) return 0

    val word: String = st.nextToken().toLowerCase()
    var syllables: Int = 0;
    while(st.hasMoreTokens()) {
      val phone: String = st.nextToken();
      if( hasDigit( phone) ) syllables += 1;
    }
    return syllables
  }

  def hasDigit(str: String) = str.split("").exists(ch => ch.length() > 0 && Character.isDigit( ch.charAt(0) ) )
}