// index.js
;
var DATA = {},
	ITEMS = {},
	APPEAL = {},
	IMPLIST_CID = [],
	IMPLIST_TR = [],
	UNIT = '奖励',
	POINT_SUFFIX = '',
	M_NAME = '',
	NULL_CONTENT = '暂时没有广告，<br/>请稍后重试',
	PAGESIZE = 10,
	MAX_SDK_DELAY = 11*1000, // 11 second in ms
	MAX_DATA_AGE = 600*1000, // 600 second in ms
	UPDATE_TIME = new Date(), 
	DEV = false;

var __lastInitRequest;
function initTemplate(){
	DEV&&console.log('__lastInitRequest',__lastInitRequest);
	if(__lastFetchXHR && typeof __lastFetchXHR.abort == "function") __lastFetchXHR.abort();
	if(__lastInitRequest && typeof __lastInitRequest.abort == "function") __lastInitRequest.abort();
	$('#extra_div').hide();
	// $('#more_game').show().addClass('loading');
	lastY=0;
	fetchableCids = [];
	__fetchingGameList=[];
	// $('#gamelist').empty().append('<li id="first_load"><div id="msgs" class="loading"></div></li>');
	__lastInitRequest = __sdk('initTemplate', {'callback':'initTemplateCallback'});
}
function initTemplateCallback (jsonObj) {
	delete __lastInitRequest;
	__lastInitRequest = null;
	DATA = jsonObj;
	UNIT = DATA && DATA.unit_name || UNIT;
	$('#gamelist').empty();
	init();
	delete DATA;
	DATA = {};
}
function init(){
	//清空 展示报告列表、item map
	IMPLIST_CID = [];
	IMPLIST_TR = [];
	ITEMS = {};

	if(!(DATA&&DATA.control)){
		__showMsg();
		return
	}
	UNIT = DATA.unit_name || UNIT;
	M_NAME = DATA.m_name || M_NAME;
	PAGESIZE = DATA.control.pagesize || PAGESIZE;
	MAX_DATA_AGE = DATA.control.max_data_age || MAX_DATA_AGE;
	POINT_SUFFIX = DATA.point_suffix || POINT_SUFFIX;
	if(M_NAME)$('.m_name').html(M_NAME);
	$('.unit').html(UNIT);

	// DATA.control.appeal_enable = false;

	var tmpList = [];
	$('#gamelist').empty();
	if(!(DATA.list && __alterList(DATA.list, 'game'))){
		__showMsg(NULL_CONTENT);
	}
	if(!(DATA.signin_list && __alterList(DATA.signin_list, 'open', true))){
		$('#open_wrapper').hide();
	}
	$('#donelist').empty();
	if(!(DATA.rec_list && __alterList(DATA.rec_list, 'done', true))){
		$('#done_wrapper').hide();
	}
	if(!DATA.control.appeal_enable){
		$('#btn_repo').hide();
	}
	if(DATA.control.video_entrance){
		$('#video_wrapper').show();
	}
	if(!DATA.control.floating_enable){
	}
	if(DATA.control.floating_enable && DATA.floating){
		$('#pich')
			.css('display', 'block')
			.attr('href', DATA.floating.target_url)
			.find('span')
				.css('background-image', 'url('+DATA.floating.entry_img+')');
	}
	$('#first_load').remove();
	setTimeout(reportImp, 1000);
	__showPage();
	UPDATE_TIME = new Date();
	$('#last_pull_time').html('上次刷新：'+UPDATE_TIME.getFullYear()+'-'+towDigi(UPDATE_TIME.getMonth()+1)+'-'+towDigi(UPDATE_TIME.getDate())+" "+towDigi(UPDATE_TIME.getHours())+":"+towDigi(UPDATE_TIME.getMinutes())+":"+towDigi(UPDATE_TIME.getSeconds()))
}
function reportImp(){
	// __sdk('fired', {type:'imp','cids':IMPLIST_CID.join(','), 'trs':IMPLIST_TR.join(',')});
}
function towDigi(num){
	return ('0'+num).substr(-2);
}

