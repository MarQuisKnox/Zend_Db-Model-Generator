<?php
require_once('BugsMapper.php');
require_once('MainModel.php');

/**
 * Add your description here
 *
 * @author Kfir Ozer
 * @copyright ZF model generator
 * @license http://framework.zend.com/license/new-bsd     New BSD License
 */
 
class Default_Model_Bugs extends MainModel
{

    /**
     * mysql var type int(11)
     *
     * @var int     
     */
    protected $_BugId;
    
    /**
     * mysql var type varchar(100)
     *
     * @var string     
     */
    protected $_BugDescription;
    
    /**
     * mysql var type varchar(20)
     *
     * @var string     
     */
    protected $_BugStatus;
    
    /**
     * mysql var type varchar(100)
     *
     * @var string     
     */
    protected $_ReportedBy;
    
    /**
     * mysql var type varchar(100)
     *
     * @var string     
     */
    protected $_AssignedTo;
    
    /**
     * mysql var type varchar(100)
     *
     * @var string     
     */
    protected $_VerifiedBy;
    

    

function __construct() {
    $this->setColumnsList(array(
    'bug_id'=>'BugId',
    'bug_description'=>'BugDescription',
    'bug_status'=>'BugStatus',
    'reported_by'=>'ReportedBy',
    'assigned_to'=>'AssignedTo',
    'verified_by'=>'VerifiedBy',
    ));
}

	
    
    /**
     * sets column bug_id type int(11)     
     *
     * @param int $data
     * @return Default_Model_Bugs     
     *
     **/

    public function setBugId($data)
    {
        $this->_BugId=$data;
        return $this;
    }

    /**
     * gets column bug_id type int(11)
     * @return int     
     */
     
    public function getBugId()
    {
        return $this->_BugId;
    }
    
    /**
     * sets column bug_description type varchar(100)     
     *
     * @param string $data
     * @return Default_Model_Bugs     
     *
     **/

    public function setBugDescription($data)
    {
        $this->_BugDescription=$data;
        return $this;
    }

    /**
     * gets column bug_description type varchar(100)
     * @return string     
     */
     
    public function getBugDescription()
    {
        return $this->_BugDescription;
    }
    
    /**
     * sets column bug_status type varchar(20)     
     *
     * @param string $data
     * @return Default_Model_Bugs     
     *
     **/

    public function setBugStatus($data)
    {
        $this->_BugStatus=$data;
        return $this;
    }

    /**
     * gets column bug_status type varchar(20)
     * @return string     
     */
     
    public function getBugStatus()
    {
        return $this->_BugStatus;
    }
    
    /**
     * sets column reported_by type varchar(100)     
     *
     * @param string $data
     * @return Default_Model_Bugs     
     *
     **/

    public function setReportedBy($data)
    {
        $this->_ReportedBy=$data;
        return $this;
    }

    /**
     * gets column reported_by type varchar(100)
     * @return string     
     */
     
    public function getReportedBy()
    {
        return $this->_ReportedBy;
    }
    
    /**
     * sets column assigned_to type varchar(100)     
     *
     * @param string $data
     * @return Default_Model_Bugs     
     *
     **/

    public function setAssignedTo($data)
    {
        $this->_AssignedTo=$data;
        return $this;
    }

    /**
     * gets column assigned_to type varchar(100)
     * @return string     
     */
     
    public function getAssignedTo()
    {
        return $this->_AssignedTo;
    }
    
    /**
     * sets column verified_by type varchar(100)     
     *
     * @param string $data
     * @return Default_Model_Bugs     
     *
     **/

    public function setVerifiedBy($data)
    {
        $this->_VerifiedBy=$data;
        return $this;
    }

    /**
     * gets column verified_by type varchar(100)
     * @return string     
     */
     
    public function getVerifiedBy()
    {
        return $this->_VerifiedBy;
    }
    
    /**
     * returns the mapper class
     *
     * @return Default_Model_BugsMapper
     *
     */

    public function getMapper()
    {
        if (null === $this->_mapper) {
            $this->setMapper(new Default_Model_BugsMapper());
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
        if (!$this->getBugId())
            throw new Exception('Primary Key does not contain a value');
        return $this->getMapper()->getDbTable()->delete('bug_id = '.$this->getBugId());
    }

}

