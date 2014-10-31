<?php
/**
 * Created by IntelliJ IDEA.
 * User: sngyai
 * Date: 14-9-27
 * Time: 下午9:17
 */

class DbExchangeAction extends CommonAction{
    function exchange()
    {
        //审核指定记录
        $name = $this->getActionName();

        $model = D($name);
        $pk = $model->getPk();
        $id = $_GET [$pk];

        $condition = array($pk => array('in', $id));
        if (false !== $model->exchange($condition)) {
            $this->assign("jumpUrl", $this->getReturnUrl());
            $this->success('审核成功！');
        } else {
            $this->error('审核失败！');
        }
       // header("Location:http://127.0.0.1/back/Admin/#Exchange");
    }
} 