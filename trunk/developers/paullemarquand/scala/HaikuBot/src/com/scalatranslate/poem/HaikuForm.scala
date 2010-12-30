package com.scalatranslate.poem

/**
 * Created by IntelliJ IDEA.
 * User: plemarquand
 * Date: 4-Dec-2010
 * Time: 2:53:43 PM
 * To change this template use File | Settings | File Templates.
 */

class HaikuForm(syllableMapFilename: String) extends PoemForm(syllableMapFilename)
{
  override val syllables : List[Int] = List(5,7,5);
}