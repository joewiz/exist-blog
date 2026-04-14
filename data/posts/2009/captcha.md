---
title: "reCaptcha in XQuery"
date: 2009-02-20
author: "adam"
tags: []
status: published
migrated-from: AtomicWiki
original-id: "Captcha"
original-url: "https://exist-db.org/exist/apps/wiki/blogs/eXist/Captcha"
---

<div>

Store each of the files below in your /db collection, make sure to replace the instances of YOUR-PRIVATE-KEY and YOUR-PUBLIC-KEY with your reCaptcha public and private keys which you can obtain from signing up at the reCaptcha website.

Then simply call []() from your web-browser (assuming you are running eXist in Jetty mode).

## Example (X)HTML Page (example.html)

``` xml
<?xml version="1.0" encoding="UTF-8"?>
<html xmlns="http://www.w3.org/1999/xhtml">
    <head>
        <title>reCaptacha Example</title>
    </head>
    <body>
        <form method="post" action="example.xql">
            
            <!-- start Client API reCaptcha code -->
            <script type="text/javascript" src="http://api.recaptcha.net/challenge?k=YOUR-PUBLIC-KEY"></script>
            <noscript>
                <iframe src="http://api.recaptcha.net/noscript?k=YOUR-PUBLIC-KEY" height="300" width="500" frameborder="0"></iframe><br/>
                <textarea name="recaptcha_challenge_field" rows="3" cols="40"></textarea>
                <input type="hidden" name="recaptcha_response_field" value="manual_challenge"/>
            </noscript>
            <!-- end Client API reCaptcha code -->
            
            <input type="submit"/>
        </form>
    </body>
</html>
```

## Example XQuery handler (example.xql)

``` xquery
xquery version "1.0";

declare namespace request = "http://exist-db.org/xquery/request";

import module namespace recap = "http://www.exist-db.org/xquery/util/recapture" at "xmldb:exist:///db/recaptcha.xqm";

let $recapture-private-key := "YOUR-PRIVATE-KEY" return 
    recap:validate($recapture-private-key, request:get-parameter("recaptcha_challenge_field", ()), request:get-parameter("recaptcha_response_field",()))
```

## reCaptcha XQuery Module (recaptcha.xqm)

``` xquery
module namespace recap="http://www.exist-db.org/xquery/util/recapture";

declare namespace httpclient = "http://exist-db.org/xquery/httpclient";

declare variable $recap:VALIDATE_URI as xs:anyURI := xs:anyURI("http://api-verify.recaptcha.net/verify");

(:~
: Module for working with reCaptcha
:)

declare function recap:validate($private-key as xs:string, $recaptcha-challenge as xs:string, $recaptcha-response as xs:string) as xs:boolean
{
    (: let $client-ip := request:get-remote-addr(), :)
    let $client-ip := request:get-header("X-Real-IP"),        (: if behind webserver proxy :)

     $post-fields := <httpclient:fields>
            <httpclient:field name="privatekey" value="{$private-key}"/>
            <httpclient:field name="remoteip" value="{$client-ip}"/>
            <httpclient:field name="challenge" value="{$recaptcha-challenge}"/>
            <httpclient:field name="response" value="{$recaptcha-response}"/>
        </httpclient:fields> return
    
        let $response := httpclient:post-form($recap:VALIDATE_URI, $post-fields, false(), ()) return
        
            let $recapture-response := $response/httpclient:body/text() return
                if(starts-with($recapture-response, "true"))then
                (
                    true()
                )
                else
                (
                    (: util:log("debug", concat("reCaptcha response='", $capture-response, "'")), :)    (: uncomment to debug reCaptcha response :)
                    false()
                )
};
```

</div>
