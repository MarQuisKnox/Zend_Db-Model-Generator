<?php
require_once('DbTable/Bugs.php');

/**
 * Add your description here
 *
 * @author Kfir Ozer
 * @copyright ZF model generator
 * @license http://framework.zend.com/license/new-bsd     New BSD License
 */

class Default_Model_BugsMapper {

    /**
     * $_dbTable - instance of Default_Model_DbTable_Bugs
     *
     * @var Default_Model_DbTable_Bugs     
     */
    protected $_dbTable;

    /**
     * finds a row where $field equals $value
     *
     * @param string $field
     * @param mixed $value
     * @param Default_Model_Bugs $cls
     */     
    public function findOneByField($field, $value, $cls)
    {
            $table = $this->getDbTable();
            $select = $table->select();

            $row = $table->fetchRow($select->where("{$field} = ?", $value));
            if (0 == count($row)) {
                    return;
            }

            $cls->setBugId($row->bug_id)
		->setBugDescription($row->bug_description)
		->setBugStatus($row->bug_status)
		->setReportedBy($row->reported_by)
		->setAssignedTo($row->assigned_to)
		->setVerifiedBy($row->verified_by);
	    return $cls;
    }


    /**
     * returns an array, keys are the field names.
     *
     * @param new Default_Model_Bugs $cls
     * @return array
     *
     */
    public function toArray($cls) {
        $result = array(
        
            'bug_id' => $cls->getBugId(),
            'bug_description' => $cls->getBugDescription(),
            'bug_status' => $cls->getBugStatus(),
            'reported_by' => $cls->getReportedBy(),
            'assigned_to' => $cls->getAssignedTo(),
            'verified_by' => $cls->getVerifiedBy(),
                    
        );
        return $result;
    }

    /**
     * finds rows where $field equals $value
     *
     * @param string $field
     * @param mixed $value
     * @param Default_Model_Bugs $cls
     * @return array
     */
    public function findByField($field, $value, $cls)
    {
            $table = $this->getDbTable();
            $select = $table->select();
            $result = array();

            $rows = $table->fetchAll($select->where("{$field} = ?", $value));
            foreach ($rows as $row) {
                    $cls=new Default_Model_Bugs();
                    $result[]=$cls;
                    $cls->setBugId($row->bug_id)
		->setBugDescription($row->bug_description)
		->setBugStatus($row->bug_status)
		->setReportedBy($row->reported_by)
		->setAssignedTo($row->assigned_to)
		->setVerifiedBy($row->verified_by);
            }
            return $result;
    }
    
    /**
     * sets the dbTable class
     *
     * @param Default_Model_DbTable_Bugs $dbTable
     * @return Default_Model_BugsMapper
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
     * @return Default_Model_DbTable_Bugs     
     */
    public function getDbTable()
    {
        if (null === $this->_dbTable) {
            $this->setDbTable('Default_Model_DbTable_Bugs');
        }
        return $this->_dbTable;
    }

    /**
     * saves current row
     *
     * @param Default_Model_Bugs $cls
     *
     */
     
    public function save(Default_Model_Bugs $cls,$ignoreEmptyValuesOnUpdate=true)
    {
        if ($ignoreEmptyValuesOnUpdate) {
            $data = $cls->toArray();
            foreach ($data as $key=>$value) {
                if (is_null($value) or $value == '')
                    unset($data[$key]);
            }
        }

        if (null === ($id = $cls->getBugId())) {
            unset($data['bug_id']);
            $id=$this->getDbTable()->insert($data);
            $cls->setBugId($id);
        } else {
            if ($ignoreEmptyValuesOnUpdate) {
             $data = $cls->toArray();
             foreach ($data as $key=>$value) {
                if (is_null($value) or $value == '')
                    unset($data[$key]);
                }
            }

            $this->getDbTable()->update($data, array('bug_id = ?' => $id));
        }
    }

    /**
     * finds row by primary key
     *
     * @param int $id
     * @param Default_Model_Bugs $cls
     */

    public function find($id, Default_Model_Bugs $cls)
    {
        $result = $this->getDbTable()->find($id);
        if (0 == count($result)) {
            return;
        }

        $row = $result->current();

        $cls->setBugId($row->bug_id)
		->setBugDescription($row->bug_description)
		->setBugStatus($row->bug_status)
		->setReportedBy($row->reported_by)
		->setAssignedTo($row->assigned_to)
		->setVerifiedBy($row->verified_by);
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
            $entry = new Default_Model_Bugs();
            $entry->setBugId($row->bug_id)
                  ->setBugDescription($row->bug_description)
                  ->setBugStatus($row->bug_status)
                  ->setReportedBy($row->reported_by)
                  ->setAssignedTo($row->assigned_to)
                  ->setVerifiedBy($row->verified_by)
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
            foreach ($resultSet as $row)
            {
                    $entry = new Default_Model_Bugs();
                    $entry->setBugId($row->bug_id)
                          ->setBugDescription($row->bug_description)
                          ->setBugStatus($row->bug_status)
                          ->setReportedBy($row->reported_by)
                          ->setAssignedTo($row->assigned_to)
                          ->setVerifiedBy($row->verified_by)
                          ->setMapper($this);
                    $entries[] = $entry;
            }
            return $entries;
    }

}