var fetchableCids = [];
function __alterList (list, listName, action_string) {
	var tmpList = [], tmpFetchable = [];
	for (var i = 0; i < list.length ; i++) {
		if(typeof list[i] === "string"){
			DEV&&console.log(list[i]);
			tmpFetchable.push(list[i]);
			continue;
		}
		if(!list[i].installed){
			ITEMS[list[i].cid] = list[i];
			// list[i].file_url += '&id='+ list[i].cid;
			list[i].opendetails = !!list[i].detail;
			tmpList.push(list[i]);
			IMPLIST_CID.push(list[i].cid);
			IMPLIST_TR.push(list[i].tr);
		}
	};
	if(listName=="game")fetchableCids = fetchableCids.concat(tmpFetchable);

	$('#'+listName+'list').append(__buildItems(tmpList, action_string));
	return tmpList.length>0;
}
function __showMsg(msg) {
	$('#more_game').hide();
	$('#extra_div').hide();
	$('#gamelist').empty().append('<li><div id="msgs"><p class="empty">'+(msg?msg:'亲，您的网络好像有问题哦，<br/>请检查网络连接或下拉刷新重试。')+'</p><p><button class="btn_refresh ac_refresh" type="button">刷新</button></p></div></li>');
	__showPage();
}
function __showLog(msg) {
	$('#gamelist').prepend('<li><div id="msgs"><p class="empty">'+(msg?msg:'亲，您的网络好像有问题哦，<br/>请检查网络连接或下拉刷新重试。')+'</p><p><button class="btn_refresh ac_refresh" type="button">刷新</button></p></div></li>');
	__showPage();
}
var __refreshTimeout;
var __refresh =  window.refresh = function(msg) {
	window.location.reload();
}
var scroll_list,scroll_help,scroll_repo, __scale = 1;
var lastY=0, __pullDownOffset=0;
function __showPage() {
	DEV&&console.log('CH',document.documentElement.clientHeight);
	DEV&&console.log('LH',$('#game_scroller').height());
	var $view = $('#game_scroller'),
		pullDownEl = $view.find('pulldown').css('display', 'block'),
		viewHeight = $view.height(),
		itemHeight = 1000;

	if(fetchableCids.length){
		if($('#gamelist').find('li').length>1){

			itemHeight = $('#gamelist').find('li').eq(1).height();

			if(viewHeight>PAGESIZE*itemHeight){
				PAGESIZE = parseInt(viewHeight/itemHeight)+1;
			}
		}
	}else{
		if($('#gamelist').find('li').length>1){
			$('#more_game').hide();
			$('#extra_div').show();
		}else{
			$('#more_game').hide();
			$('#extra_div').hide();
		}
	}

	if(scroll_status){scroll_status.refresh()}
	if(scroll_list && scroll_help){
		scroll_list.refresh();
		scroll_help.refresh();
		scroll_repo.refresh();

		setTimeout(fetchGameList, 0);
		return;
	} 
	// scroll_list = new iScroll('game_scroller', {"bounce":false});
	scroll_help = new iScroll('help_scroller', {"vScrollbar": false, "hScrollbar": false, "bounce": true});
	scroll_repo = new iScroll('report_scroller', {"vScrollbar": false, "hScrollbar": false, "bounce": true,
		 onBeforeScrollStart: function (e) {
			var target = e.target;
			while (target.nodeType != 1) target = target.parentNode;

			if (target.tagName != 'SELECT' && target.tagName != 'INPUT' && target.tagName != 'TEXTAREA' && target.tagName != 'OPTION')
				e.preventDefault();
		}});
	
	__pullDownOffset = pullDownEl.height();
	lastY = -__pullDownOffset;

	scroll_list = new iScroll('game_scroller', {
		"useTransition": true,
		"vScrollbar": false,
		"hScrollbar": false,
		"topOffset": __pullDownOffset,
		"onRefresh": function () {
			pullDownEl.removeClass('loading');
		},
		"onScrollMove": function () {
			if (this.y > 5 && !pullDownEl.is('.flip')&& !pullDownEl.is('.loading')) {
				pullDownEl[0].className = 'flip';
				this.minScrollY = 0;
			} else if (this.y < 5 && pullDownEl.is('.flip')) {
				pullDownEl.removeClass('flip');
				this.minScrollY = -__pullDownOffset;
			}
			if(this.y<lastY){
				lastY = fetchGameList()?this.y: lastY;
			};
		},
		"onScrollEnd": function () {
			if (pullDownEl.is('.flip')) {
				pullDownEl[0].className = 'loading';

				$('#more_game').hide();
				initTemplate();
			}
			DEV&&console.log(lastY-viewHeight, this.y);
			if(this.y<lastY-viewHeight/3){
				lastY = fetchGameList()?this.y: lastY;
			};
		},
		 "onBeforeScrollStart": function (e) {
			var target = e.target;
			while (target.nodeType != 1) target = target.parentNode;

			if (target.tagName != 'SELECT' && target.tagName != 'INPUT' && target.tagName != 'TEXTAREA' && target.tagName != 'OPTION')
				e.preventDefault();
		}
	});
	
	setTimeout(fetchGameList, 0);
}
var __fetchingGameList = [], f=0, __lastFetchXHR;
function fetchGameList () {
	if(__fetchingGameList.length||!!__lastFetchXHR||!!__lastInitRequest||!fetchableCids.length)return false;
	DEV&&console.log('fetchGameList enter:', fetchableCids);

	$('#more_game').show().addClass('loading');
	DEV&&console.log(fetchableCids, PAGESIZE);

	__fetchingGameList = fetchableCids.splice(0, PAGESIZE);

	var options = {
		cids: __fetchingGameList,
		lastrank: $('#gamelist').find('li').length,
		callback: 'fetchGameListCallBack'
	};
	IMPLIST_CID = [];
	IMPLIST_TR = [];
	DEV&&console.log('fetchCreatives:', options.cids);
	__lastFetchXHR = __sdk('fetchCreatives', options);
	DEV&&console.log('fetched:',f++);

	return true;
}
function fetchGameListCallBack (data) {
	delete __lastFetchXHR;
	__lastFetchXHR = null;
	DEV&&console.log('fetchGameListCallBack',data);

	$('#more_game').removeClass('loading');

	if(data.error && data.error.code != 4000 ){
		fetchableCids = fetchableCids.concat(__fetchingGameList);
	}
	if(((data.error && data.error.code != 4000 )||!fetchableCids.length)&& $('#gamelist').find('li').length>1){
		$('#extra_div').show();
	}
	if(!fetchableCids.length){
		$('#more_game').hide();
	}
	__fetchingGameList = [];

	data && data.list && __alterList(data.list, 'game');
	scroll_list.refresh();
	setTimeout(reportImp, 1000);
	DEV&&console.log('fetchableCids', fetchableCids);
}

