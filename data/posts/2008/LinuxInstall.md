---
title: "eXist-db does not work/install on RedHat, Ubuntu, Linux"
date: 2008-08-22
author: "Wolfgang Meier"
tags:
  - "howto"
status: published
migrated-from: AtomicWiki
original-id: "LinuxInstall"
original-blog: "HowTo"
original-url: "https://exist-db.org/exist/apps/wiki/HowTo/LinuxInstall"
---

Probably you use the default installed java version, gnu classpath/gjc. We recommend the Sun JVM, but JVMs of other vendors should work as well

Search for "gjc" in the errormessages:

    java.lang.ArrayIndexOutOfBoundsException
       at java.lang.System.arraycopy(libgcj.so.70)
       at java.io.ObjectInputStream.read(libgcj.so.70 )
       at java.io.InputStream.skip(libgcj.so.70)
       at com.izforge.izpack.installer.Unpacker.run(Unpacker.java:425)
       at java.lang.Thread.run(libgcj.so.70)

or

    12 Aug 2008 16:34:31,161 [P1-9] WARN  (ServletHandler.java
    [handle]:629) - Error for /exist/logo.jpg
    java.lang.NoClassDefFoundError: org.apache.cocoon.reading.ImageReader
      at java.lang.Class.initializeClass(libgcj.so.81)
      at java.lang.Class.newInstance(libgcj.so.81)

or

    Exception in thread "main" java.lang.InternalError: unexpected exception
    during linking: java.lang.ClassNotFoundException: javax.swing.JFrame
      at 0x004f8ca3: java.lang.Throwable.Throwable(java.lang.String)
    (/usr/lib/./libgcj.so.3)
      at 0x004ebb1e: java.lang.Error.Error(java.lang.String)
    (/usr/lib/./libgcj.so.3)
      at 0x004f9086:
    java.lang.VirtualMachineError.VirtualMachineError(java.lang.String)
    (/usr/lib/./libgcj.so.3)

<span class="strong">ant</span> can help you out to determine the java version:

    ant -diagnostics | grep java.vm

or

    build.sh diagnostics | grep java.vm

results in

    java.vm.version : 1.5.0_13-119
    java.vm.vendor : Apple Inc.
    java.vm.name : Java HotSpot(TM) Client VM
    java.vm.specification.name : Java Virtual Machine Specification
    java.vm.specification.vendor : Sun Microsystems Inc.
    java.vm.specification.version : 1.0
    java.vm.info : mixed mode