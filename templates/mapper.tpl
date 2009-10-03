<?="<?php\n"?>
<? if ($this->_addRequire):?>
require_once("DbTable<?=DIRECTORY_SEPARATOR?><?=$this->_className?>.php");
<? endif?>

class <?=$this->_namespace?>_Model_<?=$this->_className?>Mapper {

    protected $_dbTable;

	public function findByField($field, $value, $cls)
	{
		$table = $this->getDbTable();
		$select = $table->select();
		
		$row = $table->fetchRow($select->where("{$field} = ?", $value));
		if (0 == count($row)) {
			return;
		}
		
		$cls<?$count=count($this->_columns); foreach ($this->_columns as $column): $count--?>->set<?=$this->_getCapital($column)?>($row-><?=$column?>)<?if ($count> 0) echo "\n\t\t"; endforeach;?>;

	}
    
    public function setDbTable($dbTable)
    {
        if (is_string($dbTable)) {
            $dbTable = new $dbTable();
        }
        if (!$dbTable instanceof Zend_Db_Table_Abstract) {
            throw new Exception("Invalid table data gateway provided");
        }
        $this->_dbTable = $dbTable;
        return $this;
    }

    public function getDbTable()
    {
        if (null === $this->_dbTable) {
            $this->setDbTable("<?=$this->_namespace?>_Model_DbTable_<?=$this->_className?>");
        }
        return $this->_dbTable;
    }

    public function save(<?=$this->_namespace?>_Model_<?=$this->_className?> $cls) {
        $data = array(
  	<?foreach ($this->_columns as $column):?>
            <?=$column?> => $cls->get<?=$this->_getCapital($column)?>(),
	<?endforeach;?>
        );

       if (null === ($id = $cls->get<?=$this->_capitalPrimaryKey?>())) {
            unset($data["<?=$this->_primaryKey?>"]);
            $id=$this->getDbTable()->insert($data);
            $cls->set<?=$this->_capitalPrimaryKey?>($id);
        } else {
            $this->getDbTable()->update($data, array("<?=$this->_primaryKey?> = ?" => $id));
        }
     }

    public function find($id, <?=$this->_namespace?>_Model_<?=$this->_className?> $cls) {
        $result = $this->getDbTable()->find($id);
        if (0 == count($result)) {
            return;
        }

        $row = $result->current();

        $cls<?$count=count($this->_columns); foreach ($this->_columns as $column): $count--?>->set<?=$this->_getCapital($column)?>($row-><?=$column?>)<?if ($count> 0) echo "\n\t\t"; endforeach;?>;
    }

    public function fetchAll()
    {
        $resultSet = $this->getDbTable()->fetchAll();
        $entries   = array();
        foreach ($resultSet as $row) {
            $entry = new <?=$this->_namespace?>_Model_<?=$this->_className?>();
            $entry<?foreach ($this->_columns as $column): $count--?>->set<?=$this->_getCapital($column)?>($row-><?=$column?>)
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
                        $entry<?foreach ($this->_columns as $column):?>->set<?=$this->_getCapital($column)?>($row-><?=$column?>)
                              <? endforeach;?>
    ->setMapper($this);
                        $entries[] = $entry;
                }
                return $entries;
        }


}
