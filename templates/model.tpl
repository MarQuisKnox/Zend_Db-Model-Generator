<?="<?php\n"?>
<? if ($this->_addRequire):?>
require_once('<?=$this->_className?>Mapper.php');
<? endif; ?>

/**
 * Add your description here
 *
 * @author <?=$this->_author."\n"?>
 * @copyright <?=$this->_copyright."\n"?>
 * @license <?=$this->_license."\n"?>
 */
 
class <?=$this->_namespace?>_Model_<?=$this->_className?>
{

<?foreach ($this->_columns as $column):?>
    /**
     * mysql var type <?=$column['type']?>

     *
     * @var <?=$column['phptype']?>
     
     */
    protected $_<?=$column['capital']?>;
    
<?endforeach;?>

    protected $_mapper;

    protected $_columnsList=array(
<?foreach ($this->_columns as $column):?>
    '<?=$column['field']?>'=>'<?=$column['capital']?>',
<?endforeach;?>
    );

    /**
     *
     * @param array $data
     * @return Default_Model_
     */

    public function setColumnsList($data) {
        $this->_columnsList=$data;
        return $this;
    }

    /**
     * returns columns list array
     *
     * @return array
     */
    public function getColumnsList() {
        return $this->_columnsList;
    }

    /**
     * converts database column name to php setter/getter function name
     * @param string $column
     */
    protected function columnName2Var($column) {
        if (!isset($this->_columnsList[$column]))
            throw new Exception("column '$column' not found!");
        return $this->_columnsList[$column];
    }

    /**
     * converts database column name to php setter/getter function name
     * @param string $column
     */
    protected function varName2Column($thevar) {

        foreach ($this->_columnsList as $column=>$var)
            if ($var == $thevar)
                    return $column;
        return null;
    }
	
    <?foreach ($this->_columns as $column):?>

    /**
     * sets column <?=$column['field']?> type <?=$column['type']?>
     
     *
     * @param <?=$column['phptype']?> $data
     * @return <?=$this->_namespace?>_Model_<?=$this->_className?>
     
     *
     **/

    public function set<?=$column['capital']?>($data)
    {
        $this->_<?=$column['capital']?>=$data;
        return $this;
    }

    /**
     * gets column <?=$column['field']?> type <?=$column['type']?>

     * @return <?=$column['phptype']?>
     
     */
     
    public function get<?=$column['capital']?>()
    {
        return $this->_<?=$column['capital']?>;
    }
    <?endforeach;?>

    /**
     * Recognize methods for Belongs-To cases:
     * findBy<field>()
     * findOneBy<field>()
     * Use the non-greedy pattern repeat modifier e.g. \w+?
     *
     * @param string $method
     * @param array  $args
     */

    public function __call($method, array $args)
    {
        $matches = array();
        $result=null;
        if (preg_match('/^find(One)?By(\w+)?$/', $method, $matches)) {
                $methods = get_class_methods($this);
                $check = 'set'.$matches[2];

                $fieldName=$this->varName2Column($matches[2]);

                if (!in_array($check, $methods)) {
                        throw new Exception("Invalid field {$matches[2]} requested for table");
                }
                if ($matches[1] != '') {
                    $result=$this->getMapper()->findOneByField($fieldName, $args[0], $this);
                }
                    else $result=$this->getMapper()->findByField($fieldName, $args[0], $this);
                return $result;
        }

        throw new Exception("Unrecognized method '$method()'");
    }

    /**
     * fetch all rows in a 3d array
     *
     * @return array
     */

    public function fetchAllToArray()
    {
        $resultSet = $this->getMapper()->getDbTable()->fetchAll()->toArray();
        return $resultSet;
    }

    /**
     *  __set() is run when writing data to inaccessible properties
     *  overloading it to support setting columns.
     *  example: class->column_name='foo' or class->ColumnName='foo'
     *           will execute the function class->setColumnName('foo')
     *
     * @param string $name
     * @param mixed $value
     * 
     */

    public function __set($name, $value)
    {
       $name=$this->columnName2var($name);

                $method = 'set'.$name;
                if (('mapper' == $name) || !method_exists($this, $method)) {
                        throw new Exception("name:$name value:$value - Invalid {$this->_tbname} property");
                }
                $this->$method($value);
    }

