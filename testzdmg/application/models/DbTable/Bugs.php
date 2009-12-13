<?php
require_once('Zend/Db/Table/Abstract.php');
require_once('MainDbTable.php');
/**
 * Add your description here
 * 
 * @author Kfir Ozer
 * @copyright ZF model generator
 * @license http://framework.zend.com/license/new-bsd     New BSD License
 */

class Default_Model_DbTable_Bugs extends MainDbTable
{
        /**
         * $_name - name of database table
         *
         * @var string
         */
	protected $_name='bugs';

        /**
         * $_id - this is the primary key name

         *
         * @var string

         */
	protected $_id='bug_id';

        protected $_referenceMap    = array(

                   'BugsIbfk1' => array(
                       'columns' => 'reported_by',
                       'refTableClass' => 'Accounts',
                       'refColumns' =>  'account_name'
                           ),
                   'BugsIbfk2' => array(
                       'columns' => 'assigned_to',
                       'refTableClass' => 'Accounts',
                       'refColumns' =>  'account_name'
                           ),
                   'BugsIbfk3' => array(
                       'columns' => 'verified_by',
                       'refTableClass' => 'Accounts',
                       'refColumns' =>  'account_name'
                           )          
                );
}


