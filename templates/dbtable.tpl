<?php echo "<?php\n"; ?>
<? if ($this->_addRequire): ?>
require_once('Zend<?php echo  DIRECTORY_SEPARATOR .'Db'. DIRECTORY_SEPARATOR .'Table'. DIRECTORY_SEPARATOR; ?>Abstract.php');
<? endif; ?>
    require_once('MainDbTable.php');
    /**
    * Add your description here
    *
    * @author <?php echo $this->_author . "\n"; ?>
    * @copyright <?php echo $this->_copyright . "\n"; ?>
    * @license <?php echo $this->_license . "\n"; ?>
    */

class <?php echo  $this->_namespace; ?>_Model_DbTable_<?php echo $this->_className; ?> extends MainDbTable
{
    /**
    * $_name - name of database table
    *
    * @var string
    */
   	protected $_name='<?php echo $this->_tbname; ?>';

    /**
    * $_id - this is the primary key name
    *
    * @var string
    */
    protected $_id='<?php echo $this->_primaryKey['field']; ?>';

<?php echo $referenceMap; ?>
}