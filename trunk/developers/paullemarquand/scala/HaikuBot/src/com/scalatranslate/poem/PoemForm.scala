package com.scalatranslate.poem

import com.representqueens.lingua.en.Syllable
import com.scalatranslate.util.SyllableDictionaryParser;
import scala.collection.mutable.Stack;
import scala.collection.mutable.Map;

class PoemForm(syllableMapFilename: String)
{
  val syllables: List[Int] = List();
  val syllableMap: Map[String, Int] = new SyllableDictionaryParser().parse(syllableMapFilename)

  def validLineBreakFormat(poem: String): Boolean = {
    val lines = poem.split('\n')
    val isValid = lines.length == syllables.size && lines.zip(syllables).map( lst => totalSyllables(lst._1) == lst._2).forall(b => b);
    Console.println("\t\t" + lines.zip(syllables).map( lst => totalSyllables(lst._1) + " == " + lst._2 + " ->" + lst._1).mkString("\n\t\t") + "\n\t\t" + (if(isValid) "Oh Hai Haiku!\n" else "No Haiku\n"))
    isValid
  }

  //TODO: This method is so so dirty.
  def addLineBreaks(poem: String): String = {
    val lines: Stack[String] = new Stack();
    val words: Array[String] = poem.split(' ');

    var j: Int = 0;
    var i: Int = 0;
    while(j < syllables.size)
    {
      var str: String = "";
      while(totalSyllables(str) < syllables(j) && i < words.size)
      {
        str = str + " " + words(i);
        i += 1;
      }
      lines.push(str);
      j += 1;
    }
    lines.reverse.mkString("\n")
  }

  def wordSyllables(word: String): Int = syllableMap.getOrElse(stripPunctuation( word ).toUpperCase(), Syllable.syllable( stripPunctuation( word ) ) )
  def stripPunctuation(str: String): String = str.replaceAll("""[^A-Za-z ]""", "")
  def totalSyllables(line: String): Int = line.split(' ').foldLeft(0)(( (ctr, elem) => ctr + wordSyllables( stripPunctuation( elem ) ) ) )
  def totalFormSyllables(): Int = syllables.foldLeft(0)(( _ + _));
  def validSyllableCount(poem: String): Boolean = totalSyllables(poem) == totalFormSyllables()
  def getSyllableDistance(poem: String): Int = totalFormSyllables() - totalSyllables(poem)
}