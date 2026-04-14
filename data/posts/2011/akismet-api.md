---
title: "Akismet in XQuery"
date: 2011-06-25
author: "adam"
tags: []
status: published
migrated-from: AtomicWiki
original-id: "AkismetAPI"
original-url: "https://exist-db.org/exist/apps/wiki/blogs/eXist/AkismetAPI"
---

So after receiving lots of comment Spam on [my personal blog](http://www.adamretter.org.uk), I switched from using [reCaptcha](/blogs/eXist/.feed.entry/Captcha) to [Asirra](/blogs/eXist/.feed.entry/XQuery%20Module%20for%20Asirra%20API), both small Modules which I implemented in XQuery.

I had assumed that the Spam was the result of a Robot, that was brute force cracking the reCaptcha Captchas via image transformation and OCR. As such, I envisaged that moving from reCaptcha to Asirra would solve this issue, as Asirra is much much tougher for a Robot to solve.

Unfortunately the move from reCaptcha to Asirra did not completely stop the spam, although the quantity is now much less. From this I am concluding that the Spammers are actually Human and that because Asirra is more time consuming that reCaptcha, this has just slowed them down.

Now, I am well versed in email Spam Filtering, as in the past I have configured plenty of Postfix mail servers with SpamAssasin and various DNS Black/White Lists. The thought occurred to me that there must be a similar service for blog comments, a quick Google revealed both [Akismet](http://akismet.com) and [TypePad AntiSpam](http://antispam.typepad.com/).

Akismet appears to be the more established player, however their terms of use are quite limiting, for example whilst personal use is free, you have to pay for commercial use. On the other hand TypePad AntiSpam are the young upstart and have very liberal terms of use. The good news is that TypePad AntiSpam implements exactly the same API as Akismet, so by just changing the hostname of the server you are contacting, you can choose to use either Akismet or TypePad AntiSpam.

So I decided to implement TypePad AntiSpam filtering of comments submitted to my blog, and guess what? I implemented it as a reusable XQuery Module (downloadable from [here](https://exist.svn.sourceforge.net/svnroot/exist/trunk/xquery-modules/akismet.xqm)), which makes use of the [EXPath](http://www.expath.org) HttpClient functions, so whilst this will work on eXist-db, it should also be useable on any XQuery processor that supports EXPath.

## Example (X)HTML Page (example.html)

``` xml
<?xml version="1.0" encoding="UTF-8"?>
<html xmlns="http://www.w3.org/1999/xhtml">
    <head>
        <title>Asirra Example</title>
    </head>
    <body>
        <form action="example.xql" method="post" id="commentform">
            <fieldset>
                <label for="comment_name">Name</label>
                <br/>
                <input id="comment_name" name="name" type="text" size="40"/>
                <br/>
                <label for="comment_email">email address</label> (will not be shown)<br/>
                <input id="comment_email" name="email" type="text" size="40"/>
                <br/>
                <label for="comment_website">Website</label>
                <br/>
                <input id="comment_website" name="website" type="text" size="60"/>
                <br/>
                <label for="comment_comments">Comments</label>
                <br/>
                <textarea id="comment_comments" name="comments" rows="12" cols="55">
                </textarea>
            </fieldset>
            <input type="submit"/>
        </form>
    </body>
</html>
```

## Example XQuery handler (example.xql)

``` xquery
xquery version "1.0";

import module namespace request = "http://exist-db.org/xquery/request";
import module namespace akismet = "http://akismet.com/xquery/api" at "xmldb:exist:///db/akismet.xqm";

declare variable $local:akismet-api-key := "your-akismet-or-typepad-api-key-goes-here";

declare function local:is-comment-spam() as xs:boolean
{
    akismet:comment-check(
        $local:akismet-api-key, 
        <akismet:comment>
            <akismet:blog>http://www.adamretter.org.uk/blog.xql</akismet:blog>
            <akismet:user_ip>{request:get-header("X-Real-IP")}</akismet:user_ip>
            <akismet:user_agent>{request:get-header("User-Agent")}</akismet:user_agent>
            <akismet:referrer>{request:get-header("Referer")}</akismet:referrer>
            <akismet:permalink>http://www.adamretter.org.uk/{request:get-parameter("comment",())}</akismet:permalink>
            <akismet:comment_type>comment</akismet:comment_type>
            <akismet:comment_author>{request:get-parameter("name", ())}</akismet:comment_author>
            {
                if(request:get-parameter("email",()))then
                    <akismet:comment_author_email>{request:get-parameter("email", ())}</akismet:comment_author_email>
                else(),
                
                if(request:get-parameter("website",()))then
                    <akismet:comment_author_url>{ request:get-parameter("website", ()) }</akismet:comment_author_url>
                else()
            }
            <akismet:comment_content>{request:get-parameter("comments", ())}</akismet:comment_content>       
        </akismet:comment>
    )
};

if(local:is-comment-spam())then
    <result>
        <it-was-spam/>
    </result>
else
    <result>
        <not-spam/>
    </result>
```

## Akismet XQuery Module (akismet.xqm)

``` xquery
xquery version "1.0";

(:~
: XQuery Module implementation for the Akismet API - http://akismet.com/development/api/
:
: Can be used with either Akismet or the TypePad AntiSpam service
:
: @author Adam Retter <adam@exist-db.org>
: @date 2011-06-24T21:26:00+02:00
:)

module namespace akismet = "http://akismet.com/xquery/api";
import module namespace http = "http://expath.org/ns/http-client";

declare variable $akismet:HTTP-OK := 200;

declare variable $akismet:endpoint := "api.antispam.typepad.com"; (: for TypePad :)
(: declare variable $akismet:endpoint := "rest.akismet.com"; :) (: for Akismet :)
declare variable $akismet:comment-check-service := "1.1/comment-check"; 
declare variable $akismet:submit-spam-service := "1.1/submit-spam";
declare variable $akismet:submit-ham-service := "1.1/submit-ham";

(:~
:   Calls the Akismet comment check service
:
:   @param api-key Your Akismet API key
:   @param comment
:   <comment xmlns="http://akismet.com/xquery/api">
:       <blog> The front page or home URL of the instance making the request. For a blog or wiki this would be the front page. Note: Must be a full URI, including http://. </blog> (required)
:       <user_ip> IP address of the comment submitter. </user_ip> (required)
:       <user_agent> User agent string of the web browser submitting the comment - typically the HTTP_USER_AGENT cgi variable. Not to be confused with the user agent of your Akismet library. </user_agent> (required)
:       <referrer> The content of the HTTP_REFERER header should be sent here. </referrer> (note spelling)
:       <permalink> The permanent location of the entry the comment was submitted to. </permalink>
:       <comment_type> May be blank, comment, trackback, pingback, or a made up value like "registration". </comment_type>
:       <comment_author> Name submitted with the comment </comment_author>
:       <comment_author_email> Email address submitted with the comment </comment_author_email>
:       <comment_author_url> URL submitted with comment </comment_author_url>
:       <comment_content> The content that was submitted. </comment_content>       
:   </comment>
:
:   @return true() or false() indicating if the comment is spam or not
:)
declare function akismet:comment-check($api-key as xs:string, $comment as element(akismet:comment)) as xs:boolean? {

    let $http-request :=
        <http:request href="{akismet:_get-service-uri($api-key, $akismet:comment-check-service)}" method="post" http="1.0" override-media-type="text/plain">
            <http:header name="User-Agent" value="eXist-db/1.5 | Hermes/0.2"/>
            <http:body media-type="application/x-www-form-urlencoded">{ akismet:_params-xml-to-form-urlencoded($comment)}</http:body>
        </http:request>
    return
        
        let $http-result := http:send-request($http-request) return
            if(xs:integer($http-result[1]/http:response/@status) eq $akismet:HTTP-OK)then
                let $akismet-result := $http-result[2] return
                    $akismet-result eq "true"
            else
                fn:error(xs:QName("akismet:error"), fn:concat("Akismet service responded with http code: ", $http-result/http:response/@status))
};

(:~
:   Calls the Akismet submit spam service
:
:   @param api-key Your Akismet API key
:   @param spam-comment
:   <comment xmlns="http://akismet.com/xquery/api">
:       <blog> The front page or home URL of the instance making the request. For a blog or wiki this would be the front page. Note: Must be a full URI, including http://. </blog> (required)
:       <user_ip> IP address of the comment submitter. </user_ip> (required)
:       <user_agent> User agent string of the web browser submitting the comment - typically the HTTP_USER_AGENT cgi variable. Not to be confused with the user agent of your Akismet library. </user_agent> (required)
:       <referrer> The content of the HTTP_REFERER header should be sent here. </referrer> (note spelling)
:       <permalink> The permanent location of the entry the comment was submitted to. </permalink>
:       <comment_type> May be blank, comment, trackback, pingback, or a made up value like "registration". </comment_type>
:       <comment_author> Name submitted with the comment </comment_author>
:       <comment_author_email> Email address submitted with the comment </comment_author_email>
:       <comment_author_url> URL submitted with comment </comment_author_url>
:       <comment_content> The content that was submitted. </comment_content>       
:   </comment>
:
:   @return true() or false() indicating if the spam was submitted or not
:)
declare function akismet:submit-spam($api-key as xs:string, $spam-comment as element(akismet:comment)) as xs:boolean {
    let $http-request :=
        <http:request href="{akismet:_get-service-uri($api-key, $akismet:submit-spam-service)}" method="post" http="1.0" override-media-type="text/plain">
            <http:header name="User-Agent" value="eXist-db/1.5 | Hermes/0.2"/>
            <http:body media-type="application/x-www-form-urlencoded">{ akismet:_params-xml-to-form-urlencoded($spam-comment)}</http:body>
        </http:request>
    return
        
        let $http-result := http:send-request($http-request) return
            $http-result[1]/http:response/@status eq $akismet:HTTP-OK
};

(:~
:   Calls the Akismet submit ham service
:
:   @param api-key Your Akismet API key
:   @param spam-comment
:   <comment xmlns="http://akismet.com/xquery/api">
:       <blog> The front page or home URL of the instance making the request. For a blog or wiki this would be the front page. Note: Must be a full URI, including http://. </blog> (required)
:       <user_ip> IP address of the comment submitter. </user_ip> (required)
:       <user_agent> User agent string of the web browser submitting the comment - typically the HTTP_USER_AGENT cgi variable. Not to be confused with the user agent of your Akismet library. </user_agent> (required)
:       <referrer> The content of the HTTP_REFERER header should be sent here. </referrer> (note spelling)
:       <permalink> The permanent location of the entry the comment was submitted to. </permalink>
:       <comment_type> May be blank, comment, trackback, pingback, or a made up value like "registration". </comment_type>
:       <comment_author> Name submitted with the comment </comment_author>
:       <comment_author_email> Email address submitted with the comment </comment_author_email>
:       <comment_author_url> URL submitted with comment </comment_author_url>
:       <comment_content> The content that was submitted. </comment_content>       
:   </comment>
:
:   @return true() or false() indicating if the spam was submitted or not
:)
declare function akismet:submit-spam($api-key as xs:string, $ham-comment as element(akismet:comment)) as xs:boolean {
    let $http-request :=
        <http:request href="{akismet:_get-service-uri($api-key, $akismet:submit-spam-service)}" method="post" http="1.0" override-media-type="text/plain">
            <http:header name="User-Agent" value="eXist-db/1.5 | Hermes/0.2"/>
            <http:body media-type="application/x-www-form-urlencoded">{ akismet:_params-xml-to-form-urlencoded($ham-comment)}</http:body>
        </http:request>
    return
        
        let $http-result := http:send-request($http-request) return
            $http-result[1]/http:response/@status eq $akismet:HTTP-OK
};

declare function akismet:_get-service-uri($api-key as xs:string, $service as xs:string) as xs:string {
    fn:concat("http://", $api-key, ".", $akismet:endpoint, "/", $service)
};

declare function akismet:_params-xml-to-form-urlencoded($params as element()) as xs:string {
    fn:string-join(
        for $param in $params/child::element() return
            fn:concat(fn:local-name($param), "=", fn:encode-for-uri($param/text()))
        ,
        "&amp;"
    )
};
```

And so far so good, since switching reCaptcha for Asirra and adding TypePad AntiSpam filtering, I havent received any spam comments. But, now that I have written this...
