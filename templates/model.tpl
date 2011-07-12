<?="<?php\n"?>
<? if ($this->_addRequire):?>
require_once('<?=$this->_className?>Mapper.php');
<? endif; ?>
require_once('MainModel.php');

/**
 * Add your description here
 *
 * @author <?=$this->_author."\n"?>
 * @copyright <?=$this->_copyright."\n"?>
 * @license <?=$this->_license."\n"?>
 */
 
class <?=$this->_namespace?>_Model_<?=$this->_className?> extends MainModel
{

<?foreach ($this->_columns as $column):?>
    /**
     * mysql var type <?=$column['type']?>

     *
     * @var <?=$column['phptype']?>
     
     */
    protected $_<?=$column['capital']?>;
    
<?endforeach;?>

    

function __construct() {
    $this->setColumnsList(array(
<?foreach ($this->_columns as $column):?>
    '<?=$column['field']?>'=>'<?=$column['capital']?>',
<?endforeach;?>
    ));
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

}

