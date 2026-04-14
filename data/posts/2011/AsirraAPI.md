---
title: "Asirra in XQuery"
date: 2011-06-25
author: "admin"
tags: []
status: published
migrated-from: AtomicWiki
original-id: "AsirraAPI"
original-url: "https://exist-db.org/exist/apps/wiki/blogs/eXist/AsirraAPI"
---

Previously I wrote an XQuery Module for handling [reCaptcha](/blogs/eXist/.feed.entry/Captcha) Captchas, as I wanted to protect [my personal blog](http://www.adamretter.org.uk) from being spammed.

Unfortunately in the long term reCaptcha did not really work out, as the Spammers were still posting to the comments section of my blog. Its a shame really as I agree with reCaptcha's efforts of digitising books.

I have read several articles about reCaptcha Captchas being cracked, so I decided to try and find a more robot proof approach. After a little Googling, I found [Asirra](http://research.microsoft.com/en-us/um/redmond/projects/asirra/).

Asirra, is another Captcha system, but rather than asking you to compute a sum or enter the words that appear in a deformed image, they instead show you 12 pictures, some of Cats and some of Dogs. You have to correctly select all the Cats. This seems to me like a harder problem to solve with a robot, and so I decided to replace my reCaptcha with Asirra.

I wrote a small reusable XQuery module (downloadable from [here](https://exist.svn.sourceforge.net/svnroot/exist/trunk/xquery-modules/asirra.xqm)), which makes use of the [EXPath](http://www.expath.org) HttpClient functions, so whilst this will work on [eXist-db](http://www.exist-db.org), it should also be useable on any XQuery processor that supports EXPath.

## Example (X)HTML Page (example.html)

``` xml
<?xml version="1.0" encoding="UTF-8"?>
<html xmlns="http://www.w3.org/1999/xhtml">
    <head>
        <title>Asirra Example</title>
    </head>
    <body>
        <form action="example.xql" method="post" id="commentform" onsubmit="return MySubmitForm();">
            
            <!-- start Client API Asirra code -->
            <div id="asirra_auth">
                <a id="asirra_logo" href="http://research.microsoft.com/en-us/um/redmond/projects/asirra/">
                    <img src="http://research.microsoft.com/en-us/um/redmond/projects/asirra/AsirraLogoWithName-Medium.png"/>
                </a>
                <script type="text/javascript" src="http://challenge.asirra.com/js/AsirraClientSide.js"/>
                <script type="text/javascript">
                    <![CDATA[
                    // You can control where the big version of the photos appear by
                    // changing this to top, bottom, left, or right
                    asirraState.SetEnlargedPosition("top");
                    
                    // You can control the aspect ratio of the box by changing this constant
                    asirraState.SetCellsPerRow(6);
                    ]]>
                <script>
                <script type="text/javascript">
                    <![CDATA[
                        var passThroughFormSubmit = false;
                        
                        function MySubmitForm() {
                             if(passThroughFormSubmit) {
                                  return true;
                             }
                             // Do site-specific form validation here, then...
                             Asirra_CheckIfHuman(HumanCheckComplete);
                             return false;
                        }
                        
                        function HumanCheckComplete(isHuman) {
                             if(!isHuman) {
                                  alert("Please correctly identify the cats.");
                             } else {
                                  passThroughFormSubmit = true;
                                  formElt = document.getElementById("commentform");
                                  formElt.submit();
                             }
                        }
                    ]]>
                </script>
            </div>
            <!-- end Client API Asirra code -->
            
            <input type="submit"/>
        </form>
    </body>
</html>
```

## Example XQuery handler (example.xql)

``` xquery
xquery version "1.0";

import module namespace request = "http://exist-db.org/xquery/request";

import module namespace asirra = "http://asirra.com/xquery/api" at "xmldb:exist:///db/asirra.xqm";

asirra:validate-ticket(request:get-parameter("Asirra_Ticket",()))
```

## Asirra XQuery Module (asirra.xqm)

``` xquery
xquery version "1.0";

(:~
: XQuery Module implementation for the Asirra API - http://research.microsoft.com/en-us/um/redmond/projects/asirra/
:
: @author Adam Retter <adam@exist-db.org>
: @date 2011-06-24T21:26:00+02:00
:)

module namespace asirra = "http://asirra.com/xquery/api";

import module namespace http = "http://expath.org/ns/http-client";

declare variable $asirra:HTTP-OK := 200;
declare variable $asirra:validation-endpoint := "http://challenge.asirra.com/cgi/Asirra?action=ValidateTicket&amp;ticket=";

(:~
: Validate an Asirra Ticket
:
: @param $asirra-ticket The Asirra ticket to validate
: 
: @return true() or false() indicating whether the ticket was valid
:)
declare function asirra:validate-ticket($asirra-ticket as xs:string) as xs:boolean {

    let $url := fn:concat($asirra:validation-endpoint, $asirra-ticket) return

        let $http-result := http:send-request(<http:request href="{$url}" method="get"/>) return
        
            if(xs:integer($http-result/http:response/@status) eq $asirra:HTTP-OK)then
                let $asirra-result := $http-result[2] return
                    $asirra-result/AsirraValidation/Result eq "Pass"
            else
                false()
};
```
