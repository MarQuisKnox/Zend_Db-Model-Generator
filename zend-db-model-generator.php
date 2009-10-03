<?php

require_once('Zend/Config/Ini.php');
require_once('data/MakeDbTable.php');
require_once('data/config.php');

if (count($argv) < 3) 
	die("usage: ".basename(__FILE__)." <dbname> <tbname> <namespace[=Default]>\nBy: ".AUTHOR." Version: ".VERSION."\n");

$dbname=$argv[1];
$tbname=$argv[2];
$namespace=$config['namespace.default'];
if (isset($argv[3])) {
	$namespace = $argv[3];
}

$cls = new MakeDbTable($config,$dbname,$tbname,$namespace);

$cls->DoItAll();
echo "done!\n";

