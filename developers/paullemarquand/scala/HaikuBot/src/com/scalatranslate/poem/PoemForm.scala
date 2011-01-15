package com.scalatranslate.poem

import com.representqueens.lingua.en.Syllable
import com.scalatranslate.util.{NumberToWordConversion, SyllableDictionaryParser}

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
  def wordSyllables(word: String): Int = syllableMap.getOrElse( stripPunctuation( word ).toUpperCase(), fallbackLookup( stripPunctuation( word ) ) )
  def stripPunctuation(str: String): String = str.replaceAll("""[^A-Za-z ]""", "")
  def totalSyllables(line: String): Int = line.split(' ').foldLeft(0)(( (ctr, elem) => ctr + wordSyllables( stripPunctuation( elem ) ) ) )
  def totalFormSyllables(): Int = syllables.foldLeft(0)(( _ + _));
  def validSyllableCount(poem: String): Boolean = totalSyllables(poem) == totalFormSyllables()
  def getSyllableDistance(poem: String): Int = totalFormSyllables() - totalSyllables(poem)

  // wasn't found in the dictionary lookup, see if its an acronym and if not, then fallback on a general semantic ruleset.
  private  def fallbackLookup(word: String): Int = if( isAcronym( word ) ) countAcronymSyllables(word) else Syllable.syllable( word )
  
  //more than 50% of the characters in the word are Upper Case
  def isAcronym(word: String): Boolean = word.toCharArray().foldLeft(0)((ctr, c) => if(c.isUpper) ctr + 1 else ctr) > word.length / 2

  //TODO: Doesn't handle acronyms with numbers > 10 properly. eg. OS10 (it reads it as O/S/ONE/ZE/RO not O/S/TEN)
  def countAcronymSyllables(word: String): Int = {
    word.toCharArray().map(c => c.toUpper).foldLeft(0)((ctr, c) => {
      // if word ends with a lowecase s, its just a pluralized acronym and doesn't add a syllable (eg. PCs)
      if(word.indexOf(c.toLower) == word.length - 1 && c == 'S') {
        ctr 
      } else if(c.isDigit) {
        ctr + wordSyllables(NumberToWordConversion.convert(Character.digit(c, 10)))
      } else {
        ctr + syllableMap.getOrElse(c.toString, 0)
      }
   })
  }
}