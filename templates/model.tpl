<?php echo  "<?php\n"; ?>
<?php if ($this->_addRequire): ?>
require_once('<?php echo  $this->_className; ?>Mapper.php');
<?php endif; ?>
require_once('MainModel.php');

/**
* Add your description here
*
* @author <?php echo  $this->_author . "\n"; ?>
* @copyright <?php echo  $this->_copyright . "\n"; ?>
* @license <?php echo  $this->_license . "\n"; ?>
*/
class <?php echo  $this->_namespace; ?>_Model_<?php echo  $this->_className; ?> extends MainModel
{

    <?php foreach ($this->_columns as $column): ?>
/**
    * mysql var type <?php echo  $column['type']; ?>
    
    * @var <?php echo  $column['phptype']; ?>
    
    */
    protected $_<?php echo  $column['capital']; ?>;

    <?php endforeach; ?>

    public function __construct()
    {
        $this->setColumnsList(array(
        <?php foreach ($this->_columns as $column): ?>
        '<?php echo  $column['field']; ?>'=>'<?php echo  $column['capital']; ?>',
        <?php endforeach; ?>
        ));
    }

<?php foreach ($this->_columns as $column): ?>
    /**
    * sets column <?php echo  $column['field']; ?> type <?php echo  $column['type']; ?>
    
    *
    * @param <?php echo  $column['phptype']; ?> $data
    * @return <?php echo  $this->_namespace; ?>_Model_<?php echo  $this->_className; ?>

    *    
    */
    public function set<?php echo  $column['capital']; ?>($data)
    {
        $this->_<?php echo  $column['capital']; ?>=$data;
        return $this;
    }

    /**
    * gets column <?php echo  $column['field']; ?> type <?php echo  $column['type']; ?>

    * @return <?php echo  $column['phptype']; ?>
    
    */
    public function get<?php echo  $column['capital']; ?>()
    {
        return $this->_<?php echo  $column['capital']; ?>;
    }
    
<?php endforeach; ?>

    /**
    * returns the mapper class
    *
    * @return <?php echo  $this->_namespace; ?>_Model_<?php echo  $this->_className; ?>Mapper
    *
    */
    public function getMapper()
    {
        if (null === $this->_mapper) {
            $this->setMapper(new <?php echo  $this->_namespace; ?>_Model_<?php echo  $this->_className; ?>Mapper());
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
        if (!$this->get<?php echo  $this->_primaryKey['capital']; ?>()) {
            throw new Exception('Primary Key does not contain a value');
        }
        return $this->getMapper()
                    ->getDbTable()
                    ->delete('<?php echo  $this->_primaryKey['field']; ?> = '.$this->get<?php echo  $this->_primaryKey['capital']; ?>());
    }
}