#!/bin/bash

#xcodebuild archive -project 'test.xcodeproj' -configuration 'Debug' -scheme 'BLTSZY' -archivePath './app.xcarchive' LIBRARY_SEARCH_PATHS="./Pods/../build/**  ./BLTSZY/**"
proName='your project name'
proURL="your project path"#like /Users/Jerry/Desktop/ios_afu
api_key=''#pgyer api_key
configuration='Debug' #Release
msg=''
msg2=''

autoPlus(){
#path=${proURL}/${proName}/${proName}/Info.plist
#number=$(/usr/libexec/PlistBuddy -c "Print CFBundleVersion" "${path}")
#BundleVersion=$(( $number + 1 ))
#/usr/libexec/PlistBuddy -c "Set CFBundleVersion $BundleVersion" "${path}"
agvtool next-version -all

}

#打包
arch(){
starttime=`date +%s`
    echo '开始编译Pods'
    xcodebuild -project Pods/Pods.xcodeproj build
    echo '开始编译project'

xcodebuild -archivePath "./build/${proName}.xcarchive" -workspace $proName.xcworkspace -sdk iphoneos -scheme $proName -configuration $configuration archive

    autoPlus
endtime=`date +%s`
echo ""
msg="打包时间： $((endtime-starttime))s"
echo ""
}
#导出ipa
exportIPA(){
starttime=`date +%s`
    echo '开始导出ipa'
    xcodebuild -exportArchive -archivePath "./build/${proName}.xcarchive" -exportPath './app' -exportOptionsPlist './ExportOptions.plist'
echo ""
msg2="导出时间： $((endtime-starttime))s"
echo ""
}
#上传ipa到蒲公英
upload(){
if [ -e "${proURL}/app/${proName}.ipa" ]
then
starttime=`date +%s`
    echo '开始上传ipa/apk到蒲公英'
    curl -F "file=@${proURL}/app/${proName}.ipa" -F "_api_key=${api_key}" 'http://www.pgyer.com/apiv2/app/upload'
endtime=`date +%s`
echo ""
echo $msg
echo $msg2
echo "上传时间： $((endtime-starttime))s"
echo ""
else
    echo "在目录：${proURL}/app/${proName}.ipa 不存在"
fi
}
startarch(){
    arch
    if (($? == 0))
    then
        echo 'archive success🍺'
        startExportIPA
    else
        echo 'archive faild❌'
    fi
}
startExportIPA(){
    exportIPA
    if(($? == 0))
    then
        echo 'exportIPA success🍺🍺'
        startUPLoadIPA
    else
        echo 'exportIPA faild ❌'
    fi
}
startUPLoadIPA(){
    upload
    if(($? == 0))
    then
        echo 'uploadIPA success'
    else
        echo 'uploadIPA faild ❌'
    fi
}


while :
do
echo '🍺🍺🍺***********************🍺🍺🍺'
echo  "输入 1 到 4 之间的数字:"
echo  "输入 1:从编译打包开始至结束"
echo  "输入 2:从导出IPA开始至结束"
echo  "输入 3:从上传ipa开始至结束"
echo  "输入 4:删除cache and ipa"
echo  "输入 5:退出"
read a
case $a in
    1)startarch
    break;;
    2)startExportIPA
    break;;
    3)startUPLoadIPA
    break;;
    4)rm -rf ./app
    rm -rf ./build
    break;;
    5) break;;
esac
done

