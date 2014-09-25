<?php
/**
 * Created by IntelliJ IDEA.
 * User: sngyai
 * Date: 14-9-24
 * Time: 下午8:51
 */

class DbTaskLogAction extends CommonAction{
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
}