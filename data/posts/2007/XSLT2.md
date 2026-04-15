---
title: "Upgrading eXist for XSLT 2.0 (Saxon)"
date: 2007-12-01
author: "Adam Retter"
tags:
  - "howto"
status: published
migrated-from: AtomicWiki
original-id: "XSLT2"
original-blog: "HowTo"
original-url: "https://exist-db.org/exist/apps/wiki/HowTo/XSLT2"
---

This howto assumes that you wish to replace eXist's default XSLT processor (Xalan) with a processor that supports XSLT 2.0 (Saxon). eXist is installed in EXIST\_HOME. The following describes the necessary steps to replace Xalan with Saxon.

## 1.1 Required jars

This has been tested with both Saxon-B versions 8.7.3 to 9.1.0.7, Saxon-HE 9.2.0.3 and Jakarta RegExp version 1.5

Saxon is available from - 

Apache Jakarta RegExp is available from - 

Download Saxon and Apache Jakarta Regexp and copy the following jars to EXIST\_HOME/lib/user

- jakarta-regexp-1.5.jar (only needed if your using eXist with Cocoon and are also switching Cocoon to Saxon as well).

For Saxon-B -

- saxon9.jar
- saxon9-dom.jar
- saxon9-xpath.jar

For Saxon-HE -

- saxon9he.jar

If you are not using eXist with Cocoon, or wish for Cocoon to also use Saxon instead of Xalan, delete the file xalan.jar in EXIST\_HOME/lib/endorsed

## 1.2 eXist Configuration

In the eXist configuration file EXIST\_HOME/conf.xml find the configuration section for the transformer and change:

&lt;transformer class="org.apache.xalan.processor.TransformerFactoryImpl" /&gt;

to:

&lt;transformer class="net.sf.saxon.TransformerFactoryImpl" /&gt;

## 1.3 Cocoon Changes (Optional)

If you also wish for Cocoon to use Saxon instead of Xalan, you will also need to make changes to two Cocoon configuration files.

### 1.3.1 cocoon.xconf

Typically this is found in EXIST\_HOME/webapp/WEB-INF

In the XSLT Processor section, comment out the two elements for configuring Xalan xslt and Xalan xsltc, e.g. -

&lt;!--+ | XSLT Processor using xsltc from Xalan | For Interpreted Xalan use: | &lt;transformer-factory&gt;org.apache.xalan.processor.TransformerFactoryImpl&lt;/transformer-factory&gt; +--&gt; &lt;!-- &lt;component class="org.apache.excalibur.xml.xslt.XSLTProcessorImpl" logger="core.xslt-processor" role="org.apache.excalibur.xml.xslt.XSLTProcessor/xsltc"&gt; &lt;parameter name="use-store" value="true"/&gt; &lt;parameter name="transformer-factory" value="org.apache.xalan.xsltc.trax.TransformerFactoryImpl"/&gt; &lt;/component&gt; --&gt; &lt;!--+ | Xalan XSLT Processor +--&gt; &lt;!-- &lt;component class="org.apache.excalibur.xml.xslt.XSLTProcessorImpl" logger="core.xslt-processor" role="org.apache.excalibur.xml.xslt.XSLTProcessor/xalan"&gt; &lt;parameter name="use-store" value="true"/&gt; &lt;parameter name="incremental-processing" value="false"/&gt; &lt;parameter name="transformer-factory" value="org.apache.xalan.processor.TransformerFactoryImpl"/&gt; &lt;/component&gt; --&gt;

Then uncomment the element for configuring Saxon, and make sure the transformer-factory parameter is set correctly, as below -

