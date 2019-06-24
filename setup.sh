#!/bin/bash

#xcodebuild archive -project 'test.xcodeproj' -configuration 'Debug' -scheme 'BLTSZY' -archivePath './app.xcarchive' LIBRARY_SEARCH_PATHS="./Pods/../build/**  ./BLTSZY/**"
proName='xiaoqu-ios'
proURL="/Users/Jerry/Desktop/ios_afu/xiaoqu-ios"
api_key='2e8571d626b9a8c8b752e59624481847'
configuration='Debug' #Release
#打包
arch(){
    echo '开始编译Pods'
    xcodebuild -project Pods/Pods.xcodeproj build
    echo '开始编译project'

xcodebuild -archivePath "./build/${proName}.xcarchive" -workspace $proName.xcworkspace -sdk iphoneos -scheme $proName -configuration $configuration archive
}
#导出ipa
exportIPA(){
    echo '开始导出ipa'
    xcodebuild -exportArchive -archivePath "./build/${proName}.xcarchive" -exportPath './app' -exportOptionsPlist './ExportOptions.plist'
}
#上传ipa到蒲公英
upload(){
if [ -e "${proURL}/app/${proName}.ipa" ]
then
    echo '开始上传ipa/apk到蒲公英'
    curl -F "file=@${proURL}/app/${proName}.ipa" -F "_api_key=${api_key}" 'http://www.pgyer.com/apiv2/app/upload'
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


if (($# == 0))
#then
#    startarch
#elif (($# == 1))
then
        while :
        do
        echo '🍺🍺🍺***********************🍺🍺🍺'
        echo  "输入 1 到 4 之间的数字:"
        echo  "输入 1:从编译打包开始至结束"
        echo  "输入 2:从导出IPA开始至结束"
        echo  "输入 3:从上传ipa开始至结束"
        echo  "输入 4:退出"
        read a
        case $a in
            1)startarch
            break;;
            2)startExportIPA
            break;;
            3)startUPLoadIPA
            break;;
            4) break;;
        esac
        done
fi
