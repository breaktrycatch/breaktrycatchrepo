package com.scalatranslate.util

import util.matching.Regex

/**
 * Created by IntelliJ IDEA.
 * User: plemarquand
 * Date: 7-Dec-2010
 * Time: 2:43:23 PM
 * To change this template use File | Settings | File Templates.
 */

class InputSanitizer
{
  var stringList: List[String] = List()
  def sanitize(input: String): String = stringList.foldLeft(input)((str, repl) => str.replaceAll(repl, ""))
  def addBlacklistItem(str: String): Unit = stringList = str :: stringList
}