function __buildTag(tag) {
	return tag?'<span class="tag">'+tag+'</span>':'';

	// switch(tag){
	// 	case 1:
	// 		return '<span class="tag new">最新</span>';
	// 	case 2:
	// 		return '<span class="tag hot">热门</span>';
	// 	case 3:
	// 		return '<span class="tag first">首发</span>';
	// 	case 4:
	// 		return '<span class="tag exclusive">独家</span>';
	// 	default:
	// 		return '';
	// }
}

function __buildItems(items, nodetail, action_string) {
	if(!items.length) return '';

	var tmp = [], tagHTML;
	for(var i=0; i< items.length; i++){
		if(action_string)items[i].action_string = action_string;
		if(nodetail)items[i].opendetails = false;
		tagHTML = __buildTag(items[i].subscript);

		tmp.push(['<li class="shadow_before '+(items[i].opendetails?'ac_go_detail':'ac_do_action')+'" srv="'+items[i].cid+'">',
					'<div class="game_banner">',
						'<span href="javascript:void(0)" class="link_detail">', 
							'<img class="game_icon" alt="'+items[i].name+'" src="'+items[i].logo+'">',
						'</span>',
						'<h4 class="game_name">'+items[i].name+tagHTML+'</h4>',
						'<p class="intor">'+items[i].texts[0]+'</p>',
						'<p class="todo">'+items[i].texts[1]+'</p>',
					'</div>',
					'<div class="download_info">',
						'<p class="points">'+items[i].point+POINT_SUFFIX+'</p>',
						'<span class="unit">'+UNIT+'</span>',
						'<span class="link_go hidden" srv="'+items[i].file_url+'" href="javascript:void(0);">'+items[i].action_string+'</span>',
					'</div>',
				'</li>'].join(''));
	}
	return tmp.join('');
}



