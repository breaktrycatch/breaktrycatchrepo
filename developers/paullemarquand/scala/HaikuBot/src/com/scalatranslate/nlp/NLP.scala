package com.scalatranslate.nlp

import edu.stanford.nlp.parser.lexparser.LexicalizedParser
import edu.stanford.nlp.process.{PTBTokenizer, WordTokenFactory}
import java.io.StringReader
import edu.stanford.nlp.trees._

class NLP(defFilename: String)
{
  private val lexParser = new LexicalizedParser(defFilename);
  private val tokenizerFactory = PTBTokenizer.factory(false, new WordTokenFactory());

  def parse(input: String): Array[TypedDependency] =
  {
    val tp: TreePrint = new TreePrint("penn,typedDependenciesCollapsed");
    val tokens = tokenizerFactory.getTokenizer(new StringReader(input)).tokenize();
    lexParser.parse(tokens)
    val t:Tree = lexParser.getBestParse()//lexParser.getBestParse(); // get the best parse tree
    val tlp: TreebankLanguagePack = new PennTreebankLanguagePack();
    val gsf: GrammaticalStructureFactory = tlp.grammaticalStructureFactory();
    val gs: GrammaticalStructure = gsf.newGrammaticalStructure(t);
    val collection = gs.typedDependenciesCollapsed()
    collection.toArray(new Array[TypedDependency](collection.size()))
  }

  def getNouns(input: String): List[String] = {
    val tree: Array[TypedDependency] = parse(input)
    (tree.filter( d => d.reln().getShortName() == "nsubj") ++ tree.filter( d => d.reln().getShortName() == "det")).toList.map( d => d.gov().value())
  }
}