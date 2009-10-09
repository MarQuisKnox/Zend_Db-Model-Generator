<?php
/**
 * main class for files creation
 */
class MakeDbTable {

	/**
         *  @var String $_tbname;
         */
        protected $_tbname;

         /**
          *  @var PDO $_pdo;
          */
	protected $_pdo;


         /**
          *   @var Array $_columns;
          */
	protected $_columns;


         /**
          * @var String $_className;
          */
	protected $_className;

         /**
          *   @var String $_primaryKey;
          */
	protected $_primaryKey;

         /**
          *   @var String $_namespace;
          */
	protected $_namespace;

         /**
          *  @var Array $_config;
          */
        protected $_config;

         /**
          *   @var Boolean $_addRequire;
          */
        protected $_addRequire;

         /**
          *   @var String $_author;
          */
	protected $_author;

         /**
          *   @var String $_license;
          */
	protected $_license;

         /**
          *   @var String $_copyright;
          */
	protected $_copyright;


	/**
         *
         *  removes underscores and capital the letter that was after the underscore
         *  example: 'ab_cd_ef' to 'AbCdEf'
         *
         * @param String $str
         * @return String
         */
        private function _getCapital($str) {
            $temp='';
            foreach (explode("_",$str) as $part) {
                    $temp.=ucfirst($part);
            }
            return $temp;

	}

        /**
         * converts MySQL data types to PHP data types
         *
         * @param string $str
         * @return string
         */
        private function _convertMysqlTypeToPhp($str) {

            preg_match('#^(?:tiny|small|medium|long|big|var)?(\w+)(?:\(\d+\))?(?:\s\w+)*$#',$str,$matches);
            $res=str_ireplace(array('timestamp','blob','char'), 'string', $matches[1]);
            return $res;

        }

	/**
         *
         *  the class constructor
         *
         * @param Array $config
         * @param String $dbname
         * @param String $tbname
         * @param String $namespace
         */
        function __construct($config,$dbname,$tbname,$namespace) {

		$columns=array();
		$primaryKey=array();


                $this->_config=$config;
                $this->_addRequire=$config['include.addrequire'];

		$pdo = new PDO(
		    "{$this->_config['db.type']}:host={$this->_config['db.host']};dbname=$dbname",
		    $this->_config['db.user'],
		    $this->_config['db.password']
		);

		$this->_pdo=$pdo;
		$this->_tbname=$tbname;
		$this->_namespace=$namespace;

                //docs section
                $this->_author=$this->_config['docs.author'];
                $this->_license=$this->_config['docs.license'];
                $this->_copyright=$this->_config['docs.copyright'];


		$this->_className=$this->_getCapital($tbname);

                $pdo->query("SET NAMES UTF8");

                $qry=$pdo->query("describe $tbname");

		if (!$qry)
			throw new Exception("describe $tbname returned false!.");

		$res=$qry->fetchAll();

		foreach ($res as $row) {
			if ($row['Key'] == 'PRI')
				$primaryKey[]=array(
                                        'field'=>$row['Field'],
                                        'type'=>$row['Type'],
                                        'phptype'=>$this->_convertMysqlTypeToPhp($row['Type']),
                                        'capital'=>$this->_getCapital($row['Field']));
                        $columns[]=array(
                                'field'=>$row['Field'],
                                'type'=>$row['Type'],
                                'phptype'=>$this->_convertMysqlTypeToPhp($row['Type']),
                                'capital'=>$this->_getCapital($row['Field']));
		}

                if (sizeof($primaryKey) == 0) {
			throw new Exception("didn't find primary keys in table $tbname.");
		}

		else if (sizeof($primaryKey)>1) {
			throw new Exception("found more then one primary key! probably a bug: ".join(", ",$primaryKey));
		}

		$this->_primaryKey=$primaryKey[0];

		$this->_columns=$columns;

	}

	/**
         * creates directory structure
         *
         * @return Boolean
         */

        public function createNeededDirectories() {
            if (!is_dir($this->_tbname.DIRECTORY_SEPARATOR.'DbTable'))
		if (!@mkdir ($this->_tbname.DIRECTORY_SEPARATOR.'DbTable',0755,true))
			die("ERROR: could not create directory {$this->_tbname}.");
            return true;

        }

        /**
         *
         * parse a tpl file and return the result
         *
         * @param String $tplFile
         * @return String
         */

        public function getParsedTplContents($tplFile) {
            ob_start();
                require('templates'.DIRECTORY_SEPARATOR.$tplFile);
                $data=ob_get_contents();
            ob_end_clean();
            return $data;
        }

        /**
         * creats the DbTable class file
         */
        function makeDbTableFile() {

            $dbTableFile=$this->_tbname.DIRECTORY_SEPARATOR.'DbTable'.DIRECTORY_SEPARATOR.$this->_className.'.php';

            $dbTableData=$this->getParsedTplContents('dbtable.tpl');

            if (!file_put_contents($dbTableFile,$dbTableData))
                    die("Error: could not write db table file $dbTableFile.");

        }

        /**
         * creates the Mapper class file
         */
        function makeMapperFile() {

            $mapperFile=$this->_tbname.DIRECTORY_SEPARATOR.$this->_className.'Mapper.php';

            $mapperData=$this->getParsedTplContents('mapper.tpl');

            if (!file_put_contents($mapperFile,$mapperData))
                    die("Error: could not write mapper file $mapperFile.");
        }

        /**
         * creates the model class file
         */
        function makeModelFile() {

            $modelFile=$this->_tbname.DIRECTORY_SEPARATOR.$this->_className.'.php';

            $modelData=$this->getParsedTplContents('model.tpl');

            if (!file_put_contents($modelFile,$modelData))
                    die("Error: could not write model file $modelFile.");

        }

        /**
         *
         * creates all class files
         *
         * @return Boolean
         */
        function doItAll() {

        $this->createNeededDirectories();

        $this->makeDbTableFile();
        $this->makeMapperFile();
        $this->makeModelFile();

	return true;

	}

}
