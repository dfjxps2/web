# coding=utf-8
import const
import json
import operator

import re
import time
import random

from decimal import *
from mysql import MySQL
import config


def get_host():
    conn = MySQL(config.LOG_MYSQL)
    result = conn.execute('SELECT host_id,host_name,sys_id from host_list')
    del conn
    return json.dumps(result)

def get_system():
    conn = MySQL(config.LOG_MYSQL)
    result = conn.execute('select * from system_list')
    del conn
    return json.dumps(result)


def get_level():
    conn = MySQL(config.LOG_MYSQL)
    result = conn.execute('select * from abnormal_level')
    del conn
    return json.dumps(result)

def get_host_user():
    conn = MySQL(config.LOG_MYSQL)
    result = conn.execute('SELECT user_id,user_name,host_id FROM host_user ')
    del conn
    return json.dumps(result)

def get_code(startDate,endDate,level,systems,hosts):
    conn = MySQL(config.LOG_MYSQL)
    sql = "SELECT error_type,MAX(error_date) maxDate ,MIN(error_date) minDate, COUNT(*) cou FROM code_error " \
          "WHERE 1=1 "
    if operator.eq(startDate,"0")== False:
        sql = sql + "and error_date >= '"+startDate+"' "
    if operator.eq(endDate,"0") == False:
        sql = sql + "and error_date <= '"+endDate+"' "
    if operator.eq(level, "0") == False:
        sql = sql + "and level_id = '"+level+"' "

    if operator.eq(systems, "0") == False:
        sql = sql + "and system_id = '"+systems+"' "

    if operator.eq(hosts, "0") == False:
        sql = sql + "and host_id = '"+hosts+"' "
    sql = sql +"GROUP BY error_type ORDER BY cou desc"
    result = conn.execute(sql)
    del conn
    return json.dumps(result)


def get_codeBy(startDate,endDate,level,systems,hosts,error_type):
    conn = MySQL(config.LOG_MYSQL)
    sql = "SELECT a.id,error_type,error_date,b.level_name level_name,c.host_name host_name,d.sys_name sys_name,log logs FROM code_error a " \
          "LEFT JOIN abnormal_level b ON a.level_id = b.id " \
          "LEFT JOIN host_list c ON a.host_id = c.host_id " \
          "LEFT JOIN system_list d ON a.system_id = d.sys_id " \
          "WHERE 1=1 " \
          "and error_type = '"+error_type+"' "
    if operator.eq(startDate,"0")== False:
        sql = sql + "and error_date >= '"+startDate+"' "
    if operator.eq(endDate,"0") == False:
        sql = sql + "and error_date <= '"+endDate+"' "
    if operator.eq(level, "0") == False:
        sql = sql + "and level_id = '"+level+"' "

    if operator.eq(systems, "0") == False:
        sql = sql + "and system_id = '"+systems+"' "

    if operator.eq(hosts, "0") == False:
        sql = sql + "and host_id = '"+hosts+"' "
    sql = sql +"ORDER BY error_date desc"
    result = conn.execute(sql)
    '''
    for s in result:
        pattern = re.compile(r'error|Cause', re.M | re.I)

        # 使用re.match匹配文本，获得匹配结果，无法匹配时将返回None
        result1 = re.search(pattern, s.get("logs"))
        if result1:
            print "true"
        else:
            print "false"
    '''
    del conn
    return json.dumps(result)


def get_codeTrend(startDate,endDate,level,systems,hosts):
    conn = MySQL(config.LOG_MYSQL)
    sql = "SELECT error_date,COUNT(*) cou FROM code_error " \
          "WHERE 1=1 "
    if operator.eq(startDate,"0")== False:
        sql = sql + "and error_date >= '"+startDate+"' "
    if operator.eq(endDate,"0") == False:
        sql = sql + "and error_date <= '"+endDate+"' "
    if operator.eq(level, "0") == False:
        sql = sql + "and level_id = '"+level+"' "

    if operator.eq(systems, "0") == False:
        sql = sql + "and system_id = '"+systems+"' "

    if operator.eq(hosts, "0") == False:
        sql = sql + "and host_id = '"+hosts+"' "
    sql = sql +"GROUP BY error_date ORDER BY error_date"
    result = conn.execute(sql)
    del conn
    return json.dumps(result)


def get_failure(startDate,endDate,level,hosts):
    conn = MySQL(config.LOG_MYSQL)
    sql = "SELECT failure_type,MAX(failure_date) maxDate ,MIN(failure_date) minDate, COUNT(*) cou FROM system_failure " \
          "WHERE 1=1 "
    if operator.eq(startDate,"0")== False:
        sql = sql + "and failure_date >= '"+startDate+"' "
    if operator.eq(endDate,"0") == False:
        sql = sql + "and failure_date <= '"+endDate+"' "
    if operator.eq(level, "0") == False:
        sql = sql + "and level_id = '"+level+"' "
    if operator.eq(hosts, "0") == False:
        sql = sql + "and host_id = '"+hosts+"' "
    sql = sql +"GROUP BY failure_type ORDER BY cou desc"
    result = conn.execute(sql)
    del conn
    return json.dumps(result)

