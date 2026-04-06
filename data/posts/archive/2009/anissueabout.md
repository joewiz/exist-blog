---
title: "An issue about general size of data stored by eXist"
date: 2009-04-17
author: dmitriy
tags: []
status: published
migrated-from: AtomicWiki
original-id: Anissueabout
original-url: https://exist-db.org/exist/apps/wiki/blogs/eXist/FAQ/Anissueabout
---


# NOTE: This post was auto-migrated from AtomicWiki and may need manual review.

Question: When I insert a collection with new XML documents, the total size of files stored at "eXist.webapp.WEB-INF.data" increases (obviously). But, when I delete a collection or a set of collection the size of the same files does not decrease?? Why this happens? Answer: The size of the .dbx files will never decrease. If you delete a document or collection, the pages used by that resource will be freed or rather: marked as deleted. They will be reused for the next document or collection you store. Maybe it is easier to understand if you view the .dbx files as "partitions" rather than "files". The db files will never shrink, though they can be empty.