package com.scalatranslate.thesarus

import io.Source
import java.net.{URLConnection, URL}
import net.liftweb.json.{DefaultFormats, JsonParser}
import collection.immutable.HashMap
import java.io.{IOException, FileNotFoundException, InputStream}

class BigHugeThesarus {

  //TODO: Cache results so we aren't making unnecessary API calls.

  val VERSION: Int = 2
  val API_KEY: String = "ab3bc77783488979a728f806c171264a"
  val FORMAT: String = "json"
  val URL: String = "http://words.bighugelabs.com/api/{version}/{api key}/{word}/{format}"

  private var lookup = new HashMap[String, ThesaurusResponse]

  def getSynonyms(word: String): ThesaurusResponse = {

    val cached: ThesaurusResponse = lookup.getOrElse(word, null)
    if(cached != null)
        return cached

    val urlCon: URLConnection = new URL(createURL(word)).openConnection()
    urlCon.connect()
    try {
      val response: String = convertStreamToString(urlCon.getInputStream())
      implicit val formats = DefaultFormats
      val json = JsonParser.parse(response)
      val result = json.extract[ThesaurusResponse]
      lookup += word -> result
      return result
    } catch {
         case e: FileNotFoundException => {
           Console.println("Unable to find synonym for (" + word + ")")
           return null
         }
         case e: IOException => {
           Console.println("Strange response code for (" + word + ")\n)" + e)
           return null
         }
     }
  }

  private def convertStreamToString(is: InputStream) : String = Source.fromInputStream(is).getLines.reduceLeft(_ + _)
  
  private def createURL(word: String): String = {
    val map:Map[String, String] = Map("{version}" -> VERSION.toString, "{api key}" -> API_KEY, "{word}" -> word, "{format}" -> FORMAT)
    map.foldLeft(URL){ case (m, (k, v)) => m.replace(k, v) }
  }
}

case class ThesaurusResponse(noun:Option[Map[String, List[String]]], verb: Option[Map[String, List[String]]])
