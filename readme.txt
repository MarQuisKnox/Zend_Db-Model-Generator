Zend-Db-Model-Generator
----------------------



Instructions:

1. copy config.php-default to config.php inside data directory
2. edit config.php and configure your db and other relevant directives.
3. execute it.
   usage: zend-db-model-generator.php <dbname> <tbname> [<namespace>=Default]
   
For comments/suggestions please e-mail,msn,google talk me at kfirufk@gmail.com.

REQUIREMENTS 
------------

1. the PDO extension to be enabled

USAGE
-----

class::fetchAll() - fetch all rows
class::findBy<field>($value) - find by field, where value eq $value.
class::find($id) - find a row by primary key
class::fetchList($where=null, $order=null, $count=null, $offset=null) - fetch all , filtered by where, order, count and offest.
class::save() - save the current row
class::set<field>($value) - sets a field with a value
class::get<field>() - get a field's value
class::fetchAllToArray() - returns all the rows of the table in an array

Example:

class for database table 'users':

===== example.php =======

<?php

/* The following code may be needed without the usage of Zend Framework MVC.
 * here i include the Users.php file created by this script, the the 
 * Zend_Db_Adapter_Mysqli in order to create a connection 
 * to the database, and the Zend_Db_Table
 * class in order to set the default adapter.
 */


require_once("Users.php");

require_once("Zend/Db/Adapter/Mysqli.php");
require_once("Zend/Db/Table.php");

$db = new Zend_Db_Adapter_Mysqli(array(
    'host'     => '127.0.0.1',
   'username' => 'root',
    'password' => '<PASSWORD>',
    'dbname'   => '<DB>'
));

Zend_Db_Table::setDefaultAdapter($db);

/******************************************/

/* example 1 - fetch all rows to an array */

$users = new Default_Model_Users();
$rows=$users->fetchAllToArray();
var_dump($rows);

/* end of example 1 */

/* example 2 - find a row by primary key and set column 'first_name'  to the name 'foo'. */

$users = new Default_Model_Users();
$users->find(1);
$users->setFirstName('foo');
$users->save();

/* end of example 2 */

?>

==== end of example.php ==

THANKS
------
I want to thank the following people for their feedback/patches/comments:
Charles Spraggs,Richard Hamilton,AJIT DIXIT
