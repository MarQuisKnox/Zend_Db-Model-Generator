<?php
require_once('UserMapper.php');
require_once('MainModel.php');

/**
 * Add your description here
 *
 * @author Kfir Ozer
 * @copyright ZF model generator
 * @license http://framework.zend.com/license/new-bsd     New BSD License
 */
 
class Default_Model_User extends MainModel
{

    /**
     * mysql var type int(10) unsigned
     *
     * @var int     
     */
    protected $_Id;
    
    /**
     * mysql var type varchar(20)
     *
     * @var string     
     */
    protected $_Name;
    

    

function __construct() {
    $this->setColumnsList(array(
    'id'=>'Id',
    'name'=>'Name',
    ));
}

	
    
    /**
     * sets column id type int(10) unsigned     
     *
     * @param int $data
     * @return Default_Model_User     
     *
     **/

    public function setId($data)
    {
        $this->_Id=$data;
        return $this;
    }

    /**
     * gets column id type int(10) unsigned
     * @return int     
     */
     
    public function getId()
    {
        return $this->_Id;
    }
    
    /**
     * sets column name type varchar(20)     
     *
     * @param string $data
     * @return Default_Model_User     
     *
     **/

    public function setName($data)
    {
        $this->_Name=$data;
        return $this;
    }

    /**
     * gets column name type varchar(20)
     * @return string     
     */
     
    public function getName()
    {
        return $this->_Name;
    }
    
    /**
     * returns the mapper class
     *
     * @return Default_Model_UserMapper
     *
     */

    public function getMapper()
    {
        if (null === $this->_mapper) {
            $this->setMapper(new Default_Model_UserMapper());
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
        if (!$this->getId())
            throw new Exception('Primary Key does not contain a value');
        return $this->getMapper()->getDbTable()->delete('id = '.$this->getId());
    }

}