function ALERTER(options) {
	if(!(this instanceof ALERTER)){
		return new ALERTER(options);
	}

	if(window.__alerter && window.__alerter.close){
		window.__alerter.close(false);
	}
	options = $.extend({
		"title": '抱歉…',
		"content": '',
		"onConfirm": undefined,
		"onClose": undefined,
		"afterConfirm": undefined,
		"afterClose": undefined
	}, options);
	options.button = $.extend({
		"content": '<span>好的</span>',
		"class": 'btn_default',
		"href": 'javascript:void(0);'
	}, options.button);

	options.$alerter = $('#alerter_wrapper');

	options.$alerter.find('.alerter_title').html(options.title);
	options.$alerter.find('.alerter_content').html(options.content);
	options.$closer = options.$alerter.find('.closer').unbind().on('touchend',function(){
		window.__alerter.close();
	});
	options.$confirmer = options.$alerter.find('.action .btn');
	options.$confirmer
		.html(options.button.content)
		.attr('class', 'btn '+ options.button.class)
		.attr('href', options.button.href)
		.unbind()
		.click(function(){
			window.__alerter.confirm();
		});

	options.$alerter.fadeIn(100);
	window.__alerter = $.extend(this, options);
	return window.__alerter;
}
$.extend(ALERTER.prototype, {
	"__out": function(type, fade){
		var thisAlerter = this;
		function afterHide(){
			if(typeof thisAlerter['after'+type] == 'function'){
				thisAlerter['after'+type].call(thisAlerter);
			}
			delete window.__alerter;
			window.__alerter = null;
		}
		fade = (fade===undefined || !!fade);
		if(fade){
			this.$alerter.fadeOut(100, afterHide);
		}else{
			this.$alerter.hide();
			afterHide();
		}
	},
	"close": function(fade){
		if(typeof this.onClose == 'function'){
			var thisAlerter = this;
			this.onClose.call(this, function(){
				thisAlerter.__out('close', fade);
			});
		}else{
			this.__out('close', fade);
		}
	},
	"confirm": function(fade){
		if(typeof this.onConfirm == 'function'){
			var thisAlerter = this;
			// this.loading();
			this.onConfirm.call(this, function(){
				thisAlerter.__out('confirm', fade);
			});
		}else{
			this.__out('confirm', fade);
		}
	},
	"loading": function(){
		this.$confirmer.html('<span class="loading"></span>');
	}
});

