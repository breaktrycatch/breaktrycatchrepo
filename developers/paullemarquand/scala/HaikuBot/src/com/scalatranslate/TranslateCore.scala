package com.scalatranslate

import com.google.api.translate.Translate
import com.google.api.translate.Language
import com.google.api.GoogleAPI
import poem.{PoemVariator, PoemForm, HaikuForm}
import twitter4j.conf.ConfigurationBuilder
import scala.collection.JavaConversions._

import collection.mutable.Stack
import twitter4j._
import util.{InputSanitizer, NumberToWordConversion}
import scala.{Console}
import java.io.{FileFilter, FileWriter, File}

object TranslateCore extends scala.Application {

  val MAX_SEPARATION_SYLLABLES: Int = 26
  val MAX_TRANSLATION_STACK: Int = 15
  val MAX_TWEES_PER_RUN: Int = 3
  val MAX_TWEET_SIZE: Int = 144 
  val DEBUG_MODE: Boolean = false
  val INPUT_MODE: Boolean = false
  val RUN_ON_OLD_TWEETS: Boolean = false;

  var tweetsMade: Int = 0
  val haikuForm: HaikuForm = new HaikuForm("c06d")
  val languages: List[Language] = List(Language.VIETNAMESE, Language.LATVIAN, Language.ARABIC, Language.CHINESE, Language.JAPANESE)
  val variator: PoemVariator = new PoemVariator(haikuForm)

  override def main(args: Array[String]): Unit = {

    GoogleAPI.setHttpReferrer("http://www.breaktrycatch.com/");

    if(!INPUT_MODE)
    {
      val twitter: Twitter = configureTwitter()
      followNewUsers( twitter )
      createHaikuFromStatuses( twitter )
    }
    else
    {
      runCommandLine()
    }
  }

  def runCommandLine() = {
    var poemInput: String = ""
    val escapeSequences: List[String] = List("quit", "exit", """\q""")
    while(!escapeSequences.contains( poemInput ))
    {
      Console.print("Enter input: ")
      poemInput = sanitizeStatus(Console.readLine())
      Console.println(poemInput.split(' ').map(word => haikuForm.wordSyllables(word)).zip(poemInput.split(' ')).map( set => "(" + set._1 + "): " +  set._2).mkString("| "))


      if(!escapeSequences.contains( poemInput ))
        languages.foreach( lang => findPoem(poemInput, haikuForm, lang))
    }
  }

  def getOldTweets(): List[String] = {
    val curDir: String = System.getProperty("user.dir");
    val files: List[String] = new File(curDir).listFiles(new TxtFileFilter()).toList.map(f => f.getName())
   files.map(f =>scala.io.Source.fromFile(f).mkString)
  }

  // find people who are following me but who I'm not following. Follow them.
  def followNewUsers(twitter: Twitter) : Unit = {
    val followerIDs = twitter.getFollowersIDs().getIDs()
    val friendIDs = twitter.getFriendsIDs().getIDs()
    followerIDs.filter( id => !friendIDs.contains(id) ).map( id => createFriendship( twitter, id ) )
     Console.println("\n")
  }

  // awwwwww, best function ever!
  def createFriendship(twitter:Twitter, id:Int ) : Unit = {
    val friend: User = twitter.createFriendship( id )
    Console.println("Found a new Friend!!! Their name is: " + friend.getScreenName() )
  }

  def createHaikuFromStatuses(twitter: Twitter) : Unit = twitter.getFriendsStatuses().toList.map( usr => createHaikuFromLatestStatus( usr, twitter ) )

  def createHaikuFromLatestStatus(user: User, twitter: Twitter) : Unit = {

    // if for whatever reason Twitter has failed us.
    if(user == null || user.getStatus() == null || tweetsMade >= MAX_TWEES_PER_RUN)
      return

    Console.println("User: " + user.getScreenName() + " Status: " + user.getStatus().getText())

    // if the user hasn't updated their status since we've last checked, ignore it.
    if( getLastStatus(user) == user.getStatus().getText() && !DEBUG_MODE)
      return

    var i: Int = 0
    var poem: String = null
    val status: String = sanitizeStatus(user.getStatus().getText())
    while(poem == null && i < languages.size) {

      if(haikuForm.totalSyllables(status) > MAX_SEPARATION_SYLLABLES)
      {
        poem = status.split(Array[Char]('.', '!', '?', ':')).map(s => findPoem(s, haikuForm, languages(i)) ).find( s => s != null ).getOrElse(null)
      } else {
        poem = findPoem(status, haikuForm, languages(i))
      }

      i += 1
    }

    // save this as the last status
    if(!DEBUG_MODE)
     writeLastStatus(user)

    if(poem != null)
    {
      val newStatus: String = poem.replaceAll("\n", " /") + " #haiku by: " + "@" + user.getScreenName()
      Console.println("STATUS\n" + newStatus + "\n\n\n\n")
      tweetsMade += 1

      if(!DEBUG_MODE)
        twitter.updateStatus(newStatus)
    }
  }

  def getLastStatus(user: User): String = {
    val filename: String = user.getScreenName() + ".txt"
    if(new File(filename).exists()) scala.io.Source.fromFile(filename).mkString else null
  }

