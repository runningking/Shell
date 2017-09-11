#!/bin/bash
set -e
#定义文件存放路径
downdir=/data/exportdata
#定义日志存放路径
logfile=/data/exportdata/sdcmp-down.log
#脚本存放路径
script=/isoft
#定义操作的数据库
database=sdcmp
#取得最新的文件序号值
i=`ls -l /data/exportdata|tac|grep CQ-APP*|head -n 1|awk '{print $9}'|awk -F "-" '{print $4}'|awk -F "." '{print $1}'`
j=`ls -l /data/exportdata|tac|grep CQ-USR*|head -n 1|awk '{print $9}'|awk -F "-" '{print $4}'|awk -F "." '{print $1}'`
m=`ls -l /data/exportdata|tac|grep CQ-PRO*|head -n 1|awk '{print $9}'|awk -F "-" '{print $4}'|awk -F "." '{print $1}'`
n=`ls -l /data/exportdata|tac|grep CQ-SER*|head -n 1|awk '{print $9}'|awk -F "-" '{print $4}'|awk -F "." '{print $1}'`

#判断用户导出目标文件，并改变对应序号值
if [ $# -eq 0 ]
then
	let i+=1
	let j+=1
	let m+=1
	let n+=1
else if [ $# -eq 1 ]
then
	if [ $1 == "app" ]
	then
		let i+=1
	else if [ $1 == "usr" ]
	then
		let j+=1
	else if [ $1 == "pro" ] 
	then
		let m+=1
	else if [ $1 == "ser" ]
	then
		let n+=1
	else
		echo "[Error]: please input right parameter:"
		echo "1.app  2.usr  3.pro  4.ser"
	fi
	fi
	fi
	fi
fi
fi
 
#判断备份路径是否存在
if [ ! -d ${downdir} ]
then
	mkdir -p ${downdir}
fi

#判断日志路径是否存在
if [ ! -f ${logfile} ]
then
	touch ${logfile}
fi

#添加文件存放路径权限
chmod -R 777 ${downdir}

#获取当前时间
DATE=`date +%Y%m%d%H%M%S`

#打印日志
function printlog(){
	echo "" >> ${logfile}
        echo "--------------------" >> ${logfile}
        echo $(date +"%F %H:%M:%S") >> ${logfile}
        echo "--------------------" >> ${logfile}
        echo "Download $1 file from sdcmp success!" >> ${logfile}
	echo "Upload file to ftp server success!" >> ${logfile}
}

function download_pro(){
mysql sdcmp << EOF
SELECT
    (@i:=@i+1) AS '序号',
    IFNULL(m.pno,'') AS '项目编号',
    IFNULL(m.pname,'') AS '项目名称',
    IFNULL(m.name,'') AS '项目所属省份',
    '' AS '项目所属地市',
    '' AS '项目所属类型',
    '' AS '项目类型',
    '' AS '项目状态',
    IFNULL(m.official_man,'') AS '项目负责人',
    '' AS '专业负责人',
    IFNULL(m.checker,'') AS '审核人',
    IFNULL(DATE_FORMAT(m.start_date,'%Y%m%d'),'') AS '项目启动时间',
    IFNULL(DATE_FORMAT(m.end_date,'%Y%m%d'),'') AS '项目完成时间',
    n.num AS '站点总数',
    o.num AS '待查勘站点数',
    p.num AS '查勘中站点数',
    q.num AS '查勘完成站点数'
FROM
    (
        SELECT
            a.id,
            a.pno,
            a.pname,
            b.name,
            a.official_man,
            concat(a.rchecker,',',a.cchecker)  AS checker,
            a.start_date,
            a.end_date
        FROM
            t_project_main a
        LEFT JOIN
            t_area b
        ON
            a.province=b.value) m
LEFT JOIN
    (
        SELECT
            pid,
            COUNT(*) num
        FROM
            t_task_info
        GROUP BY
            pid) n
ON
    m.id=n.pid
LEFT JOIN
    (
        SELECT
            pid,
            COUNT(*) num
        FROM
            t_task_info
        WHERE
            state='0'
        GROUP BY
            pid ) o
ON
    m.id=o.pid
LEFT JOIN
    (
        SELECT
            pid,
            COUNT(*) num
        FROM
            t_task_info
        WHERE
            state IN ('1',
                      '2',
                      '3')
        GROUP BY
            pid) p
ON
    m.id=p.pid
LEFT JOIN
    (
        SELECT
            pid,
            COUNT(*) num
        FROM
            t_task_info
        WHERE
            state>3
        GROUP BY
            pid) q
ON
    m.id=q.pid ,
    (
        SELECT
            @i:=0) AS it
INTO
    outfile '/data/exportdata/CQ-PRO-${DATE}-$m.csv' fields terminated BY ',' optionally
    enclosed BY '' lines terminated BY '\r\n';
EOF
}

function download_app(){
mysql sdcmp << EOF
SELECT
    (@i:=@i+1) AS '序号',
    IFNULL(a.username,'') AS '用户名',
    '' AS '手机型号',
    '' AS '方式',
    COUNT(*) AS '登录次数',
    IFNULL(MIN(a.login_date),'') AS '登录时间',
    IFNULL(MAX(a.logout_date),'') AS '登出时间',
    IFNULL(MAX(a.login_date),'') AS '最后登录时间'
FROM
    (
        SELECT
            t.username,
            LOGIN_DATE,
            LOGOUT_DATE
        FROM
            t_s_base_user t
        LEFT JOIN
            login_time l
        ON
            t.id=l.USER_ID
        WHERE
            LOGIN_DATE IS NOT NULL) a,
    (
        SELECT
            @i:=0) AS it
GROUP BY
    username
INTO
    outfile '/data/exportdata/CQ-APP-${DATE}-$i.csv' fields terminated BY ',' optionally
    enclosed BY '' lines terminated BY '\r\n';

EOF
}

function download_ser(){
mysql sdcmp << EOF
SELECT DISTINCT
    '' AS '序号',
    IFNULL(m.pno,'') AS '项目编号',
    IFNULL(t.planbsname,'') AS '规划基站名称',
    IFNULL(a.name,'') AS '项目所属省份',
    '' AS '项目所属地市',
    CASE
        WHEN t.state='0'
        THEN '待勘察'
        WHEN t.state IN ('1','2','3')
        THEN '查勘中'
        ELSE '查勘完成'
    END AS '站点状态',
    IFNULL(kcman,'') AS '勘察人员',
    IFNULL(DATE_FORMAT(t.kcdate,'%Y%m%d'),'') AS '勘察时间',
    IFNULL(planbsno,'') AS '基站规划ID',
    IFNULL(z.far_up_btsname,'') AS '拉远上端站名称',
    IFNULL(b.name,'') AS '地市',
    IFNULL(c.name,'') AS '片区',
    IFNULL(z.equip_type,'') AS '基站类型',
    IFNULL(z.bulid_type,'') AS '建设类型',
    IFNULL(z.cover_area,'') AS '覆盖区域',
    IFNULL(z.cover_scene,'') AS '覆盖场景',
    IFNULL(z.cover_scene_mix,'') AS '覆盖具体区域',
    IFNULL(f.building_high,'') AS '建筑物高度_米',
    IFNULL(f.longtitude,'') AS '天面经度',
    IFNULL(f.latitude,'') AS '天面纬度',
    IFNULL(f.altitude,'') AS '天面海拔',
    IFNULL(f.location,'') AS '天面地址',
    '' AS '机房状态',
    IFNULL(ma.belong,'') AS '机房归属',
    IFNULL(ma.room_type,'') AS '机房类型',
    IFNULL(ma.model,'') AS '机房规格',
    IFNULL(ma.room_longtitude,'') AS '机房经度',
    IFNULL(ma.room_latitude,'') AS '机房纬度',
    IFNULL(ma.room_address,'') AS '机房地址',
    IFNULL(ma.construction_type,'') AS '机房建设方式',
    '' AS '机房面积',
    IFNULL(ma.floor_num,'') AS '建筑物楼层数',
    IFNULL(ma.room_floor,'') AS '机房所在楼层',
    IFNULL(an.antenna_type,'') AS '1小区天线类型',
    IFNULL(an.pole_type,'') AS '1小区天线抱杆类型',
    IFNULL(an.pole_mast_model,'') AS '1小区天线抱杆规格',
    IFNULL(an.azimuth,'') AS '1小区天线方位角',
    IFNULL(an.hanging_height,'') AS '1小区天线挂高',
    IFNULL(an.elect_dip_angle1,'') AS '1小区天线机械+电子下倾角',
    IFNULL(an.antenna_num,'') AS '1小区天线数量',
    '' AS '1小区已有天线类型',
    IFNULL(an.antenna_type2,'') AS '2小区天线类型',
    IFNULL(an.pole_type2,'') AS '2小区天线抱杆类型',
    IFNULL(an.pole_mast_model2,'') AS '2小区天线抱杆规格',
    IFNULL(an.azimuth2,'') AS '2小区天线方位角',
    IFNULL(an.hanging_height2,'') AS '2小区天线挂高',
    IFNULL(an.elect_dip_angle2,'') AS '2小区天线机械+电子下倾角',
    IFNULL(an.antenna_num2,'') AS '2小区天线数量',
    '' AS '2小区已有天线类型',
    IFNULL(an.antenna_type3,'') AS '3小区天线类型',
    IFNULL(an.pole_type3,'') AS '3小区天线抱杆类型',
    IFNULL(an.pole_mast_model3,'') AS '3小区天线抱杆规格',
    IFNULL(an.azimuth3,'') AS '3小区天线方位角',
    IFNULL(an.hanging_height3,'') AS '3小区天线挂高',
    IFNULL(an.elect_dip_angle3,'') AS '3小区天线机械+电子下倾角',
    IFNULL(an.antenna_num3,'') AS '3小区天线数量',
    '' AS '3小区已有天线类型',
    IFNULL(an.antenna_type4,'') AS '4小区天线类型',
    IFNULL(an.pole_type4,'') AS '4小区天线抱杆类型',
    IFNULL(an.pole_mast_model4,'') AS '4小区天线抱杆规格',
    IFNULL(an.azimuth4,'') AS '4小区天线方位角',
    IFNULL(an.hanging_height4,'') AS '4小区天线挂高',
    IFNULL(an.elect_dip_angle4,'') AS '4小区天线机械+电子下倾角',
    IFNULL(an.antenna_num4,'') AS '4小区天线数量',
    '' AS '4小区已有天线类型',
    IFNULL(bbu.build_type,'') AS 'BBU建设方式',
    IFNULL(bbu.standard,'') AS 'BBU频段',
    IFNULL(bbu.product,'') AS 'BBU生产厂家',
    IFNULL(bbu.model_type,'') AS 'BBU设备型号',
    IFNULL(bbu.deploy,'') AS 'BBU载频配置',
    IFNULL(rru.build_type,'') AS 'RRU建设方式',
    IFNULL(rru.product,'') AS 'RRU厂家',
    IFNULL(rru.model_type,'') AS 'RRU设备型号'
FROM
    t_task_info t
LEFT JOIN
    t_project_main m
ON
    t.pid=m.id
LEFT JOIN
    mdi_basestation z
ON
    t.id=z.taskid
LEFT JOIN
    mdi_face f
ON
    t.id=f.taskid
LEFT JOIN
    mdi_machine_room ma
ON
    t.id=ma.taskid
LEFT JOIN
    mdi_antenna an
ON
    t.id=an.taskid
LEFT JOIN
    mdi_td_lte_bbu bbu
ON
    t.id=bbu.taskid
LEFT JOIN
    mdi_td_lte_rru rru
ON
    t.id=rru.taskid
LEFT JOIN
    t_area a
ON
    t.province=a.value
LEFT JOIN
    t_area b
ON
    t.city_id=b.value
LEFT JOIN
    t_area c
ON
    t.county_id=c.value
INTO
    outfile '/data/exportdata/CQ-SER-${DATE}-$n.csv' fields terminated BY ',' optionally
    enclosed BY '' lines terminated BY '\r\n';
EOF
}

function download_usr(){
mysql sdcmp << EOF
SELECT
    (@i:=@i+1) AS '序号',
    IFNULL(a.username,'') AS '用户名',
    IFNULL(a.realname,'') AS '用户姓名',
    IFNULL(b.mobilePhone,'') AS '用户手机号码',
    IFNULL(b.email,'') AS '用户邮箱',
    '' AS '用户所属省份',
    '' AS '用户所属地市',
    IFNULL(d.departname,'') AS '用户所属单位',
    IFNULL(DATE_FORMAT(b.create_date,'%Y%m%d'),'') AS '创建日期',
    IFNULL(DATE_FORMAT(a.outofservicetime,'%Y%m%d'),'') AS '失效日期'
FROM
    t_s_base_user a
LEFT JOIN
    t_s_user b
ON
    a.id=b.id
LEFT JOIN
    t_s_user_org c
ON
    a.id=c.user_id
LEFT JOIN
    t_s_depart d
ON
    c.org_id=d.id,
    (
        SELECT
            @i:=0) AS it
INTO
    outfile '/data/exportdata/CQ-USR-${DATE}-$j.csv' fields terminated BY ',' optionally enclosed BY '' lines terminated BY '\r\n';

EOF
}

#上传生成的文件到ftp服务器
function sendfile(){
lftp -u 'cq','cqsftp' sftp://192.168.0.14 << EOF
cd cq
lcd /data/exportdata
put $1
bye
EOF
}

#执行sql语句导出文档.不传入参数时全部导出.有传入参数时根据传入的参数导出对应文件
if [ $# -eq 0 ]
then
	download_usr
	download_pro
	download_app
	download_ser
	sendfile CQ-USR-${DATE}-$j.csv
	sendfile CQ-SER-${DATE}-$n.csv
	sendfile CQ-APP-${DATE}-$i.csv
	sendfile CQ-PRO-${DATE}-$m.csv
	name="SER-APP-PRO-USR"
	printlog ${name}
else
	case "$1" in
		ser)	download_ser
			sendfile CQ-USR-${DATE}-$j.csv
			printlog SER;;
		app)	download_app
			sendfile CQ-APP-${DATE}-$i.csv
			printlog APP;;
		pro)	download_pro
			sendfile CQ-PRO-${DATE}-$m.csv
			printlog PRO;;
		usr)	download_usr
			sendfile CQ-USR-${DATE}-$j.csv
			printlog USR;;
	esac
fi	