def get_failureType(startDate,endDate,level,hosts,failure_type):
    conn = MySQL(config.LOG_MYSQL)
    sql = "SELECT id,failure_type,failure_date,level_id,b.host_name host_name,log FROM system_failure a LEFT JOIN host_list b ON a.host_id = b.host_id " \
          "WHERE 1=1 " \
          "and failure_type = '"+failure_type+"' "
    if operator.eq(startDate,"0")== False:
        sql = sql + "and failure_date >= '"+startDate+"' "
    if operator.eq(endDate,"0") == False:
        sql = sql + "and failure_date <= '"+endDate+"' "
    if operator.eq(level, "0") == False:
        sql = sql + "and level_id = '"+level+"' "
    if operator.eq(hosts, "0") == False:
        sql = sql + "and host_id = '"+hosts+"' "
    sql = sql +"ORDER BY failure_date desc"
    result = conn.execute(sql)
    del conn
    return json.dumps(result)

def get_failureTrend(startDate,endDate,level,hosts):
    conn = MySQL(config.LOG_MYSQL)
    sql = "SELECT failure_date,COUNT(*) cou FROM system_failure " \
          "WHERE 1=1 "
    if operator.eq(startDate,"0")== False:
        sql = sql + "and failure_date >= '"+startDate+"' "
    if operator.eq(endDate,"0") == False:
        sql = sql + "and failure_date <= '"+endDate+"' "
    if operator.eq(level, "0") == False:
        sql = sql + "and level_id = '"+level+"' "
    if operator.eq(hosts, "0") == False:
        sql = sql + "and host_id = '"+hosts+"' "
    sql = sql +"GROUP BY failure_date ORDER BY failure_date"
    result = conn.execute(sql)
    del conn
    return json.dumps(result)

def get_userActivity(startDate,endDate,systems,hosts):
    conn = MySQL(config.LOG_MYSQL)
    sql = "SELECT activity_type, SUM(CASE WHEN user_type = 'hive' THEN 1 ELSE 0 END) hive," \
          "SUM(CASE WHEN user_type = 'etl' THEN 1 ELSE 0 END) etl," \
          "SUM(CASE WHEN user_type = 'hdfs' THEN 1 ELSE 0 END) hdfs " \
          "FROM user_activity " \
          "WHERE 1=1 "
    if operator.eq(startDate,"0")== False:
        sql = sql + "and activity_date >= '"+startDate+"' "
    if operator.eq(endDate,"0") == False:
        sql = sql + "and activity_date <= '"+endDate+"' "

    if operator.eq(systems, "0") == False:
        sql = sql + "and system_id = '"+systems+"' "

    if operator.eq(hosts, "0") == False:
        sql = sql + "and host_id = '"+hosts+"' "
    sql = sql +"GROUP BY activity_type ORDER BY id"
    result = conn.execute(sql)
    for i in result:
        print i
        i["hive"] = str(Decimal(i.get("hive")).quantize(Decimal('0')))
        i["etl"] = str(Decimal(i.get("etl")).quantize(Decimal('0')))
        i["hdfs"] = str(Decimal(i.get("hdfs")).quantize(Decimal('0')))
    del conn
    return json.dumps(result)

def get_warning_info(startDate,endDate,level,hosts):
    conn = MySQL(config.LOG_MYSQL)
    sql = "SELECT c.service_name service_name,d.host_name host_name,b.level_name level_name,info_date,info from warning_info a " \
          "LEFT JOIN abnormal_level b ON a.level_id = b.id " \
          "LEFT JOIN service_list c ON a.service_id = c.service_id " \
          "LEFT JOIN host_list d ON a.host_id = d.host_id " \
          "WHERE 1=1 "
    if operator.eq(startDate,"0")== False:
        sql = sql + "and info_date >= '"+startDate+"' "
    if operator.eq(endDate,"0") == False:
        sql = sql + "and info_date <= '"+endDate+"' "
    if operator.eq(level, "0") == False:
        sql = sql + "and a.level_id = '"+level+"' "

    if operator.eq(hosts, "0") == False:
        sql = sql + "and a.host_id = '"+hosts+"' "
    sql = sql +"ORDER BY info_date desc"
    result = conn.execute(sql)
    del conn
    return json.dumps(result)