  def writeLastStatus(user: User): Unit = {
    val filename: String = user.getScreenName() + ".txt"
    val fileWriter: FileWriter = new FileWriter(filename)
    fileWriter.write(user.getStatus().getText())
    fileWriter.close()
  }

  def sanitizeStatus(status: String): String = {
    val sanitizer = new InputSanitizer()
    sanitizer.addBlacklistItem("""(?i)\b((?:[a-z][\w-]+:(?:/{1,3}|[a-z0-9%])|www\d{0,3}[.]|[a-z0-9.\-]+[.][a-z]{2,4}/)(?:[^\s()<>]+|\(([^\s()<>]+|(\([^\s()<>]+\)))*\))+(?:\(([^\s()<>]+|(\([^\s()<>]+\)))*\)|[^\s`!()\[\]{};:'".,<>?]))""")
    sanitizer.addBlacklistItem("#|@")
    return sanitizer.sanitize(status)
  }

  def configureTwitter() : Twitter = {
    val cb: ConfigurationBuilder = new ConfigurationBuilder()
    cb.setOAuthConsumerKey("DUWI8bDiNWBHYYKmoLNycw")
      .setOAuthConsumerSecret("9n3TJyN0AMgspRBspUkUnlbAZfGGy2jZ2KSKqCF1o")
      .setOAuthAccessToken("223255496-ISni3zLIMJu4aPBq35mQ0z74Pbi0ING2MLTGGarV")
      .setOAuthAccessTokenSecret("4nHGeBK7GL86XvLvGXmXSXhhiAELtOiveaWm2V388")
    new TwitterFactory(cb.build()).getInstance()
  }

  def findPoem(input: String, form: PoemForm, lang: Language): String = {

    Console.println("Language: " + lang + "\nInput: " + input)

    // check for blank strings!
    if(input.trim().equals(""))
      return null

    def searchPoem(input: String, form: PoemForm, language: Language): String =
    {
      if(input != null && form.validSyllableCount(input) && form.validLineBreakFormat( form.addLineBreaks(input) )) form.addLineBreaks(input) else null
    }

    // does one iteration of translation on the input.
    //def translate(toTranslate: String, lang: Language) : String = Translate.execute(Translate.execute(toTranslate, Language.ENGLISH, lang), lang, Language.ENGLISH)
    def translate(toTranslate: String, lang: Language) : String = {
      if(toTranslate == null)
       return null

      try {
        Translate.execute(Translate.execute(toTranslate, Language.ENGLISH, lang), lang, Language.ENGLISH)
      } catch {
         case e: Exception => {
           Console.println("*********************************** " + e.toString())
           null
         }
      }
    }

    // continues creating translations until it finds one that is already in the list, then returns the whole Stack
    def buildTranslationChain(toTranslate:String, translations:TranslationResultChain) : TranslationResultChain = {
      val translation = translate(processInput(toTranslate), lang)

      // an error has happened
      if(translation == null)
        return new TranslationResultChain()

      Console.println("\t(" + form.totalSyllables(translation) +"): " + translation)
      
      // sets the result if it exists, otherwise its null
      translations.setResult(searchPoem(translation, form, lang))

      if(translations.contains(translation) ||
          translations.size > MAX_TRANSLATION_STACK ||
          translation.length > MAX_TWEET_SIZE || 
          translations.hasResult())
        translations else buildTranslationChain(translation, translations.addTranslation(translation))
    }

    def searchForVariations(chain:Stack[String]): String = {
      var i:Int = 0
      while(i < chain.size)
      {
        val result = searchPoem(variator.variate(chain(i)), form, lang) 
        if(result != null)
          return result

        i += 1
      }
      null
    }

    // checks if input is already a haiku and if not, searches a translation chain
    if(searchPoem(input, form, lang) != null)
       return searchPoem(input, form, lang)

    val translations = buildTranslationChain( input, new TranslationResultChain().addTranslation(input) )
    Console.println(lang + " Complete " + ( if(translations.hasResult()) ": " + translations.getResult() + "\n" else "\n" ) )

    if(!translations.hasResult())
      return searchForVariations(translations.getTranslationChain())

    translations.getResult()
  }


  def processInput(input: String): String =
  {
    try{
      input.split(' ').filter( t => t.matches( """[0-9]+""" ) ).foldLeft(input)((str, digit) => str.replaceAll(digit, new NumberToWordConversion().convert(digit.toInt)))
    } catch {
         case e: NumberFormatException => {
           Console.println("*********************************** " + e.toString())
           null
         }
      }
  }

  def getTranslationResult(chain: Stack[String]): String = chain.head;
}

class TxtFileFilter extends FileFilter {
  override def accept(file: File): Boolean = file.getName().toLowerCase().endsWith("txt")
}

class TranslationResultChain()
{
  private var result: String = null
  private val resultStack: Stack[String] = new Stack()

  def setResult(res: String):Unit = result = res
  def hasResult(): Boolean = result != null
  def getResult():String = result

  def addTranslation(input: String): this.type = {
    resultStack.push(input)
    this
  }
  def getTranslationChain(): Stack[String] = resultStack
  def contains(input: String): Boolean = resultStack.contains(input)
  def size(): Int = resultStack.size()
}