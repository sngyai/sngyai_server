<?php
/**
 * Created by IntelliJ IDEA.
 * User: sngyai
 * Date: 14-9-25
 * Time: 上午12:13
 */

class DbExchangeLogAction extends CommonAction{
    public function index()
    {
        //列表过滤器，生成查询Map对象
        $map = $this->_search();
        if (method_exists($this, '_filter')) {
            $this->_filter($map);
        }
        $name = $this->getActionName();
        $model = D($name);

        if (!empty ($model)) {
            $this->_list($model, $map, $sortBy = 'time', $asc = false, $countPk = 'user_id');
        }
        $this->display();
        return;
    }

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
    }

    public function cancel_exchange()
    {
        $name = $this->getActionName();
        $model = D($name);
        $pk = $model->getPk();
        $id = $_REQUEST [$pk];
        $condition = array($pk => array('in', $id));
        $list = $model->cancel_exchange($condition);
        if ($list !== false) {
            $this->assign("jumpUrl", $this->getReturnUrl());
            $this->success('撤销成功');
        } else {
            $this->error('撤销失败！');
        }
    }
}


