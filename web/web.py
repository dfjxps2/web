# coding=utf-8
from bottle import route, run, default_app
from bottle import template, static_file
from bottle import request, redirect
import operator
import json
import sys
import logging
import datetime
from datetime import timedelta

import re
import random
import commands

from gevent import monkey
import service
import config

monkey.patch_all()

now = datetime.datetime.now()
this_week_start = (now - timedelta(days=now.weekday()))
stateDate=this_week_start.strftime('%Y-%m-%d')
endDate = now.strftime('%Y-%m-%d')

@route('/assets/<filename:re:.*\.css|.*\.js|.*\.png|.*\.jpg|.*\.gif>')
@route('/assets/<filename:re:.*\.ttf|.*\.otf|.*\.eot|.*\.woff|.*\.woff2|.*\.svg|.*\.map>')
def server_static(filename):
    return static_file(filename, root=config.ASSETS_PATH)


@route('/')
def index():
    return template('index')

@route('/test')
def test():
    return template('test')

@route('/selec/1', method="POST")
def test():
    str = {}
    result1 = service.get_host()
    result2 = service.get_level()
    result3 = service.get_host_user()
    result4 = service.get_system()
    str["host_list"] = result1
    str["level_list"] = result2
    str["user_list"] = result3
    str["system_list"] = result4
    return str

#代码异常
@route('/code/1')
def test():
    """
    b_list = range(100001, 100200)


    blist_webId = random.sample(b_list, 1)

    print "-----------",blist_webId[0]
    """
    result = service.get_code(this_week_start.strftime('%Y-%m-%d'),now.strftime('%Y-%m-%d'),"0","0","0")
    return template('code1',list=result,stateDate=stateDate,endDate = endDate,  data=config.LOG_MYSQL)

#发送信息
@route('/shortMeassage/1', method="POST")
def segment_action():
    phone = request.POST.get('phone')
    meassage = request.POST.get('meassage')
    javaBin = config.JAVABIN
    baseUrl = config.BASEURL
    sre = javaBin+"/java -Dfile.encoding=UTF-8 -jar "+ baseUrl + " " + phone + " " + '"'+meassage+'"'
    (status, output) = commands.getstatusoutput(sre)
    print sre
    str = {}
    if operator.eq(status, 0):
        str["state"] = "1"
        str["info"] = "发送成功！"
    else:
        str["state"] = "0"
        str["info"] = "发送失败！"
    return str


@route('/codeBy/1', method="POST")
def segment_action():
    startDate = request.POST.get('startDate')
    endDate = request.POST.get('endDate')
    level = request.POST.get('level')
    systems = request.POST.get('systems')
    hosts = request.POST.get('hosts')
    list = result = service.get_code(startDate,endDate,level,systems,hosts)
    return list

@route('/codeByType/1', method="POST")
def segment_action():
    startDate = request.POST.get('startDate')
    endDate = request.POST.get('endDate')
    level = request.POST.get('level')
    systems = request.POST.get('systems')
    hosts = request.POST.get('hosts')
    error_type = request.POST.get('error_type')
    list = result = service.get_codeBy(startDate,endDate,level,systems,hosts,error_type)
    return list

#代码异常趋势
@route('/report/1')
def test():
    result = service.get_codeTrend("0", "0", "0", "0", "0")
    return template('report1', list=result,stateDate=stateDate,endDate = endDate, data=config.LOG_MYSQL)

@route('/reportBy/1', method="POST")
def segment_action():
    startDate = request.POST.get('startDate')
    endDate = request.POST.get('endDate')
    level = request.POST.get('level')
    systems = request.POST.get('systems')
    hosts = request.POST.get('hosts')
    list = result = service.get_codeTrend(startDate,endDate,level,systems,hosts)
    return list

#合规性
@route('/specs/1')
def test():
    result = service.get_code(stateDate,endDate, "0", "0", "0")
    return template('specs', list=result, stateDate=stateDate, endDate=endDate, data=config.LOG_MYSQL)

