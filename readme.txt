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

class::toArray() - returns an array, keys are the column names
class::fetchAll() - fetch all rows
class::findOneBy<field>($value) - find a row where the field eq $value
class::findBy<field>($value) - find an array 
class::find($id) - find a row by primary key
class::fetchList($where=null, $order=null, $count=null, $offset=null) - fetch all , filtered by where, order, count and offset.
class::fetchListToArray($where=null, $order=null, $count=null, $offset=null) - fetch all , filtered by where, order, count and offset.
                                                                               returns each row in an array instead of an instance of the class.
class::save() - save the current row
class::set<field>($value) - sets a field with a value
class::get<field>() - get a field's value
class::fetchAllToArray() - returns all the rows of the table in an array

class::deleteRowByPrimaryKey() - in general it's used to delete the current loaded row
class::delete($where)   - delete rows in the table by $where
class::countAllRows() -  counts all rows
class::getPrimaryKeyName() - returns the name of the primary key column
class::countByQuery($where='') - count query results

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

$users = new Default_Model_Users();

// example 1: fetchs an array of Default_Model_Users filtered by username eq 'admin'. 

$data=$users->fetchList('username = \'admin\'',null,1);
var_dump($data[0]->toArray());

// fetchs one row where username eq 'admin'
$users->findOneByUsername('admin');
var_dump($users->toArray());

// fetches all rows where username eq 'admin'
$data=$users->findByUsername('admin');
var_dump($data[0]->toArray());

// finds a row where username eq 'admin' and saves it
$users->findOneByUsername('admin');
$users->setUsername('root');
$users->save();

// finds a row by primary key 1 and delete it
$users->find(1);
$users->deleteRowByPrimaryKey();

?>

==== end of example.php ==

THANKS
------
I want to thank the following people for their feedback/patches/comments:
Charles Spraggs,Richard Hamilton,AJIT DIXIT,Aleksandar Scepanovic


Changelog is created by svn2cl (http://arthurdejong.org/svn2cl).
