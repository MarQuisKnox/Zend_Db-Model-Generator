<?php

$version="0.1.2";
$author="Kfir Ozer <kfirufk@gmail.com>";

class MakeDbTable {

	protected $_tbname;
	protected $_pdo;
	protected $_columns;
	protected $_capitalColumns;
	protected $_capitalPrimaryKey;
	protected $_className;
	protected $_primaryKey;
	protected $_namespace;

	protected $_dbhost='localhost';  // database host
	protected $_dbtype='mysql';    // database type
	protected $_dbuser='root';       // database user
	protected $_dbpassword=''; // database password
	protected $_addRequire=false;   // to add require_once to in order to include the relevant php files. usful if you don't have class auto-loading. if you're using Zend Framework's MVC you can probably set this to false  


	private function _getCapital($str) {
	
		$temp='';
		foreach (split("_",$str) as $part) {
			$temp.=ucfirst($part);
		}
		return $temp;
	
	}

	function __construct($dbname,$tbname,$namespace='Default') {
		
		$columns=array();
		$primaryKey=array();

		$pdo = new PDO(
		    "{$this->_dbtype}:host={$this->_dbhost};dbname=$dbname",
		    $this->_dbuser,
		    $this->_dbpassword,
		    array(PDO::MYSQL_ATTR_INIT_COMMAND => "SET NAMES utf8")
		);

		$this->_pdo=$pdo;
		$this->_tbname=$tbname;
		$this->_namespace=$namespace;


		$this->_className=$this->_getCapital($tbname);

		$qry=$pdo->query("describe $tbname");
		
		if (!$qry)
			throw new Exception("describe $tbname returned false!.");

		$res=$qry->fetchAll();

		foreach ($res as $row) {
		
			$columns[]=$row['Field'];
			if ($row['Key'] == 'PRI')
				$primaryKey[]=$row['Field'];
		}

		if (sizeof($primaryKey) == 0) {
			throw new Exception("didn't find primary keys in table $tbname.");
		} 

		else if (sizeof($primaryKey)>1) {
			throw new Exception("found more then one primary key! probably a bug: ".join(", ",$primaryKey));
		}

		$this->_primaryKey=$primaryKey[0];

		$this->_columns=$columns;

		$capitalColumns=array();

		foreach ($columns as $column) 
			$capitalColumns[]=$this->_getCapital($column);
		
		$this->_capitalColumns=$capitalColumns;

		$this->_capitalPrimaryKey=$this->_getCapital($this->_primaryKey);

	}

	function getDbTableFile() {
	
	$dbTableFile=<<<KFIR
<?php
class {$this->_namespace}_Model_DbTable_{$this->_className} extends Zend_Db_Table_Abstract
{
	protected \$_name="{$this->_tbname}";
	protected \$_id="{$this->_primaryKey}";

}

KFIR;

	return $dbTableFile;

	}

	function getModelFile() {
	
		$classVariables='';
		$gettersNSetters='';
		foreach ($this->_capitalColumns as $column) {
			$classVariables.="\tprotected \$_$column;\n";
			$gettersNSetters.=<<<KFIR

	function set{$column}(\$data) {
		\$this->_$column=\$data;
		return \$this;
	}

	function get{$column}() {
		return \$this->_$column;
	}

KFIR;

		}

		$require = $this->_addRequire ? "require_once(\"{$this->_className}Mapper.php\");" : '';

		$dbMainFile=<<<KFIR
<?php
$require
class {$this->_namespace}_Model_{$this->_className} {
$classVariables
	protected \$_mapper;
$gettersNSetters

	function __call(\$method, array \$args)
	{
		\$matches = array();
		
		/**
		 * Recognize methods for Belongs-To cases:
		 * findBy<field>()
		 * Use the non-greedy pattern repeat modifier e.g. \w+?
		 */
		if (preg_match('/^findBy(\w+)?$/', \$method, \$matches)) {
			\$methods = get_class_methods(\$this);
			\$check = "set{\$matches[1]}";
			
			if (!in_array(\$check, \$methods)) {
				throw new Exception("Invalid field {\$matches[1]} requested for table");
			}
			
			\$this->getMapper()->findByField(\$matches[1], \$args[0], \$this);
			return \$this;
		}
		
		throw new Exception("Unrecognized method '\$method()'");
	}

	public function __set(\$name, \$value)
    		{                         
        		\$method = "set\$name";
        		if (("mapper" == \$name) || !method_exists(\$this, \$method)) {
            			throw new Exception("name:\$name value:\$value - Invalid $this->_tbname property");
        		}                              
        		\$this->\$method(\$value);  
    		}                                
                       
	public function __get(\$name)
	{                                   
        	\$method = "get\$name";                    
        	if (("mapper" == \$name) || !method_exists(\$this, \$method)) {
            		throw new Exception("name:\$name  - Invalid $this->_tbname property");
        	}            
        	return \$this->\$method();
	}
                                     
	public function setOptions(array \$options)
    		{                             
        		\$methods = get_class_methods(\$this);
        		foreach (\$options as \$key => \$value) {
            			\$method = "set" . ucfirst(\$key);
            			if (in_array(\$method, \$methods)) {
                			\$this->\$method(\$value);                     
           	 		}                      
        		}                                          
        		return \$this;
    		}
     
	public function setMapper(\$mapper)             
    	{                               
        	\$this->_mapper = \$mapper;           
        	return \$this;
    	}

   public function getMapper()                                             
    {                                                                       
        if (null === \$this->_mapper) {                                      
            \$this->setMapper(new Default_Model_{$this->_className}Mapper());           
        }                                                        
        return \$this->_mapper;                                   
    }                                                            
                                                                 
    public function save()                                       
    {                                                            
        \$this->getMapper()->save(\$this);
    }                                                            
                                                                 
    public function find(\$id)                                    
    {                                                            
        \$this->getMapper()->find(\$id, \$this);
        return \$this;                                            
    }                              

   public function fetchAll()                                                         
    {                                                                                  
        return \$this->getMapper()->fetchAll();                                          
    }              

}

KFIR;
	return $dbMainFile;

	}
	


