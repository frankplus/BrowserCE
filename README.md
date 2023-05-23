# BrowserCE

<img src="entry/src/main/resources/base/media/icon.png" width="128px" />

## 项目介绍

OpenHarmony 浏览器社区版，在原版Demo基础上做定制修改和优化

- 本项目是基于 OpenHarmony官方组织应用示例仓库中的 Browser 子项目进行二次开发的社区版本，同样为 Apache 2.0 许可  
- 原项目地址：https://gitee.com/openharmony/applications_app_samples/tree/weekly_20230314/code/BasicFeature/Web/Browser  
- 由于原仓库是所有示例应用的大合集，并不方便外部开发者单独fock进行衍生开发，这里单独拉取了Browser子项目的源代码  
- 原版在`weekly_20230321`分支配置从API9改成了API10，其他不变，暂时选择`weekly_20230314`分支基础上进行二开
- 即使用新版的代码，实际上替换9或者10的Full-SDK后，配置直接改成API9，依然是可以直接运行的
- 原始 [README.md](./README_zh.origin.md)

## 修改说明

> 后续修改说明将不在这里补充，具体请查看commit中的信息

- 修复地址栏字体太大被遮挡
- 修复地址栏输入非https时无法跳转
- 多处https前缀追加移除，兼容http地址
- PhoneLayout图标和布局调整，一行显示更多
- 沉浸适配，底部tab和加载进度条优化

## 开发环境

> [Full-SDK编译和替换指南](https://gitee.com/openharmony/docs/blob/OpenHarmony-3.2-Release/zh-cn/application-dev/quick-start/full-sdk-compile-guide.md)

- DevEco Studio 3.1 Release
- SDK API9 3.2.12.5 Release (Full-SDK)

## 截图预览

<img src="screenshots/02.jpg" width="300px" />

## 视频演示

https://www.bilibili.com/video/BV1Xs4y1S7UW