#系统故障趋势
@route('/specsTrend/1')
def test():
    result = service.get_failureTrend("0", "0", "0", "0")
    return template('specsTrend',stateDate=stateDate,endDate = endDate, list=result, data=config.LOG_MYSQL)



#系统故障趋势
@route('/faultTrend/1')
def test():
    result = service.get_failureTrend("0", "0", "0", "0")
    return template('faultTrend',stateDate=stateDate,endDate = endDate, list=result, data=config.LOG_MYSQL)

@route('/faultTrendBy/1', method="POST")
def segment_action():
    startDate = request.POST.get('startDate')
    endDate = request.POST.get('endDate')
    level = request.POST.get('level')
    hosts = request.POST.get('hosts')
    list = result = service.get_failureTrend(startDate,endDate,level,hosts)
    return list


#系统故障
@route('/fault/1')
def test():
    result = service.get_failure("0", "0", "0", "0")
    return template('fault1', list=result,stateDate=stateDate,endDate = endDate, data=config.LOG_MYSQL)

@route('/faultBy/1', method="POST")
def segment_action():
    startDate = request.POST.get('startDate')
    endDate = request.POST.get('endDate')
    level = request.POST.get('level')
    hosts = request.POST.get('hosts')
    list  = service.get_failure(startDate,endDate,level,hosts)
    return list

@route('/faultByType/1', method="POST")
def segment_action():
    startDate = request.POST.get('startDate')
    endDate = request.POST.get('endDate')
    level = request.POST.get('level')
    hosts = request.POST.get('hosts')
    failure_type = request.POST.get('failure_type')
    list  = service.get_failureType(startDate,endDate,level,hosts,failure_type)
    return list

#入侵警告
@route('/intrusion/1')
def test():
    result = service.get_failureTrend("0", "0", "0", "0")
    return template('intrusion', list=result,stateDate=stateDate,endDate = endDate, data=config.LOG_MYSQL)

#内部违规
@route('/irregularities/1')
def test():
    result = service.get_failureTrend("0", "0", "0", "0")
    return template('irregularities',stateDate=stateDate,endDate = endDate, list=result, data=config.LOG_MYSQL)

#用户活动报表
@route('/userReport/1')
def test():
    result = service.get_userActivity("0", "0", "0", "0")
    return template('userReport',stateDate=stateDate,endDate = endDate, list=result, data=config.LOG_MYSQL)

@route('/userReportBy/1', method="POST")
def test():
    startDate = request.POST.get('startDate')
    endDate = request.POST.get('endDate')

    systems = request.POST.get('systems')
    hosts = request.POST.get('hosts')
    list = service.get_userActivity(startDate,endDate,systems,hosts)
    return list

#告警查询
@route('/warningQuery/1')
def test():
    result = service.get_warning_info("0", "0", "0", "0")
    return template('warningQuery', list=result,stateDate=stateDate,endDate = endDate, data=config.LOG_MYSQL)

@route('/warningQueryBy/1', method="POST")
def test():
    startDate = request.POST.get('startDate')
    endDate = request.POST.get('endDate')
    level = request.POST.get('level')
    systems = request.POST.get('systems')
    hosts = request.POST.get('hosts')
    list = service.get_warning_info(startDate, endDate, level, hosts)
    return list


#告警规则设置首页
@route('/ruleSetting/1')
def test():
    result = service.get_alarm_rule("0", "0", "0","0","0")
    return template('ruleSetting',stateDate=stateDate,endDate = endDate, list=json.dumps(result), data=config.LOG_MYSQL)

#告警规则设置条件查询
@route('/ruleSettingBy/1', method="POST")
def test():
    startDate = request.POST.get('startDate')
    endDate = request.POST.get('endDate')
    level = request.POST.get('level')
    rule_name = request.POST.get('rule_name')
    list = service.get_alarm_rule(startDate, endDate, level,rule_name,"0")
    return json.dumps(list)

