---
title: "Enable SSL in Jetty"
date: 2008-12-03
author: "Dannes Wessels"
tags:
  - "howto"
status: published
migrated-from: AtomicWiki
original-id: "JettySSL"
original-blog: "HowTo"
original-url: "https://exist-db.org/exist/apps/wiki/HowTo/JettySSL"
---

**Note: this is for eXist-2.2 only! For eXist-3.0 the HTTPS port is enabled by default on port 8443.**

It is not very difficult to enable HTTPS for exist. Basically the process of enabling SSL in jetty consists of three steps:

1.  Edit the Jetty configuration
2.  Create SSL Certficates
3.  Read the additional notes

## Edit the Jetty configuration

1.  Open `EXIST_HOME/tools/jetty/etc/jetty.xml` in your favourite text editor (jEdit?)
2.  Scroll down to line 69, uncomment line 74 - 93 (element "*Call*")

&lt;Call name="addListener"&gt; &lt;Arg&gt; &lt;New class="org.mortbay.http.SunJsseListener"&gt; &lt;Set name="Port"&gt;8443&lt;/Set&gt; &lt;Set name="PoolName"&gt;P1&lt;/Set&gt; &lt;Set name="MaxIdleTimeMs"&gt;30000&lt;/Set&gt; &lt;Set name="lowResources"&gt;30&lt;/Set&gt; &lt;Set name="LowResourcePersistTimeMs"&gt;2000&lt;/Set&gt; &lt;Set name="Keystore"&gt; &lt;SystemProperty name="jetty.home" default="."/&gt;/etc/demokeystore&lt;/Set&gt; &lt;Set name="Password"&gt;secret&lt;/Set&gt; &lt;Set name="KeyPassword"&gt;secret&lt;/Set&gt; &lt;Set name="HttpHandler"&gt; &lt;New class="org.mortbay.http.handler.MsieSslHandler"&gt; &lt;Set name="UserAgentSubString"&gt;MSIE 5&lt;/Set&gt; &lt;/New&gt; &lt;/Set&gt; &lt;/New&gt; &lt;/Arg&gt; &lt;/Call&gt;

## Create SSL Certficates

1.  Generate the SSL certificates with `./build.sh -f build/scripts/jarsigner.xml jetty-keygen`

&lt;!-- Generate FAKE CERTIFICATE for SSL --&gt; &lt;target name="jetty-keygen" description="Generate keystore for jetty."&gt; &lt;genkey alias="jetty" storepass="${keystore.password}" keystore="tools/jetty/etc/demokeystore" validity="${keystore.validity}"&gt; &lt;dname&gt; &lt;param name="CN" value="eXist XML database"/&gt; &lt;param name="OU" value="Anonymous"/&gt; &lt;param name="O" value="exist-db.org"/&gt; &lt;param name="C" value="DE"/&gt; &lt;/dname&gt; &lt;/genkey&gt; &lt;/target&gt;

## Additional notes

Now you are actually ready!

1.  Start the server with `bin/startup.sh`
2.  Point your browser to

Please note only the http traffic to port 8443 is encrypted. Other ports are still unsecure. Check for the following logging in the console:

05 Dec 2008 22:40:16,713 \[main\] INFO (Container.java \[start\]:74) - Started WebApplicationContext\[/exist,eXist XML Database\] 05 Dec 2008 22:40:16,719 \[main\] INFO (SocketListener.java \[start\]:205) - Started SocketListener on 0.0.0.0:8080 05 Dec 2008 22:40:16,720 \[main\] INFO (SunJsseListener.java \[createFactory\]:185) - jetty.ssl.keystore=/Users/drfoobar/eXist/tools/jetty/etc/demokeystore 05 Dec 2008 22:40:16,720 \[main\] INFO (SunJsseListener.java \[createFactory\]:189) - jetty.ssl.password=\*\*\*\*\*\* 05 Dec 2008 22:40:16,720 \[main\] INFO (SunJsseListener.java \[createFactory\]:195) - jetty.ssl.keypassword=\*\*\*\*\*\* 05 Dec 2008 22:40:16,720 \[main\] INFO (SunJsseListener.java \[createFactory\]:200) - jetty.ssl.keystore.type=jks 05 Dec 2008 22:40:16,721 \[main\] INFO (SunJsseListener.java \[createFactory\]:225) - jetty.ssl.keystore.provider.name=\[DEFAULT\] 05 Dec 2008 22:40:16,735 \[main\] INFO (SunJsseListener.java \[createFactory\]:248) - SSLServerSocketFactory=com.sun.net.ssl.internal.ssl.SSLServerSocketFactoryImpl@95575f 05 Dec 2008 22:40:16,945 \[main\] INFO (JsseListener.java \[newServerSocket\]:200) - JsseListener.needClientAuth=false 05 Dec 2008 22:40:16,946 \[main\] INFO (SocketListener.java \[start\]:205) - Started SocketListener on 0.0.0.0:8443 05 Dec 2008 22:40:16,946 \[main\] INFO (Container.java \[start\]:74) - Started org.mortbay.jetty.Server@eb41e5 ----------------------------------------------------- Server has started on port 8080. Configured contexts: http://localhost:8080/exist ----------------------------------------------------- 05 Dec 2008 22:40:28,891 \[P1-9\] INFO (Container.java \[start\]:74) - Started HttpContext\[/,/\]

If you have a 'real' x509 certificate (free at e.g. [Thawte](https://www.thawte.com/cgi/personal/contents.exe)) you might consider to convert your x509 certificate using [KeyTool IUI](http://yellowcat1.free.fr/index_ktl.html) into a Java KeyStore (jks)