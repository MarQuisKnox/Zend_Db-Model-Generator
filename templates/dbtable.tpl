<?="<?php\n"?>
<? if ($this->_addRequire): ?>
require_once('Zend<?=DIRECTORY_SEPARATOR?>Db<?=DIRECTORY_SEPARATOR?>Table<?=DIRECTORY_SEPARATOR?>Abstract.php');
<? endif; ?>

class <?=$this->_namespace?>_Model_DbTable_<?=$this->_className?> extends Zend_Db_Table_Abstract
{
	protected $_name='<?=$this->_tbname?>';
	protected $_id='<?=$this->_primaryKey?>';

}