#告警规则查询
def get_alarm_rule(startDate,endDate,level,rule_name,id):
    conn = MySQL(config.LOG_MYSQL)
    sql = "SELECT a.id id,rule_name,b.level_name level_name,a.level_id level_id,rule_exp,rule_info,creat_date,rule_state from alarm_rule a " \
          "LEFT JOIN abnormal_level b ON a.level_id = b.id " \
          "WHERE rule_state != 0 "
    if operator.eq(startDate,"0")== False:
        sql = sql + "and creat_date >= '"+startDate+"' "
    if operator.eq(endDate,"0") == False:
        sql = sql + "and creat_date <= '"+endDate+"' "
    if operator.eq(level, "0") == False:
        sql = sql + "and a.level_id = '"+level+"' "
    if operator.eq(rule_name, "0") == False:
        sql = sql + "and rule_name LIKE  '%"+rule_name+"%' "
    if operator.eq(id, "0") == False:
        sql = sql + "and a.id = '"+id+"' "
    sql = sql +"ORDER BY creat_date desc"
    result = conn.execute(sql)
    del conn
    return result

def add_alarm_rule(rule_level,rule_exp,rule_info,creat_date):
    t = int(time.time())
    s = random.randint(65, 90)
    r = chr(s).lower()
    rule_name = "R"+ str(t)+r
    dicts = {}
    conn = MySQL(config.LOG_MYSQL)
    dicts['rule_name'] = rule_name
    dicts['level_id'] = rule_level
    dicts['rule_exp'] = rule_exp
    dicts['rule_info'] = rule_info
    dicts['creat_date'] = creat_date
    dicts['rule_state'] = 1
    a = conn.insert('alarm_rule', dicts)
    del conn
    return a

def get_updata_rule(rule_level,rule_exp,rule_info,creat_date,id,rule_state):
    conn = MySQL(config.LOG_MYSQL)
    # "rule_name = '"+rule_name+"'," \
    sql = "UPDATE alarm_rule set " \
          "level_id = '" + rule_level + "'," \
          'rule_exp = "' + rule_exp + '",' \
          "rule_info = '"+rule_info+"'," \
          "creat_date = '"+creat_date+"' " \
          "WHERE  id = '"+id+"'"
    print  sql
    result = conn.execute(sql)
    del conn
    return json.dumps(result)

def get_delete_rule(id):
    conn = MySQL(config.LOG_MYSQL)
    sql = "UPDATE alarm_rule set " \
          "rule_state = 0 " \
          "WHERE  id = '"+id+"'"
    result = conn.execute(sql)
    del conn
    return json.dumps(result)


def get_notice(startDate,endDate,notice_name,notice_obj,id):
    conn = MySQL(config.LOG_MYSQL)
    sql = "SELECT id,notice_name,notice_rate,notice_obj,telephone,creat_date FROM alarm_notice " \
          "WHERE notice_state != 0 "
    if operator.eq(startDate, "0") == False:
        sql = sql + "and creat_date >= '" + startDate + "' "
    if operator.eq(endDate, "0") == False:
        sql = sql + "and creat_date <= '" + endDate + "' "
    if operator.eq(notice_name, "0") == False:
        sql = sql + "and notice_name LIKE '%" + notice_name + "%' "
    if operator.eq(notice_obj, "0") == False:
        sql = sql + "and notice_obj LIKE  '%" + notice_obj + "%' "
    if operator.eq(id, "0") == False:
        sql = sql + "and id = '" + id + "' "
    sql = sql + "ORDER BY creat_date desc"
    result = conn.execute(sql)
    del conn
    return result

def get_delete_notice(id):
    conn = MySQL(config.LOG_MYSQL)
    sql = "UPDATE alarm_notice set " \
          "notice_state = 0 " \
          "WHERE  id = '"+id+"'"
    result = conn.execute(sql)
    del conn
    return json.dumps(result)


def add_alarm_notice(notice_rate,notice_obj,telephone,creat_date):
    t = int(time.time())
    s = random.randint(65, 90)
    r = chr(s).lower()
    notice_name = "N" + str(t) + r
    dicts = {}
    conn = MySQL(config.LOG_MYSQL)
    dicts['notice_name'] = notice_name
    dicts['notice_rate'] = notice_rate
    dicts['notice_obj'] = notice_obj
    dicts['telephone'] = telephone
    dicts['creat_date'] = creat_date
    dicts['notice_state'] = 1
    a = conn.insert('alarm_notice', dicts)
    del conn
    return a

def get_updata_notice(notice_rate,notice_obj,telephone,creat_date,id):
    conn = MySQL(config.LOG_MYSQL)
    sql = "UPDATE alarm_notice set " \
          "notice_rate = '"+notice_rate+"'," \
          "notice_obj = '"+notice_obj+"'," \
          "telephone = '" + telephone + "'," \
          "creat_date = '"+creat_date+"' " \
          "WHERE  id = '"+id+"'"
    result = conn.execute(sql)
    del conn
    return json.dumps(result)
