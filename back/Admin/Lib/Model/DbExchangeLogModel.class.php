<?php
/**
 * Created by IntelliJ IDEA.
 * User: sngyai
 * Date: 14-9-25
 * Time: 下午11:03
 */

class DbExchangeLogModel extends CommonModel{
    public function exchange($options, $field = 'status')
    {
        $now = time();
        $data = array($field=>1,'last_update'=>$now);
        if (FALSE === $this->where($options)->setField($data)) {
            echo $options;
            $this->error = L('_OPERATION_WRONG_');
            return false;
        } else {
            return True;
        }
    }

    public function cancel_exchange($options, $field = 'status')
    {
        $data = array($field=>0,'last_update'=>$now);
        if (FALSE === $this->where($options)->setField($data)) {
            $this->error = L('_OPERATION_WRONG_');
            return false;
        } else {
            return True;
        }
    }
}