function __openDetail(target) {
	var app_id = $(target).attr('srv'), 
		item = ITEMS[app_id]||{},
		tmpHTML,
		tagHTML,
		thumbHTML = '';
	if(!item.cid)return;

	ALERTER({
		"title": ['<div class="game_banner">',
					'<span class="link_detail">', 
						'<img class="game_icon" alt="" src="'+item.logo+'">',
					'</span>',
					'<h4 class="game_name">'+item.name+'</h4>',
					'<p class="intor">'+item.texts[0]+'</p>',
				'</div>'].join(''),
		"content": item.detail.replace(/\n/g,'<br/>'), //+'<p>完成上述步骤，半小时内获得积分</p>'
		"button": {
			"content": '<span>赚取</span> '+item.point+POINT_SUFFIX+' <span class="unit">'+UNIT+'</span>',
			"class": 'btn_default',
			"href": 'javascript:void(0)'
			// "href": item.file_url
		},
		"onConfirm":function (next) {
			next();
			__sdk('fired', {type:'click','cids':item.cid, 'trs':item.tr});
		},
		"onClose":function (next) {
			next();
			__sdk('fired', {type:'cancel','cids':item.cid, 'trs':item.tr});
		}
	});
}
function __openStatus() {
	if(scroll_status){scroll_status.refresh()}
	$('#status').css('marginLeft',0);
	$('#status_scroller .status_body').empty().append('<div class="msg"><span class="icon icon_loading"></span></div>');

	setTimeout(function(){__sdk('initStatus', {"callback": 'initStatusCallback'});}, 1000);
}
var scroll_status;
function initStatusCallback(data){
	// var data = {
	// 		"control": {
	// 			"pagesize": 3
	// 		},
	// 		"list": [
	// 			{
	// 				"cid": 10299,
	// 				"desc": "下载使用三分钟获奖",
	// 				"image": "http://domob-inc.cn:8080/ugc/22642.png",
	// 				"point": 143,
	// 				"state": 0,
	// 				"title": "找你妹",
	// 				"unit": "金币"
	// 			},
	// 			{
	// 				"cid": 10300,
	// 				"desc": "下载使用三分钟获奖",
	// 				"image": "http://domob-inc.cn:8080/ugc/22642.png",
	// 				"point": 143,
	// 				"state": 1,
	// 				"title": "找你妹1",
	// 				"unit": "金币"
	// 			},
	// 			{
	// 				"cid": 10301,
	// 				"desc": "下载使用三分钟获奖",
	// 				"image": "http://domob-inc.cn:8080/ugc/22642.png",
	// 				"point": 143,
	// 				"state": 2,
	// 				"title": "找你妹2",
	// 				"unit": "金币"
	// 			},
	// 			{
	// 				"cid": 10302,
	// 				"desc": "下载使用三分钟获奖",
	// 				"image": "http://domob-inc.cn:8080/ugc/22642.png",
	// 				"point": 143,
	// 				"state": 0,
	// 				"title": "找你妹3",
	// 				"unit": "金币"
	// 			},
	// 			{
	// 				"cid": 10303,
	// 				"desc": "下载使用三分钟获奖",
	// 				"image": "http://domob-inc.cn:8080/ugc/22642.png",
	// 				"point": 143,
	// 				"state": 0,
	// 				"title": "找你妹4",
	// 				"unit": "金币"
	// 			}
	// 		]
	// 	};
	
	$('#status_scroller .status_body').empty().append(__buildStatusItems((data&&data.list)?data.list:[]));
	
	if(data&&data.list&&data.list.length>3){
		$('#status_list').append('<li id="more_status" class="more_box"><div class="more"><span class="icon icon_more"></span> <em>查看更多</em></div></li>');
	}
	if(scroll_status){
		scroll_status.refresh();
	}else{
		scroll_status = new iScroll('status_scroller', {"vScrollbar": false, "hScrollbar": false, "bounce": true});
	}
}
function __buildStatusItems(items) {
	if(!items.length) return '<div class="msg">亲，您当前没有可查看的奖励，<br/>返回上一页开始做任务吧</div>';

	var tmp = ['<ul id="status_list">'], tagHTML;
	for(var i=0; i< items.length; i++){
		tagHTML = __buildStatusTag(items[i].state);	

		tmp.push(['<li'+(i>2?' style="display:none"':'')+'>',
					'<div class="game_banner">',
						'<span href="javascript:void(0)" class="link_detail">', 
							'<img class="game_icon" alt="" src="'+items[i].image+'">',
						'</span>',
						'<h4 class="game_name">'+items[i].title+'</h4>',
						'<p class="intor">'+tagHTML+items[i].point+(items[i].point_suffix||'')+UNIT+'</p>',
					'</div>',
					'<p class="desc">任务要求：'+items[i].desc+'</p>',
				'</li>'].join(''));
	}
	tmp.push('</ul>');
	return tmp.join('');
}
function __buildStatusTag(state) {
	/*
		0:已完成
		1:进行中
		2:已失效
	*/
	switch(state){
		case 0:
			return '<span class="state done">已完成</span>';
		case 1:
			return '<span class="state doing">进行中</span>';
		case 2:
			return '<span class="state fail">已失效</span>';
		default:
			return '';
	}
}


