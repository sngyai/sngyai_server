<?php
/**
 * Created by IntelliJ IDEA.
 * User: sngyai
 * Date: 14-9-25
 * Time: 上午2:46
 */

class DbExchangeAction extends CommonAction{
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
            $this->_list($model, $map, $sortBy = 'sum', $asc = false, $countPk = 'id');
        }
        $this->display();
        return;
    }
} 