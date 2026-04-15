---
title: "Running eXist as a Service"
date: 2008-04-24
author: "Wolfgang Meier"
tags:
  - "howto"
status: published
migrated-from: AtomicWiki
original-id: "RunningeXistas"
original-blog: "HowTo"
original-url: "https://exist-db.org/exist/apps/wiki/HowTo/RunningeXistas"
---

## Change Java Settings

If eXist has been installed as a service under Windows, starting/stopping the database will be handled by the Java service wrapper. The wrapper configures Java using the settings specified in a properties file, which can be found in

    %EXIST_HOME%\tools\wrapper\conf\wrapper.conf

In particular, the settings for `wrapper.java.initmemory` and `wrapper.java.maxmemory` may need to be changed to give more memory to the Java VM - depending on your application needs.

If you would like to run multiple eXist installations as a service, you also need to change the ntservice name to be distinct from the other installations:

    wrapper.ntservice.name=eXistProduction