    /**
     *  __get() is utilized for reading data from inaccessible properties
     *  overloading it to support getting columns value.
     *  example: $foo=class->column_name or $foo=class->ColumnName
     *           will execute the function $foo=class->getColumnName()
     *
     * @param string $name
     * @param mixed $value
     *
     */
     
    public function __get($name)
    {
        $this->columnName2Var($name);

        $method = 'get'.$name;
        if (('mapper' == $name) || !method_exists($this, $method)) {
                throw new Exception("name:$name  - Invalid $this->_tbname property");
        }
        return $this->$method();
    }

    public function setOptions(array $options)
    {
        $methods = get_class_methods($this);
        foreach ($options as $key => $value) {
                $key = preg_replace_callback('/_(.)/', create_function('$matches','return ucfirst($matches[1]);'), $key);
                $method = 'set' . ucfirst($key);
                if (in_array($method, $methods)) {
                        $this->$method($value);
                }
        }
        return $this;
    }

    /**
     * sets the mapper class
     *
     * @param <?=$this->_namespace?>_Model_<?=$this->_className?>Mapper $mapper
     * @return <?=$this->_namespace?>_Model_<?=$this->_className?>
     
     */

    public function setMapper($mapper)
    {
        $this->_mapper = $mapper;
        return $this;
    }


    /**
     * returns the mapper class
     *
     * @return <?=$this->_namespace?>_Model_<?=$this->_className?>Mapper
     *
     */

    public function getMapper()
    {
        if (null === $this->_mapper) {
            $this->setMapper(new <?=$this->_namespace?>_Model_<?=$this->_className?>Mapper());
        }
        return $this->_mapper;
    }


    /**
     * returns an array, keys are the field names.
     *
     * @return array
     */
    public function toArray() {
        return $this->getMapper()->toArray($this);
    }

    /**
     * saves current loaded row
     *
     */

    public function save()
    {
        $this->getMapper()->save($this);
    }

    /**
     * finds row by id
     *
     * @param <?=$this->_primaryKey['phptype']?> $id
     * @return <?=$this->_namespace?>_Model_<?=$this->_className?>

     *
     */
    public function find($id)
    {
        $this->getMapper()->find($id, $this);
        return $this;
    }

    /**
     * fetchs all row 
     * returns an array of <?=$this->_namespace?>_Model_<?=$this->_className?>

     *
     * @return array
     *
     */
    public function fetchAll()
    {
        return $this->getMapper()->fetchAll();
    }

    /**
     * fetchs all rows 
     * optionally filtered by where, order, count and offset
     * returns an array of <?=$this->_namespace?>_Model_<?=$this->_className?>

     *
     * @return array
     * 
     */
    public function fetchList($where=null, $order=null, $count=null, $offset=null)
    {
        return $this->getMapper()->fetchList($where, $order, $count, $offset);
    }

    /**
     * fetchs all rows
     * optionally filtered by where, order, count and offset
     * returns a 3d-array of the result
     *
     * @return array
     *
     */
    public function fetchListToArray($where=null, $order=null, $count=null, $offset=null)
    {
        return $this->getMapper()->fetchListToArray($where, $order, $count, $offset);
    }

    /**
     * deletes current row by deleting a row that matches the primary key
     * 
     * @return int
     */

    public function deleteRowByPrimaryKey()
    {
        if (!$this->get<?=$this->_primaryKey['capital']?>())
            throw new Exception('Primary Key does not contain a value');
        return $this->getMapper()->getDbTable()->delete('<?=$this->_primaryKey['field']?> = '.$this->get<?=$this->_primaryKey['capital']?>());
    }

    /**
     * deletes current row by a where satetement
     * 
     * @param string $where
     * @return int
     */
    public function delete($where)
    {
        return $this->getMapper()->getDbTable()->delete($where);
    }

    /**
     * returns the number of rows in the table
     * @var int
     */
    public function countAllRows() {
        return $this->getMapper()->getDbTable()->countAllRows();
    }
        /**
         * returns the primary key column name
         *
         * @var string
         */
        public function getPrimaryKeyName() {
            return $this->getMapper()->getDbTable()->countAllRows();
        }

    
     public function countByQuery($where='') {
        return $this->getMapper()->getDbTable()->countByQuery($where);
     }
}

