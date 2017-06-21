#!/bin/bash
###SCRIPT_NAME:weixin.sh###
###send message from weixin for zabbix monitor###
###wuhf###
###V1-2015-08-25###

CropID='wxf49b980d434bc172'
Secret='MR_v1Xn3UYGT0coChtTivmTPzzeRB7-QmMXl9bez3a5Wmejv1e-ITpYTa-XRhdKV'
GURL="https://qyapi.weixin.qq.com/cgi-bin/gettoken?corpid=$CropID&corpsecret=$Secret"
Gtoken=$(/usr/bin/curl -s -G "$GURL" | awk -F\" '{print $4}')

PURL="https://qyapi.weixin.qq.com/cgi-bin/message/send?access_token=$Gtoken"
function body() {
        local int AppID=1                        #企业号中的应用id
        local UserID=$1                          #部门成员id，zabbix中定义的微信接收者
        local PartyID=1                          #部门id，定义了范围，组内成员都可接收到消息
        local Msg=$(echo "$@" | cut -d" " -f3-)  #过滤出zabbix传递的第三个参数
        printf '{\n'
        printf '\t"touser": "'"$UserID"\"",\n"
        printf '\t"toparty": "'"$PartyID"\"",\n"
        printf '\t"msgtype": "text",\n'
        printf '\t"agentid": "'" $AppID "\"",\n"
        printf '\t"text": {\n'
        printf '\t\t"content": "'"$Msg"\""\n"
        printf '\t},\n'
        printf '\t"safe":"0"\n'
        printf '}\n'
}

/usr/bin/curl --data-ascii "$(body $1 $2 $3)" $PURL