function appealCallback (jsonObj) {
	APPEAL = jsonObj;

	var tmpHTML = ['<option value="" disabled>下载安装的应用名称</option>'];
	if(!!APPEAL.doneList){
		$.each(APPEAL.doneList, function (app_id, app_info) {
			tmpHTML.push('<option value="'+app_id+'">'+app_info.name+'</option>')
		});
	}
	$('#repo_email').val(APPEAL.email||'');
	$('#select_repo_app').empty().append(tmpHTML.join('')).change();
	$('#repo').css('marginLeft',0);
	scroll_repo && scroll_repo.refresh && scroll_repo.refresh();
}
// TODO: 投诉结果
function appealResult() {
	$('#repo').css('marginLeft', "100%");
	// alert(JSON.stringify(arguments));
}
function __sdk (functionName, data) {
	var tmpData = [],
		req = {
			"functionName": functionName,
			"url": 'domob://' + functionName + '/'
		};

	if(data){
		if(data.callback){
			var tmpFnName = '__sdkCallback'+ ++$.guid,
				callback = data.callback, 
				maxDelayTimeout;
			
			req.callback = tmpFnName;

			maxDelayTimeout = setTimeout(function(){
									DEV&&console.log('timeout', req);
									window[tmpFnName]({"error": {"code": 9}});
									window[tmpFnName] = $.noop;
								}, MAX_SDK_DELAY);
			window[tmpFnName] = function(){
				if(maxDelayTimeout)clearTimeout(maxDelayTimeout);
				if(typeof callback == "string" && typeof window[callback] == "function"){
					window[callback].apply(this, arguments);
				}else if(typeof callback == "function"){
					callback.apply(this, arguments);
				}
				window[tmpFnName] = $.noop;
			}
			
			data.callback = tmpFnName;
		}

		$.each(data, function (key, value){
			tmpData.push(key + '=' + encodeURIComponent(value));
		});
		req.url += '?' + tmpData.join('&');

		req.abort = function(){
			DEV&&console.log('abort', this);
			window[this.callback]({"error": {"code": 10}});
			window[this.callback] = $.noop;
			delete this;
		}
	}
	DEV&&(console?console.log(req):__showLog(req.url));
	window.location = req.url;

	return req;
}

function back(){
	$('.ac_back2list').each(function(){
		if(parseInt($(this).closest('.box').css('marginLeft')) === 0){
			$(this).trigger('touchend')
		}
	});
}

