<?php echo "<?php\n";?>
<?php if ($this->_addRequire):?>
require_once('DbTable<?php echo DIRECTORY_SEPARATOR . $this->_className; ?>.php');
<?php endif?>

/**
 * Add your description here
 *
 * @author <?php echo $this->_author."\n"; ?>
 * @copyright <?php echo $this->_copyright."\n"; ?>
 * @license <?php echo $this->_license."\n"; ?>
 */

class <?php echo $this->_namespace; ?>_Model_<?php echo $this->_className; ?>Mapper {

    /**
     * $_dbTable - instance of <?php echo $this->_namespace; ?>_Model_DbTable_<?php echo $this->_className."\n"; ?>
     *
     * @var <?php echo $this->_namespace; ?>_Model_DbTable_<?php echo $this->_className; ?>
     
     */
    protected $_dbTable;

    /**
     * finds a row where $field equals $value
     *
     * @param string $field
     * @param mixed $value
     * @param <?php echo $this->_namespace; ?>_Model_<?php echo $this->_className; ?> $cls
     */     
    public function findOneByField($field, $value, $cls)
    {
        $table = $this->getDbTable();
        $select = $table->select();

        $row = $table->fetchRow($select->where("{$field} = ?", $value));
        if (0 == count($row)) {
            return;
        }

        $cls<?php $count=count($this->_columns); foreach ($this->_columns as $column): $count--?>->set<?php echo $column['functionName']; ?>($row-><?php echo $column['field']?>)<?php if ($count> 0) echo "\n\t\t"; endforeach; ?>;

	    return $cls;
    }


    /**
     * returns an array, keys are the field names.
     *
     * @param new <?php echo $this->_namespace; ?>_Model_<?php echo $this->_className; ?> $cls
     * @return array
     *
     */
    public function toArray($cls) {
        $result = array(
        
            <?foreach ($this->_columns as $column):?>'<?php echo $column['field']; ?>' => $cls->get<?php echo $column['functionName']; ?>(),
            <?endforeach;?>
        
        );
        return $result;
    }

    /**
     * finds rows where $field equals $value
     *
     * @param string $field
     * @param mixed $value
     * @param <?php echo $this->_namespace; ?>_Model_<?php echo $this->_className; ?> $cls
     * @return array
     */
    public function findByField($field, $value, $cls)
    {
        $table = $this->getDbTable();
        $select = $table->select();
        $result = array();

        $rows = $table->fetchAll($select->where("{$field} = ?", $value));
        foreach ($rows as $row) {
            $cls=new <?php echo $this->_namespace; ?>_Model_<?php echo $this->_className; ?>();
            $result[]=$cls;
            $cls<?$count=count($this->_columns); foreach ($this->_columns as $column): $count--?>->set<?php echo $column['functionName']; ?>($row-><?php echo $column['field']?>)<?if ($count> 0) echo "\n\t\t"; endforeach; ?>;
        }

        return $result;
    }
    
    /**
     * sets the dbTable class
     *
     * @param <?php echo $this->_namespace; ?>_Model_DbTable_<?php echo $this->_className; ?> $dbTable
     * @return <?php echo $this->_namespace; ?>_Model_<?php echo $this->_className; ?>Mapper
     * 
     */
    public function setDbTable($dbTable)
    {
        if (is_string($dbTable)) {
            $dbTable = new $dbTable();
        }
        if (!$dbTable instanceof Zend_Db_Table_Abstract) {
            throw new Exception('Invalid table data gateway provided');
        }
        $this->_dbTable = $dbTable;
        return $this;
    }

    /**
     * returns the dbTable class
     * 
     * @return <?php echo $this->_namespace; ?>_Model_DbTable_<?php echo $this->_className; ?>
     
     */
    public function getDbTable()
    {
        if (null === $this->_dbTable) {
            $this->setDbTable('<?php echo $this->_namespace; ?>_Model_DbTable_<?php echo $this->_className; ?>');
        }
        return $this->_dbTable;
    }

    /**
     * saves current row
     *
     * @param <?php echo $this->_namespace; ?>_Model_<?php echo $this->_className; ?> $cls
     *
     */
    public function save(<?php echo $this->_namespace; ?>_Model_<?php echo $this->_className; ?> $cls,$ignoreEmptyValuesOnUpdate=true)
    {
        if ($ignoreEmptyValuesOnUpdate) {
            $data = $cls->toArray();
            foreach ($data as $key=>$value) {
                if (is_null($value) or $value == '')
                    unset($data[$key]);
            }
        }

        if (null === ($id = $cls->get<?php echo $this->_primaryKey['functionName']; ?>())) {
            unset($data['<?php echo $this->_primaryKey['field']; ?>']);
            $id=$this->getDbTable()->insert($data);
            $cls->set<?php echo $this->_primaryKey['functionName']; ?>($id);
        } else {
            if ($ignoreEmptyValuesOnUpdate) {
             $data = $cls->toArray();
             foreach ($data as $key=>$value) {
                if (is_null($value) or $value == '')
                    unset($data[$key]);
                }
            }

            $this->getDbTable()->update($data, array('<?php echo $this->_primaryKey['field']; ?> = ?' => $id));
        }
    }

    /**
     * finds row by primary key
     *
     * @param <?php echo $this->_primaryKey['phptype']; ?> $id
     * @param <?php echo $this->_namespace; ?>_Model_<?php echo $this->_className; ?> $cls
     */
    public function find($id, <?php echo $this->_namespace; ?>_Model_<?php echo $this->_className; ?> $cls)
    {
        $result = $this->getDbTable()->find($id);
        if (0 == count($result)) {
            return;
        }

        $row = $result->current();

        $cls<?$count=count($this->_columns); foreach ($this->_columns as $column): $count--?>->set<?php echo $column['functionName']; ?>($row-><?php echo $column['field']?>)<?if ($count> 0) echo "\n\t\t"; endforeach; ?>;
    }

    /**
     * fetches all rows 
     *
     * @return array
     */
    public function fetchAll()
    {
        $resultSet = $this->getDbTable()->fetchAll();
        $entries   = array();
        foreach ($resultSet as $row) {
            $entry = new <?php echo $this->_namespace; ?>_Model_<?php echo $this->_className; ?>();
            $entry<?foreach ($this->_columns as $column): $count--?>->set<?php echo $column['functionName']; ?>($row-><?php echo $column['field']; ?>)
                  <?endforeach;?>
            ->setMapper($this);
            $entries[] = $entry;
        }
        return $entries;
    }

    /**
     * fetches all rows optionally filtered by where,order,count and offset
     * 
     * @param string $where
     * @param string $order
     * @param int $count
     * @param int $offset 
     *
     */
    public function fetchList($where=null, $order=null, $count=null, $offset=null)
    {
        $resultSet = $this->getDbTable()->fetchAll($where, $order, $count, $offset);
        $entries   = array();
        foreach ($resultSet as $row) {
            $entry = new <?php echo $this->_namespace; ?>_Model_<?php echo $this->_className; ?>();
            $entry<?php foreach ($this->_columns as $column):?>->set<?php echo $column['functionName']; ?>($row-><?php echo $column['field']; ?>)
                  <?php endforeach;?>
            ->setMapper($this);
            $entries[] = $entry;
        }

        return $entries;
    }

}