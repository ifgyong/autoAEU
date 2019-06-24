# autoAEU
auto archive exportipa and upload pgyer shell code
之前使用的fastlane添加pgyer自动打包的，最近发现更新总是有问题，所以产生了自己shell做一个想法。
- 打包
- 导出ipa
- 上传pgyer

|proName        |工程名字        |
|---------------|---------------|
|proURL |工程目录|
|api_key |蒲公英 pai key|
|configuration | 测试Debug 线上Release|


plist文件：

|compileBitcode |是否开启bitcode|
|---------------|---------------|
|method         |ad-hoc         |
|signingStyle|manual 自动|
|teamID|team id|
|provisioningProfiles|bundleid and mobileprovsion|

运行`./setup.sh`，即可完成上传到pgyer网站。