var __lastClickTime=1;
function __cancelDoubleTouchEnd(event){
	event.cancelBubble = true;
	event.preventDefault();
	var now = event.timeStamp || (new Date()).valueOf()*1;
	if(now - __lastClickTime < 10){
		return false;
	}
	__lastClickTime = now;
	return true;
}
$(function(){
	if(navigator.userAgent.match(/AppleWebKit\/(\d+)/) && navigator.userAgent.match(/AppleWebKit\/(\d+)/)[1] <= 533){
		$('body').addClass('quirk');
	}
	//missing 20px in ipad with ios7 landscape
	if(navigator.userAgent.match(/iPad;.*CPU.*OS 7_\d/i)) {
		$('html').addClass('ipad ios7');
	}
	setTimeout((function(){
		__zoomToFill();
		document.body.style.opacity = "1";
	}), 300);
	function __zoomToFill(){
		// var deviceWidth = document.documentElement.clientWidth,
		// 	deviceHeight = document.documentElement.clientHeight;

		// __scale = deviceWidth/360;
		// document.body.style.zoom = __scale;
	}
	$('#last_pull_time').html('上次刷新：'+UPDATE_TIME.getFullYear()+'-'+towDigi(UPDATE_TIME.getMonth()+1)+'-'+towDigi(UPDATE_TIME.getDate())+" "+towDigi(UPDATE_TIME.getHours())+":"+towDigi(UPDATE_TIME.getMinutes())+":"+towDigi(UPDATE_TIME.getSeconds()))

	//事件绑定
	$('body')
		.on('click', '.ac_quit', function(e){
			if(e && !__cancelDoubleTouchEnd(e))return false;

			__sdk('close');
		})
		.on('touchend', '.ac_back2list', function(e){
			if(e && !__cancelDoubleTouchEnd(e))return false;

			var $box = $(this).closest('.box');
			$box.css('marginLeft', '100%');
			if($box.is('#status')){
				__sdk('statusClose');
			}
		})
		.on('click', '.ac_do_action', function(e){
			if(e && !__cancelDoubleTouchEnd(e))return false;

			var app_id = $(this).attr('srv'),
				item = ITEMS[app_id]||{};

			__sdk('fired', {type:'click','cids':item.cid, 'trs':item.tr});

			// window.location.href = item.file_url;
		})
		.on('click', '.ac_callsdk', function(e){
			if(e && !__cancelDoubleTouchEnd(e))return false;

			__sdk($(this).attr('srv'));
		})
		.on('click', '.ac_go_detail', function(e){
			if(e && !__cancelDoubleTouchEnd(e))return false;

			__openDetail(this);
		})
		.on('click', '.ac_refresh', function(e){
			if(e && !__cancelDoubleTouchEnd(e))return false;
			
			__refresh();
		})
		.on('click', '#btn_repo', function(e){
			if(e && !__cancelDoubleTouchEnd(e))return false;
			
			__sdk('initAppeal', {'callback':'appealCallback'});
		})
		.on('touchend', '#btn_help', function(e){
			if(e && !__cancelDoubleTouchEnd(e))return false;
			
			scroll_help && scroll_help.refresh && scroll_help.refresh();
			$('#help').css('marginLeft',0);
		})
		.on('touchend', '.ac_show_status', function(e){
			if(e && !__cancelDoubleTouchEnd(e))return false;
			
			__openStatus();
		})
		.on('touchend', '.ac_close', function(e){
			if(e && !__cancelDoubleTouchEnd(e))return false;
			
			// window.location="domob://close";
			__sdk('close');
		})
		.on('touchend', '#list_header', function(e){
			scroll_list&&scroll_list.scrollTo(0,-__pullDownOffset,100);
		})
		.on('click', '#more_status', function(){
			$('#status_list li').show();
			$(this).remove();
			__sdk('statusMore');
			scroll_status.refresh();
		});
	$('#select_repo_app').change(function(){
		if(this.value){
			$('#repo_app_pkg').val(APPEAL.doneList[this.value].pkg);
			$('#repo_app_name').val(APPEAL.doneList[this.value].name);
		}
	}).focus(function(){
		if($(this).find('option').length>1)
			$('#form_mask').show();
	}).blur(function(){
		$('#form_mask').hide();
	});
	$('#repo_email').focus(function(){
		$('#form_mask').show();
	}).blur(function(){
		$('#form_mask').hide();
	});
	$('#form_mask').on('touchstart', function(e){
		e.preventDefault();
		e.cancelBubble && e.cancelBubble();
		return false;
	});
	$('#detail').bind('touchmove',function(e){
		e.preventDefault();
		return false;
	});
	$('#more_game').on('click', function(){
		if($(this).hasClass('loading'))return;
		fetchGameList();
	});
	// $('.ac_show_status').trigger('touchend');

	$('#pich').pich();
	(function ver(){
		var vers = [
				document.getElementById('version').innerHTML.replace('v=',''),
				'ios'+document.getElementById('version').clientWidth,
				version
				]
			console.log('%cVersions:', 'font-size: big;');
			console.log(' HTML:', vers[0]);
			console.log(' CSS:', vers[1]);
			console.log(' JS:', vers[2]);
			if(jQuery.unique(vers).length == 1 ){
				console.log('%c MATCHED! ', 'background: #0f0; color: #fff');
			}else{
				console.log('%c NOT MATCHED! ', 'background: #f00; color: #fff');
			}
	})();
});

$(window).on('resize', function(){
		__showPage();
	}).on('load', function() {
		if(DATA.unit_name){
			init();
		}else{
			initTemplate();
		}
	});
