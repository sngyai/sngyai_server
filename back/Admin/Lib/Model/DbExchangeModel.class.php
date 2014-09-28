<?php
/**
 * Created by IntelliJ IDEA.
 * User: sngyai
 * Date: 14-9-27
 * Time: 下午8:59
 */

class DbExchangeModel extends CommonModel {
    public function exchange($options, $field = 'status')
    {
        $now = time();
        $data = array($field=>1,'sum'=>0,'last_update'=>$now);
        if (FALSE === $this->where($options)->setField($data)) {
            echo $options;
            $this->error = L('_OPERATION_WRONG_');
            return false;
        } else {
            return True;
        }
    }
} 