#告警规则设置id查询
@route('/ruleSettingById/1', method="POST")
def test():
    id = request.POST.get('id')
    type = request.POST.get('type')
    list = [];
    if operator.eq(type, "1"):
        list = service.get_alarm_rule("0", "0", "0", "0",id)
    else:
        a = service.get_delete_rule(id)
        if a>0:
            list = service.get_alarm_rule("0", "0", "0", "0", "0")
    return json.dumps(list)


#告警规则设置添加修改
@route('/addRule/1', method="POST")
def addRule():
    #rule_name = request.POST.get('rule_name')
    rule_level = request.POST.get('rule_level')
    rule_exp = request.POST.get('rule_exp')
    rule_info = request.POST.get('rule_info')
    creat_date = request.POST.get('creat_date')
    id = request.POST.get('id')
    types = request.POST.get('types')
    a = 0
    str  = {}
    if operator.eq(types, "add"):
        a = service.add_alarm_rule (rule_level,rule_exp,rule_info,creat_date);
    else:
        a = service.get_updata_rule(rule_level, rule_exp, rule_info, creat_date,id,"1")
    if a > 0 :
        list = service.get_alarm_rule("0", "0", "0", "0","0")
    if len(list)>0:
        str["state"] = "1"
        str["info"] = ""
        str["data"] = json.dumps(list)
    return str




#告警通知设置
@route('/noticeSetting/1')
def test():
    result = service.get_notice("0", "0", "0", "0", "0")
    return template('noticeSetting', list=json.dumps(result), data=config.LOG_MYSQL)

@route('/noticeSettingBy/1',stateDate=stateDate,endDate = endDate, method="POST")
def test():
    startDate = request.POST.get('startDate')
    endDate = request.POST.get('endDate')
    notice_name = request.POST.get('notice_name')
    notice_obj = request.POST.get('notice_obj')
    id = request.POST.get('id')
    list = service.get_notice(startDate, endDate, notice_name, notice_obj, id)
    return json.dumps(list)

@route('/noticeSettingById/1', method="POST")
def test():
    id = request.POST.get('id')
    type = request.POST.get('type')
    list = [];
    if operator.eq(type, "1"):
        list = service.get_notice("0", "0", "0", "0",id)
    else:
        a = service.get_delete_notice(id)
        if a>0:
            list = service.get_notice("0", "0", "0", "0", "0","0")
    return json.dumps(list)


@route('/addNotice/1', method="POST")
def addNotice():
    notice_rate = request.POST.get('notice_rate')
    notice_obj = request.POST.get('notice_obj')
    telephone = request.POST.get('telephone')
    creat_date = request.POST.get('creat_date')
    id = request.POST.get('id')
    types = request.POST.get('types')
    a = 0
    str = {};
    if operator.eq(types, "add"):
        a = service.add_alarm_notice(notice_rate,notice_obj,telephone,creat_date)
    else:
        a = service.get_updata_notice(notice_rate,notice_obj,telephone,creat_date,id)
    if a > 0 :
        list = service.get_notice("0", "0", "0", "0", "0")
    if len(list)>0:
        str["state"] = "1"
        str["info"] = ""
        str["data"] = json.dumps(list)
    return str



    
@route('/query/:qt')
def query(qt = 'oper'):
    return template('query', qt = qt)

if __name__ == '__main__':
    try:
        port = int(sys.argv[1])
    except Exception, e:
        logging.error("Please enter the port number.")
        sys.exit(1)
    if port <= 1024:
        logging.error("The port number needs more than 1024.")
        sys.exit(1)

    app = default_app()
    run(app=app, host='localhost', port=port, debug=True)
    #run(app=app, host='localhost', port=port, debug=True)
    #run(app=app, host='0.0.0.0', port=port, debug=True, server='gevent')