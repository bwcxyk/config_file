#!/bin/bash
set -e
#set -x
# 选择发布后执行加固
if [ "$IS_PUBLISH" = "prod" ];then

# 应用宝渠道使用乐固加固（sid和skey在腾讯云申请）

    echo "----------------tencent加固开始----------------"
    java -Dfile.encoding=utf-8 \
    -jar ms-shield.jar \
    -sid "SecretId" \
    -skey "SecretKey" \
    -uploadPath ${WORKSPACE}/app/build/outputs/apk/release/app-release.apk \
    -downloadPath ${WORKSPACE}/app/build/outputs/apk/release/

    echo "----------------tencent加固结束----------------"
    echo "----------------开始签名apk----------------"
    # 加固完成后使用签名 老版本java签名
    jarsigner -verbose \
    -keystore ${WORKSPACE}/app/app.jks \
    -storepass "android" \
    -keypass "android" \
    -signedjar ${WORKSPACE}/app/build/outputs/apk/release/app-release_legu_signed.apk \
    ${WORKSPACE}/app/build/outputs/apk/release/app-release_legu.apk \
    key0 \
    -tsa http://sha256timestamp.ws.symantec.com/sha256/timestamp

#以下功能暂不使用
if false; then

#:<<EOF
# 加固完成后使用签名 新版本Android签名 默认使用V1和V2两种方式签名
sh /var/jenkins_home/android/sdk/build-tools/28.0.3/apksigner sign \
--ks ${WORKSPACE}/app/app.jks \
--ks-key-alias key0 \
--ks-pass pass:android \
--key-pass pass:android \
--out ${WORKSPACE}/app/build/outputs/apk/release/app-release_legu_signed.apk \
${WORKSPACE}/app/build/outputs/apk/release/app-release_legu.apk
# EOF
# 其他渠道使用360加固

		echo "----------------360加固----------------"
java -jar Android/360firm_mac/jiagu/jiagu.jar \
-jiagu ${WORKSPACE}/app/build/outputs/apk/upload.apk \
${WORKSPACE}/app/jiagu \
-autosign \
-pkgparam ${WORKSPACE}/app/channels.txt

# 进入app目录
cd ${WORKSPACE}/app
# 压缩jiagu文件夹
tar - zcvf jiaguAPK.gz jiagu
# 上传oss
		echo "----------------上传到OSS----------------"
ALI_OSS_ENDPOINT = "oss-cn-shanghai.aliyuncs.com"
ALI_OSS_AK = "YOUR AK"
ALI_OSS_SK = "YOUR SK"
BUILD_TIME =$(date "+%Y%m%d_%H_%M_%S")
UPLOAD_MOUTH =$(date "+%Y%m%d")
# 打开oss命令文件夹
cd ${WORKSPACE}/ossuploadconfig
# 配置oss
./ossutilmac64 config -e ${ALI_OSS_ENDPOINT} -i ${ALI_OSS_AK} -k ${ALI_OSS_SK}
# 上传apk到oss
./ossutilmac64 cp "${WORKSPACE}/app/jiaguAPK.gz" \
"oss://bucket/app/android/jaiguapk/${UPLOAD_MOUTH}/jiaguAPK_${BUILD_TIME}.gz"

DOWLOADURL = 'http://bucket.oss-cn-beijing.aliyuncs.com/app/android/jaiguapk/'${UPLOAD_MOUTH}'/jiaguAPK_'${BUILD_TIME}'.gz'
echo '下载地址：'${DOWLOADURL}''
fi

fi
