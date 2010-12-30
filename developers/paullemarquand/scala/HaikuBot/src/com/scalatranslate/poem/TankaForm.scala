package com.scalatranslate.poem

class TankaForm(syllableMapFilename: String) extends PoemForm(syllableMapFilename)
{
  override val syllables : List[Int] = List(5,7,5,7,7);
}