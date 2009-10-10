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
     * Use the non-greedy pattern repeat modifier e.g. \w+?
     *
     * @param string $method
     * @param array  $args
     */

    public function __call($method, array $args)
    {
        $matches = array();

        if (preg_match('/^findBy(\w+)?$/', $method, $matches)) {
                $methods = get_class_methods($this);
                $check = 'set'.$matches[1];

                if (!in_array($check, $methods)) {
                        throw new Exception("Invalid field {$matches[1]} requested for table");
                }

                $this->getMapper()->findByField($matches[1], $args[0], $this);
                return $this;
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
       $name=explode('_',$name);
        foreach ($name as &$n)
       $n=ucfirst($n);
       $name=implode('',$name);

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
        $name=explode('_',$name);
        foreach ($name as &$n)
           $n=ucfirst($n);
        $name=implode('',$name);

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
        return $this->getMapper()->getDbTable()->delete('<?=$this->_primaryKey?> = '.$this->get<?=$this->_primaryKey['capital']?>());
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

}