&lt;!--+ | Saxon XSLT Processor | For old (6.5.2) Saxon use: | &lt;parameter name="transformer-factory" value="com.icl.saxon.TransformerFactoryImpl"/&gt; | For new (7+) Saxon use: | &lt;parameter name="transformer-factory" value="net.sf.saxon.TransformerFactoryImpl"/&gt; +--&gt; &lt;component logger="core.xslt-processor" role="org.apache.excalibur.xml.xslt.XSLTProcessor/saxon" class="org.apache.excalibur.xml.xslt.XSLTProcessorImpl"&gt; &lt;parameter name="use-store" value="true"/&gt; &lt;parameter name="transformer-factory" value="net.sf.saxon.TransformerFactoryImpl"/&gt; &lt;/component&gt;

Modify the XPath Processor configuration from:

&lt;xpath-processor class="org.apache.excalibur.xml.xpath.XPathProcessorImpl" logger="core.xpath-processor"/&gt;

to:

&lt;xpath-processor class="org.apache.excalibur.xml.xpath.Saxon7ProcessorImpl" logger="core.xpath-processor"/&gt;

### 1.3.2 sitemap.xmap

Typically this is found in EXIST\_HOME/webapp

Here we need to change the XSLT Transformer section from:

&lt;!-- NOTE: This is the default XSLT processor. --&gt; &lt;map:transformer logger="sitemap.transformer.xslt" name="xslt" pool-grow="2" pool-max="32" pool-min="8" src="org.apache.cocoon.transformation.TraxTransformer"&gt; &lt;use-request-parameters&gt;false&lt;/use-request-parameters&gt; &lt;use-session-parameters&gt;false&lt;/use-session-parameters&gt; &lt;use-cookie-parameters&gt;false&lt;/use-cookie-parameters&gt; &lt;xslt-processor-role&gt;xalan&lt;/xslt-processor-role&gt; &lt;check-includes&gt;true&lt;/check-includes&gt; &lt;/map:transformer&gt;

to:

&lt;!-- NOTE: This is the default XSLT processor. --&gt; &lt;map:transformer name="xslt" logger="sitemap.transformer.xslt" pool-max="32" src="org.apache.cocoon.transformation.TraxTransformer"&gt; &lt;use-request-parameters&gt;false&lt;/use-request-parameters&gt; &lt;use-session-parameters&gt;false&lt;/use-session-parameters&gt; &lt;use-cookie-parameters&gt;false&lt;/use-cookie-parameters&gt; &lt;xslt-processor-role&gt;saxon&lt;/xslt-processor-role&gt; &lt;check-includes&gt;true&lt;/check-includes&gt; &lt;/map:transformer&gt;

Also comment out the other XSLT transformers for Xalan xslt and xsltc, e.g. -

&lt;!-- NOTE: This is the same as the default processor but with a different name (for compatibility) --&gt; &lt;!-- &lt;map:transformer logger="sitemap.transformer.xalan" name="xalan" pool-grow="2" pool-max="32" pool-min="8" src="org.apache.cocoon.transformation.TraxTransformer"&gt; &lt;use-request-parameters&gt;false&lt;/use-request-parameters&gt; &lt;use-session-parameters&gt;false&lt;/use-session-parameters&gt; &lt;use-cookie-parameters&gt;false&lt;/use-cookie-parameters&gt; &lt;xslt-processor-role&gt;xalan&lt;/xslt-processor-role&gt; &lt;check-includes&gt;true&lt;/check-includes&gt; &lt;/map:transformer&gt; --&gt; &lt;!-- NOTE: You can also try XSLTC as the default processor. If you use Xalan extensions, use the "xalan" transformer. --&gt; &lt;!-- &lt;map:transformer logger="sitemap.transformer.xsltc" name="xsltc" pool-grow="2" pool-max="32" pool-min="8" src="org.apache.cocoon.transformation.TraxTransformer"&gt; &lt;use-request-parameters&gt;false&lt;/use-request-parameters&gt; &lt;use-session-parameters&gt;false&lt;/use-session-parameters&gt; &lt;use-cookie-parameters&gt;false&lt;/use-cookie-parameters&gt; &lt;xslt-processor-role&gt;xsltc&lt;/xslt-processor-role&gt; &lt;check-includes&gt;true&lt;/check-includes&gt; &lt;/map:transformer&gt; --&gt;