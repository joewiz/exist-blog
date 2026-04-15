---
title: "How to restore into a clean database?"
date: 2008-08-21
author: "Wolfgang Meier"
tags:
  - "howto"
status: published
migrated-from: AtomicWiki
original-id: "Restore"
original-blog: "HowTo"
original-url: "https://exist-db.org/exist/apps/wiki/HowTo/Restore"
---

If your db instance crashed (e.g. by running out of memory or other fatal errors), eXist will usually trigger an automatic recovery run, which should restore the database into a consistent state.

However, it sometimes happens that the recovery fails or you start seeing fatal exceptions in the logs, even though the recovery completed normally. In this case, it might be necessary to restart with a clean environment (which is also important when debugging an error).

### Create a backup

Before cleaning the db, you need to create a backup of your data. For older eXist versions, use the Java admin client to create a [backup](http://exist-db.org/backup.html#N10350). Since version 1.2.1, eXist also provides a [check and export tool](http://exist-db.org/backup.html#N10350), which has the advantage that it will test your db for errors before running the export.

If you have problems to even start the db, try removing all .log files from the `webapp/WEB-INF/data` directory.

### Clean the database directory

Stop the database instance if you have not already done so and remove all files from the `webapp/WEB-INF/data` directory. eXist will recreate those files the next time it is started.

### Restore the backup

Restart eXist. The db should now be empty and you can restore the previously created backup using the Java admin client.