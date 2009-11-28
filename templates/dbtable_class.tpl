<?php
abstract class MainDbTable extends Zend_Db_Table_Abstract {
        /**
         * $_name - name of database table
         *
         * @var string
         */
	protected $_name;

        /**
         * $_id - this is the primary key name

         *
         * @var string

         */
	protected $_id;

        /**
         * returns the primary key column name
         *
         * @var string
         */
        public function getPrimaryKeyName() {
            return $this->_id;
        }

    /**
     * returns the number of rows in the table
     * @var int
     */
        public function countAllRows() {
            $query = $this->select()->from($this->_name, 'count(*) as all_count');
            $numRows = $this->fetchRow($query);
            return $numRows['all_count'];
        }

        public function countByQuery($where='') {

            if ($where)
                $where='where '.$where;

            $query = <<<SQL
                select count(*) as all_count from {$this->_name} $where
SQL;
            $row=$this->getAdapter()->query($query)->fetch();

            return $row['all_count'];
        }

}