var domobjs = {
		onViewable:function(){
			if(((new Date())-UPDATE_TIME)> MAX_DATA_AGE){

				$('#more_game').hide();
				initTemplate();
			}
		},
		onDismiss:function(){
			// document.body.style.opacity = 0;
		}
	};
(function($){
	var nextFrame = window.requestAnimationFrame || 
			window.mozRequestAnimationFrame || 
			window.webkitRequestAnimationFrame || 
			window.msRequestAnimationFrame || 
			function(fn){return setTimeout(fn, 16)},
		cancelFrame = window.cancelRequestAnimationFrame ||
			window.webkitCancelAnimationFrame ||
			window.webkitCancelRequestAnimationFrame ||
			window.mozCancelRequestAnimationFrame ||
			window.oCancelRequestAnimationFrame ||
			window.msCancelRequestAnimationFrame ||
			clearTimeout
		;
	function __setPos($t, newPos, force){
		// $t.css(newPos);
		$t[0].style.top = newPos.top + 'px';
		$t[0].style.left = newPos.left + 'px';
	}
	$.fn.extend({
		pich:function (setting){
			var setting = $.extend({
					sticky: true
				},setting);
			return this.each(function(){
				var $t=$(this),
					cache = {
						height: $t.height(),
						width: $t.width(),
						pos: $t.offset(),
						ts:0
					},
					PAGE,
					startTouch,
					touch
					;
				// $t.css({
				// 	height: cache.height,
				// 	width: cache.width
				// });
				if(setting.sticky){
					PAGE = {
						height: document.body.clientHeight,
						width: document.body.clientWidth
					}
				}
				$t.addClass('anim_css');

				var __aninTimer;
				function update(){
					__aninTimer = nextFrame(update);
					__setPos($t, {
						top: touch.pageY - cache.height/2,
						left: touch.pageX - cache.width/2
					});
				}

				var __idleTimer;
				function checkIdle(){
					if(__idleTimer)clearTimeout(__idleTimer);
					__idleTimer=setTimeout(function(){$t.addClass('idle');}, 5000);
				}
				checkIdle();

				var __testTimer;
				$t.on('touchstart', function(e){
					e.preventDefault();
					$(this).removeClass('anim_css idle');
					if(__idleTimer)clearTimeout(__idleTimer);

					cache.ts = e.timeStamp;
					touch =  e.originalEvent.touches[0];
					cache.startX = touch.pageX;
					cache.startY = touch.pageY;
					update();
				}).on('touchmove', function(e){
					e.preventDefault();
					touch = e.originalEvent.touches[0];
				}).on('touchcancel touchend', function(e){
					e.preventDefault();
					cancelFrame(__aninTimer);
					checkIdle();

					$(this).addClass('anim_css');
					if(e.timeStamp - cache.ts < 300){
						var diff = Math.abs(cache.startY - touch.pageY)+Math.abs(cache.startX - touch.pageX);
						if(diff<10){
							this.click();
						}
					}
					if(setting.sticky){
						var newPos = {
								left: e.originalEvent.changedTouches[0].pageX - cache.width/2,
								top: e.originalEvent.changedTouches[0].pageY - cache.height/2
							};
						if(e.originalEvent.changedTouches[0].pageY > PAGE.height-1.5*cache.height){
							newPos.top = PAGE.height - cache.height;
						}else if(e.originalEvent.changedTouches[0].pageY < 1.5*cache.height){
							newPos.top = 0;
						}
						if(e.originalEvent.changedTouches[0].pageX > PAGE.width/2 + cache.width/2){
							newPos.left = PAGE.width - cache.width;
						}else{
							newPos.left = 0;
						}
						__setPos($t, newPos, true);
					}
				});
				$(window).on('resize', function(){
					$t.css({
						left: 0,
						top: 2*cache.width
					});
					PAGE = {
						height: document.body.clientHeight,
						width: document.body.clientWidth
					};
				});
			});
		}
	});
})(jQuery);
var version = "ios82161";
