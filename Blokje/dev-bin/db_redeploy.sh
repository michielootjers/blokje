#!/bin/sh

rootdir=`dirname $0`'/../';
$rootdir/script/blokje_create.pl model DB DBIC::Schema Blokje::Schema create=static components=InflateColumn::DateTime,TimeStamp skip_load_external=1 dbi:Pg:dbname=blokje
