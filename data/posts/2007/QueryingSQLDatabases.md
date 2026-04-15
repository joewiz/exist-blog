---
title: "Querying SQL Databases from XQuery (SQLModule)"
date: 2007-12-01
author: "Wolfgang Meier"
tags:
  - "howto"
status: published
migrated-from: AtomicWiki
original-id: "QueryingSQLDatabases"
original-blog: "HowTo"
original-url: "https://exist-db.org/exist/apps/wiki/HowTo/QueryingSQLDatabases"
---

This howto explains how you may query or update SQL databases from XQuery returning the results as XML nodesets. This tutorial makes use of the sql extension module for eXist; this is available in eXist from 2006-09-25.

## 1.1 eXist Configuration

Firstly you need to configure eXist to load the additional module, you will need to add the following to the xquery/builtin-modules node of conf.xml (which can be found in EXIST\_HOME -

&lt;module class="org.exist.xquery.modules.sql.SQLModule" uri="http://exist-db.org/xquery/sql" /&gt;

NB - eXist will need to be restarted for this change to take effect.

## 1.2 JDBC Drivers

The SQL Module uses JDBC for its database connectivity and as such for each database type that you wish to connect to a JDBC Driver is required. JDBC Drivers should be placed in EXIST\_HOME/lib/user.

## 1.3 The SQL module

The SQL module provides two main functions - get-connection() and execute().

### 1.3.1 get-connection()

Used for opening a connection to the database. The connection persists for the lifetime of the executing query. There are two implementations -

get-connection($jdbcClass, $jdbcConnection) get-connection($jdbcClass, $jdbcConnection, $dbUser, $dbPassword)

- <span class="strong">jdbcClass</span> is the JDBC Driver Class, e.g. for MySQL this would be "com.mysql.jdbc.Driver"

<!-- -->

- <span class="strong">jdbcConnection</span> is the JDBC Connection String. e.g. for a MySQL server running on the local machine with a database called "pies" this would be - " "

<!-- -->

- <span class="strong">dbUser</span> is the database/schema user's username

<!-- -->

- <span class="strong">dbPassword</span> is the password for the database/schema user

The get-connection() function returns an which is the id of the open database connection.

## 1.3.2 execute()

Executes either a query or update against the database. The implementation is -

execute($connection, $sql, $useColumnNames)

- <span class="strong">connection</span> is the connection id obtained from get-connection()

<!-- -->

- <span class="strong">sql</span> is the SQL statement to execute

<!-- -->

- <span class="strong">useColumnNames</span> is an value indicating whether the resultant XML should use the Column Names as the node names.

The execute() function returns a Node representing the SQL results. If the SQL query was an update then an update count is returned.

## 1.4 Example: Querying a SQL Database

xquery version "1.0"; declare namespace sql="http://exist-db.org/xquery/sql"; let $connection := sql:get-connection("com.mysql.jdbc.Driver", "jdbc:mysql://localhost/pies", "root", "") return sql:execute($connection, "select \* from pieFillings;", fn:true())

## 1.5 Example: Updating a SQL Database

xquery version "1.0"; declare namespace sql="http://exist-db.org/xquery/sql"; let $connection := sql:get-connection("com.mysql.jdbc.Driver", "jdbc:mysql://localhost/pies", "root", "") return sql:execute($connection, "insert into pieFillings (filling, cost) values ('apple', 1.0);", fn:false())