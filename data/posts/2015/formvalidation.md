---
title: "Automatic form validation in eXistdb"
date: 2015-01-06
author: "Joern"
tags:
  - "article"
status: published
migrated-from: AtomicWiki
original-id: "formvalidation"
original-url: "https://exist-db.org/exist/apps/wiki/blogs/eXist/formvalidation"
original-image-urls:
  - "https://exist-db.org/exist/apps/wiki/data/blogs/eXist/modelvalidator.png"

---

Whenever you need forms in your applications you face the problem of validation. Of course there are a lot of JavaScript solutions out there but that still leaves you with the question how to quickly revalidate the data on the server.

As a first step of our redesign of betterFORM we've developed a facility called 'ModelValidator' that does exactly that but without the need to learn XForms first.

Usually when it comes to user input people start with a plain HTML form as it's the easiest and quickest way to get things running. But once that's done you're left with key/value pairs that you have to check for correct datatype and value range in your server-side scripts. It's certainly no fun task to repeatedly read and check single params before moving on to the interesting part of your application.

Now HTML5 has added some datatypes that have improved the situation but neither all browsers implement them all nor does this give you any safety that the values arriving at the server still adhere to those constraints. Further a simple 'novalidate' put onto the form tag by some unfriendly person before submit disables all checks in the browser and the data are send along as they are.

## What is ModelValidator?

'ModelValidator' is a new facility becoming available in eXistdb very soon that improves this situation. It automatically generates a server-side XForms model that reflects the constraints you've put onto your HTML controls.

Once the user submits the form ModelValidator will intercept the request and generate an XForms model that uses the original HTML document as input and will setup all constraints expressed in the HTML for server-side revalidation. Only in case the incoming data conform to the constraints the submission is forwarded to the action url expressed in the HTML form.

In the context of eXistdb you likely want to send the data to some XQuery script. As its tedious to read all the params one by one ModelValidator does more - it will transform the key/value pairs into an XML structure that you can use as input to your XQuery. Now that you can be sure that your data have been validated before  reaching your script you can directly work with the XML.

![Model Validator](modelvalidator.png)

But ModelValidator can do even more if you are willing to dive into the XForms Model syntax - every time an XForms model is generated for a form it will be stored into the database. When a new request comes in it will check if a model has already been generated and will use it if that's the case. You can now edit the generated model to establish even more rigid constraints that HTML5 does not allow to express.

Last but not least the current prototype does not even need any JavaScript to work - just plain HTML.

## What comes next?

The current prototype does not support all HTML5 datatypes yet and there's still some polishing and testing to do before we can roll it out. Further we have to work out a decent deployment into eXistdb. Hopefully we can publish it with the next version of eXistdb.

ModelValidator is just the first step in our redesign of betterFORM. To provide instant validation once the user has entered a value and to offer more fancy ways of alerting the next iteration will add JavaScript again to speak to the server under the hood. We have decided for modernizing the client-side technologies we're using. Instead of Dojo we'll go for Web Components (likely Polymer) and for the transport we'll exchange DWR (Direct Web Remoting) with Websockets. 

## What will happen to 'full' XForms support?

Though we decided to move away from full XForms support (see [betterFORM Blog](https://betterform.wordpress.com/2014/10/17/moving-forward-betterform-6-aka-fore-is-born/)) in betterFORM 6 we made some effort to further support betterFORM 5 as the fully XForms 1.1 compliant alternative. Thus you will be able to use betterFORM 5 and 6 (once it's there) side-by-side in eXistdb. There won't be any change for those that are using betterFORM 5 in their applications. It will just work as before.