	function getMapperFile() {

	$var1=array();

	foreach ($this->_columns as $column) {
		
		$capitalColumn=$this->_getCapital($column);

		$var1[]="\t\t\"$column\" => \$cls->get{$capitalColumn}()";

	}
	$var1=join(",\n",$var1);

	$var2=array();
	$var2[]="->set{$this->_capitalPrimaryKey}(\$row->{$this->_primaryKey})";

	foreach ($this->_columns as $column) {
		
		$capitalColumn=$this->_getCapital($column);

		$var2[]="\t->set{$capitalColumn}(\$row->{$column})";	

	}

	$var2=join("\n",$var2);
	
	$require=$this->_addRequire ? 'require_once("DbTable'.DIRECTORY_SEPARATOR.$this->_className.'.php");' : "";

		$dbMapperFile=<<<KFIR
<?php

$require

class {$this->_namespace}_Model_{$this->_className}Mapper {

    protected \$_dbTable;

	public function findByField(\$field, \$value, \$cls)
	{
		\$table = \$this->getDbTable();
		\$select = \$table->select();
		
		\$row = \$table->fetchRow(\$select->where("{\$field} = ?", \$value));
		if (0 == count(\$row)) {
			return;
		}
		
		\$cls$var2;
	}
    
    public function setDbTable(\$dbTable)
    {
        if (is_string(\$dbTable)) {
            \$dbTable = new \$dbTable();
        }
        if (!\$dbTable instanceof Zend_Db_Table_Abstract) {
            throw new Exception("Invalid table data gateway provided");
        }
        \$this->_dbTable = \$dbTable;
        return \$this;
    }

    public function getDbTable()
    {
        if (null === \$this->_dbTable) {
            \$this->setDbTable("Default_Model_DbTable_{$this->_className}");
        }
        return \$this->_dbTable;
    }

    public function save(Default_Model_{$this->_className} \$cls) {
        \$data = array($var1);

       if (null === (\$id = \$cls->get{$this->_capitalPrimaryKey}())) {
            unset(\$data["{$this->_primaryKey}"]);
            \$this->getDbTable()->insert(\$data);
        } else {
            \$this->getDbTable()->update(\$data, array("{$this->_primaryKey} = ?" => \$id));
        }
    }
	

    public function find(\$id, Default_Model_{$this->_className} \$cls) {
        \$result = \$this->getDbTable()->find(\$id);
        if (0 == count(\$result)) {
            return;
        }

        \$row = \$result->current();

        \$cls$var2;
    }

    public function fetchAll()
    {
        \$resultSet = \$this->getDbTable()->fetchAll();
        \$entries   = array();
        foreach (\$resultSet as \$row) {
            \$entry = new {$this->_namespace}_Model_{$this->_className}();
            \$entry$var2
                  ->setMapper(\$this);
            \$entries[] = \$entry;
        }
        return \$entries;
    }    

}

KFIR;

return $dbMapperFile;
	
	}


	function writeItAll() {
	if (!is_dir($this->_tbname.DIRECTORY_SEPARATOR.'DbTable'))
		if (!@mkdir ($this->_tbname.DIRECTORY_SEPARATOR.'DbTable',0755,true))
			die("ERROR: could not create directory {$this->_tbname}.");
	
	$modelFile=$this->_tbname.DIRECTORY_SEPARATOR.$this->_className.'.php';
	$modelData=$this->getModelFile();
	$mapperFile=$this->_tbname.DIRECTORY_SEPARATOR.$this->_className.'Mapper.php';
	$mapperData=$this->getMapperFile();
	$dbTableFile=$this->_tbname.DIRECTORY_SEPARATOR.'DbTable'.DIRECTORY_SEPARATOR.$this->_className.'.php';
	$dbTableData=$this->getDbTableFile();
	
	if (!file_put_contents($modelFile,$modelData))
		die("Error: could not write model file $modelFile.");

	if (!file_put_contents($mapperFile,$mapperData))
		die("Error: could not write mapper file $mapperFile.");
	
	if (!file_put_contents($dbTableFile,$dbTableData))
		die("Error: could not write db table file $dbTableFile.");
	
	echo "done.\n";
	return true;

	}

}


if (count($argv) != 3) 
	die("usage: ".basename(__FILE__)." <dbname> <tbname>\nBy: $author Version: $version\n");

$dbname=$argv[1];
$tbname=$argv[2];

$cls = new MakeDbTable($dbname,$tbname);

	$cls->writeItAll();


