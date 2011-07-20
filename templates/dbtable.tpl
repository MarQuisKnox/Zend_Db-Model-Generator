<?="<?php\n"?>
/**
 * This file is automatically generated from the database schema by:
 * https://github.com/MarQuisKnox/Zend_Db-model-generator
 * 
 * @author <?=$this->_author."\n"?>
 * @copyright <?=$this->_copyright."\n"?>
 * @license <?=$this->_license."\n"?>
 */

<? if ($this->_addRequire): ?>

require_once('Zend<?=DIRECTORY_SEPARATOR?>Db<?=DIRECTORY_SEPARATOR?>Table<?=DIRECTORY_SEPARATOR?>Abstract.php');
<? endif; ?>
require_once('<?=$this->_namespace?>.php');

class <?=$this->_namespace?>_Generated_Model_DbTable_<?=$this->_className?> extends <?=$this->_namespace?>_Generated_DbTable
{
        /**
         * $_name - name of database table
         *
         * @var string
         */
	protected $_name='<?=$this->_tbname?>';

        /**
         * $_id - this is the primary key name

         *
         * @var string

         */
	protected $_id='<?=$this->_primaryKey['field']?>';

        <?=$referenceMap?>

}
