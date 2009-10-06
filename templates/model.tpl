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

<?foreach ($this->_capitalColumns as $column):?>
    protected $_<?=$column?>;
<?endforeach;?>

    protected $_mapper;
	
    <?foreach ($this->_capitalColumns as $column):?>

    public function set<?=$column?>($data)
    {
        $this->_<?=$column?>=$data;
        return $this;
    }

    public function get<?=$column?>()
    {
        return $this->_<?=$column?>;
    }
    <?endforeach;?>

    public function __call($method, array $args)
    {
        $matches = array();

        /**
         * Recognize methods for Belongs-To cases:
         * findBy<field>()
         * Use the non-greedy pattern repeat modifier e.g. \w+?
         */
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

    public function fetchAllToArray()
    {
        $resultSet = $this->getMapper()->getDbTable()->fetchAll()->toArray();
        return $resultSet;
    }

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

    public function setMapper($mapper)
    {
        $this->_mapper = $mapper;
        return $this;
    }

    public function getMapper()
    {
        if (null === $this->_mapper) {
            $this->setMapper(new <?=$this->_namespace?>_Model_<?=$this->_className?>Mapper());
        }
        return $this->_mapper;
    }

    public function save()
    {
        $this->getMapper()->save($this);
    }

    public function find($id)
    {
        $this->getMapper()->find($id, $this);
        return $this;
    }

    public function fetchAll()
    {
        return $this->getMapper()->fetchAll();
    }

    public function fetchList($where=null, $order=null, $count=null, $offset=null)
    {
        return $this->getMapper()->fetchList($where, $order, $count, $offset);
    }

    public function fetchListToArray($where=null, $order=null, $count=null, $offset=null)
    {
        return $this->getMapper()->fetchListToArray($where, $order, $count, $offset);
    }

    public function deleteRowByPrimaryKey()
    {
        if (!$this->get<?=$this->_capitalPrimaryKey?>())
            throw new Exception('Primary Key does not contain a value');
        return $this->getMapper()->getDbTable()->delete('<?=$this->_primaryKey?> = '.$this->get<?=$this->_capitalPrimaryKey?>());
    }

    public function delete($where)
    {
        return $this->getMapper()->getDbTable()->delete($where);
    }

}

