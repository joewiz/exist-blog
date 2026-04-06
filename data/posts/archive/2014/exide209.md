---
title: "App Updates: eXide 2.0.9"
date: 2014-07-27
author: wolf
tags: [article]
category: article
status: published
migrated-from: AtomicWiki
original-id: eXide209
original-url: https://exist-db.org/exist/apps/wiki/blogs/eXist/eXide209
---

The 2.2RC2 release of eXist also includes updates to most of the core apps and one new app ("monex"). We'll cover the updates and additions in a series of articles. eXide will be first: version 2.0.9 has a number of new features which may not be obvious and need some explanation:

# Live Reload

<figure class="wysiwyg-float-right" style="width: 30%; text-align: center">
    <img src="/exist/apps/blog/resources/images/archive/eXide-live.png" style="display: inline-block;"/>
    <figcaption>Enabling live reload</figcaption>
</figure>

When developing a web application, one usually runs it in a separate tab or window, so after making a change to e.g. an XQuery, you need to switch to the other tab and press reload to get an updated web view.

The "live reload" feature automates this: whenever one saves a resource which belongs to an application package, the tab or window running the app's web view is refreshed automatically.

## Enabling live reload

Due to security restrictions of the browser, a refresh is only possible if the app's browser window was initially created from within eXide. To enable live reload you thus have to:

1. in the editor, switch to or open a resource which is part of the application package you want to run
2. in the "Application" menu, select "Live Reload"
3. a dialog will appear if the application has not been run before from within the same eXide instance. Click on the application link within the dialog to open a new tab with the application's web view.
4. switch back to eXide

The next time you save a resource, the application view should refresh automatically. Depending on your browser and configuration, the application window or tab may either get focus immediately or it is refreshed in the background and you have to switch there to see the change.

Once live reload has been initialized, you can always toggle the feature on/off via the checkbox in the menu without having to open a new application window.

Personally I mostly use live reload in a setup with two screens, having eXide on one screen and the application on the other. It also works great on a smaller laptop screen with multiple open tabs though.

# Directory Uploads

<figure class="wysiwyg-float-right">
    <img src="/exist/apps/blog/resources/images/archive/eXide-upload.png"/>
    <figcaption>Upload dialog</figcaption>
</figure>

Users often critisized in the past that uploading nested directories is not supported by the web-based collection browsers built into dashboard and eXide. If you had to preserve the directory structure, your main options were to either switch to the Java admin client or write a script (e.g. XQuery or Ant) which creates the target collection hierarchy.

The good news: eXide 2.0.9 finally supports directory uploads and preserves nested directories by creating a corresponding hierarchy of collections. The bad news: the feature *is only available in Google Chrome*. It is hard to say if other browsers will follow its lead or provide alternative APIs. Right now you definitely have to use Chrome though.

To upload a directory, proceed as usual:

1. open the collection manager via the "File/Manage" menu
2. browse to the collection into which you want to upload and press the upload icon in the toolbar
3. on Chrome, a separate button, "Upload Directory" will appear. This is hidden on other browsers. Click on it and select a directory to upload.
4. alternatively, you may also drag and drop a directory into the drop area marked with "Drop files here ...", e.g. from a finder window on a Mac.

# Drag and Drop of Files into the Editor
When developing an application, one often needs to use an existing file on the file system as a template to create a new resource in the database. Using eXide, simply drag and drop the file into the editor. eXide will create a new, unnamed resource and insert the contents of the dropped file into it.

# Other changes
Apart from many bug fixes, other notable changes include:

* eXide now remembers the edit position for all open tabs and restores it when the browser window is reopened
* drop the size limits for the validation of XML and XQuery files: previously only files with up to approx. 100k were sent to the server for validation. In particular, if you editied larger XML files, no syntax or validation errors were shown. Those limits have been dropped. Please do not forget that eXide is web-based and not the right tool to edit really large XML documents, but for the average document, the validation features work very well.
* improved support for "less" stylesheets: when saving a .less file, eXide calls the less pre-processor to generate a corresponding .css file in the same collection. This feature was quite buggy in older releases. In particular, relative paths and imports are now handled properly.