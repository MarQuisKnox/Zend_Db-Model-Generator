<?="<?php\n"?>
<? if ($this->_addRequire):?>
require_once('DbTable<?=DIRECTORY_SEPARATOR?><?=$this->_className?>.php');
<? endif?>

/**
 * Add your description here
 *
 * @author <?=$this->_author."\n"?>
 * @copyright <?=$this->_copyright."\n"?>
 * @license <?=$this->_license."\n"?>
 */

class <?=$this->_namespace?>_Model_<?=$this->_className?>Mapper {

    /**
     * $_dbTable - instance of <?=$this->_namespace?>_Model_DbTable_<?=$this->_className."\n"?>
     *
     * @var <?=$this->_namespace?>_Model_DbTable_<?=$this->_className?>
     
     */
    protected $_dbTable;

    public function findByField($field, $value, $cls)
    {
            $table = $this->getDbTable();
            $select = $table->select();

            $row = $table->fetchRow($select->where("{$field} = ?", $value));
            if (0 == count($row)) {
                    return;
            }

            $cls<?$count=count($this->_columns); foreach ($this->_columns as $column): $count--?>->set<?=$column['capital']?>($row-><?=$column['field']?>)<?if ($count> 0) echo "\n\t\t"; endforeach;?>;
    }
    
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

    public function getDbTable()
    {
        if (null === $this->_dbTable) {
            $this->setDbTable('<?=$this->_namespace?>_Model_DbTable_<?=$this->_className?>');
        }
        return $this->_dbTable;
    }

    public function save(<?=$this->_namespace?>_Model_<?=$this->_className?> $cls)
    {
        $data = array(
  	<?foreach ($this->_columns as $column):?>
            <?=$column['field']?> => $cls->get<?=$column['capital']?>(),
	<?endforeach;?>
        );

       if (null === ($id = $cls->get<?=$this->_primaryKey['capital']?>())) {
            unset($data['<?=$this->_primaryKey?>']);
            $id=$this->getDbTable()->insert($data);
            $cls->set<?=$this->_primaryKey['capital']?>($id);
        } else {
            $this->getDbTable()->update($data, array('<?=$this->_primaryKey?> = ?' => $id));
        }
    }

    public function find($id, <?=$this->_namespace?>_Model_<?=$this->_className?> $cls)
    {
        $result = $this->getDbTable()->find($id);
        if (0 == count($result)) {
            return;
        }

        $row = $result->current();

        $cls<?$count=count($this->_columns); foreach ($this->_columns as $column): $count--?>->set<?=$column['capital']?>($row-><?=$column['field']?>)<?if ($count> 0) echo "\n\t\t"; endforeach;?>;
    }

    public function fetchAll()
    {
        $resultSet = $this->getDbTable()->fetchAll();
        $entries   = array();
        foreach ($resultSet as $row) {
            $entry = new <?=$this->_namespace?>_Model_<?=$this->_className?>();
            $entry<?foreach ($this->_columns as $column): $count--?>->set<?=$column['capital']?>($row-><?=$column['field']?>)
                  <?endforeach;?>
            ->setMapper($this);
            $entries[] = $entry;
        }
        return $entries;
    }

    public function fetchList($where=null, $order=null, $count=null, $offset=null)
    {
            $resultSet = $this->getDbTable()->fetchAll($where, $order, $count, $offset);
            $entries   = array();
            foreach ($resultSet as $row)
            {
                    $entry = new <?=$this->_namespace?>_Model_<?=$this->_className?>();
                    $entry<?foreach ($this->_columns as $column):?>->set<?=$column['capital']?>($row-><?=$column['field']?>)
                          <? endforeach;?>
->setMapper($this);
                    $entries[] = $entry;
            }
            return $entries;
    }

    public function fetchListToArray($where=null, $order=null, $count=null, $offset=null)
    {
            $resultSet = $this->getDbTable()->fetchAll($where, $order, $count, $offset)->toArray();
            return $resultSet;
    }

}
