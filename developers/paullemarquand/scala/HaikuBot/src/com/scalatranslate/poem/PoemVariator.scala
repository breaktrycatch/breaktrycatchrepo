package com.scalatranslate.poem

import com.scalatranslate.nlp.NLP
import com.scalatranslate.thesarus.{BigHugeThesarus, ThesaurusResponse}

class PoemVariator(form:PoemForm) {

  val nlp: NLP = new NLP("englishPCFG.ser.gz")
  val thesarus: BigHugeThesarus = new BigHugeThesarus()
  
  private val MAX_DISTANCE: Int = 3;

  def variate(input:String): String = {
    var distance: Int = form.getSyllableDistance(input)

    // toooo big a difference. Result wouldn't make sense and would take
    // too many API calls to cull down/expand up to the correct form.
    if(Math.abs(distance) > MAX_DISTANCE)
      return null

    var nouns: List[String] = nlp.getNouns(input)
    
    Console.println("Input Distance(" + distance + "): " + input)
    Console.println("Nouns: " + nouns.mkString(", "))

    if(nouns.size == 0)
      return null
    
    // for now just act on the first noun...
    var result = input
    val i: Int = 0
    while(distance != 0)
    {
      val noun: String = nouns(0)
      val nounSyllables: Int = form.wordSyllables(noun)
      val synonyms: List[String] = getThesarusNouns(noun)

      if(synonyms != null)
      {
       Console.println("Synonyms for (" + noun + "): " + synonyms.mkString(", "))
        val numSynList: List[Int] = synonyms.map(s => form.totalSyllables(s) - nounSyllables)
        val validSyns = synonyms.filter( p => {
          val dist = form.getSyllableDistance(result.replaceAll(noun, p))
          Math.abs(dist) < Math.abs(distance)
        }).sort((a, b) => {
          val d1 = Math.abs(form.getSyllableDistance(result.replaceAll(noun, a)))
          val d2 = Math.abs(form.getSyllableDistance(result.replaceAll(noun, b)))
          d1 < d2
        })

        result = result.replaceAll(noun, validSyns.headOption.getOrElse(noun))
        distance = form.getSyllableDistance(result)
      }
      nouns = nouns.drop(1)

      if(nouns.size == 0 && distance != 0)
        return null
    }

    Console.println("Substitution found! " + result)
    result
  }

  def getThesarusNouns(word: String): List[String] = {
    val response: ThesaurusResponse = thesarus.getSynonyms(word)

    // word lookup failed.
    if(response == null)
       return null
    
    val nouns = response.noun.getOrElse( null )
    if(nouns != null) nouns.get("syn").getOrElse(null) else null
  }
}