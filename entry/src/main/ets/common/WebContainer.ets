/*
 * Copyright (c) 2022-2023 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
import { BusinessError } from '@kit.BasicServicesKit';
import { PromptAction, UIContext } from "@ohos.arkui.UIContext";
import { webview } from '@kit.ArkWeb';
import { Browser, LoadingStatus, WebObject } from '../model/Browser'
import Logger from '../model/Logger'
import { LongPressMenuDialog } from './CustomDialog'
import { WebKey } from '../model/Browser'
import { TestObj, PAD_USER_AGENT, PHONE_USER_AGENT } from './BrowserConstants'

const TAG: string = '[WebContainer]'

@Component
export struct WebContainer {
  @Link browser: Browser;
  @Link isPhone: boolean;
  // @Link hideToolBar: Boolean;
  isRegistered: boolean = false
  uiContext: UIContext = this.getUIContext();
  promptAction: PromptAction = this.uiContext.getPromptAction();

  testObj: TestObj = {
    test: (addr: string) => {
      Logger.info(TAG, `addr= ${this.browser.tabArrayIndex}`)
      this.browser.webControllerArray[this.browser.tabArrayIndex].controller.loadUrl(addr) // 移除追加 https:// 前缀
    },
    searchWord: (word: string) => {
      Logger.info(`search word= ${word}`)
      let code = encodeURI(word)
      this.browser.webControllerArray[this.browser.tabArrayIndex].controller.loadUrl(`https://www.bing.com/search?q=${code}`)
    }
  }

  dialogController?: CustomDialogController = undefined;
  onCancel() {
    console.info('Callback when the first button is clicked')
  }
  onAccept() {
    console.info('Callback when the second button is clicked')
  }
  existApp() {
    console.info('Click the callback in the blank area')
  }

  dialogController2?: CustomDialogController = undefined;
  onCancel2() {
    console.info('Callback when the first button is clicked')
  }
  onAccept2() {
    console.info('Callback when the second button is clicked')
  }
  existApp2() {
    console.info('Click the callback in the blank area')
  }

  build() {
    Tabs({ barPosition: BarPosition.Start, controller: this.browser.tabsController }) {
      ForEach(this.browser.webArray, (item: WebKey) => {
        TabContent() {
          Web({
            src: this.isPhone ? $rawfile('phone.html') : $rawfile('pad.html'),
            controller: this.browser.webControllerArray[item.key] !== undefined ?
              this.browser.webControllerArray[item.key].controller : undefined
          })
            .databaseAccess(true)
            .onlineImageAccess(true)
            .javaScriptAccess(true)
            .fileAccess(true)
            .domStorageAccess(true)
            .onControllerAttached(() => {
              try {
                const customUserAgent = this.isPhone ? PHONE_USER_AGENT : PAD_USER_AGENT;
                this.browser.webControllerArray[item.key].controller.setCustomUserAgent(customUserAgent);
              } catch (error) {
                Logger.error(TAG, `setCustomUserAgent error: ${(error as BusinessError).code}, ${(error as BusinessError).message}`);
              }
            })
            .onPageBegin((event) => {
              Logger.info(TAG, `onPageBegin= ${JSON.stringify(event)}`)
              this.browser.loadingStatus = LoadingStatus.LOADING
            })
            .onPageEnd((event) => {
              Logger.info(TAG, `onPageEnd= ${JSON.stringify(event)}`)
              if (item.key < this.browser.webControllerArray.length && this.browser.webControllerArray[item.key].controller) {
                this.browser.webControllerArray[item.key].controller.runJavaScript('adapterDevice()')
                this.browser.loadingStatus = LoadingStatus.END
                this.registerFunc(this.browser.webControllerArray[item.key])
                if (event.url.startsWith('http')) {
                  this.browser.inputValue = event.url
                } else {
                  this.browser.inputValue = ''
                }
              }
            })
            .onProgressChange((event) => {
              Logger.info(TAG, `onProgressChange`)
              this.browser.progress = event.newProgress
              if (this.browser.progress === 100) {
                this.browser.hideProgress = true
              } else {
                this.browser.hideProgress = false
              }
            })
            .onInterceptRequest((event) => {
              console.log('url:' + event.request.getRequestUrl())
              return null;
            })
            // 自定义网址拦截器
            .onLoadIntercept((event) => {
              if (!event || !event.data) {
                return false
              }

              // 当前网址
              let url = event.data.getRequestUrl();
              console.log('onLoadIntercept ' + url)
              // 网址协议前缀
              let urlProtocolPrefix = 'unknown';
              try {
                urlProtocolPrefix = url.split('://')[0];
              } catch (e) {}
              // 拦截三方客户端协议前缀的网址
              if (!['http', 'https', 'file', 'data', 'resource'].includes(urlProtocolPrefix)) {
                this.promptAction.openToast({
                  message: $r('app.string.toast_block_protocol').toString() + urlProtocolPrefix,
                  duration: 1000
                }).catch((error: BusinessError) => {
                  console.error(`openToast error code is ${error.code}, message is ${error.message}`);
                });
                return true;
              }
              return false;
            })
            // 全屏
            .onFullScreenEnter(() => {
              // console.log("onFullScreenEnter...")
              // WindowStageUtil.setLayoutFullScreen(globalThis.windowStage, WindowStageUtil.COLOR_BLACK, WindowStageUtil.COLOR_WHITE, WindowStageUtil.COLOR_BLACK, WindowStageUtil.COLOR_WHITE);
              // this.hideToolBar = true;
            })
            .onFullScreenExit(() => {
              // console.log("onFullScreenExit...")
              // WindowStageUtil.setLayoutFullScreen(globalThis.windowStage, WindowStageUtil.COLOR_WHITE, WindowStageUtil.COLOR_BLACK, '#fdfdfd', WindowStageUtil.COLOR_BLACK);
              // this.hideToolBar = false;
            })
            // 长按菜单
            .onContextMenuShow((event) => {
              console.info("x coord = " + event.param.x())
              console.info("link url = " + event.param.getLinkUrl())
              // 长按事件
              if (event.param.getSourceType() == ContextMenuSourceType.LongPress) {
                // 自定义对话框
                this.dialogController = new CustomDialogController({
                  builder: LongPressMenuDialog({
                    browser: $browser,
                    linkUrl: event.param.getLinkUrl(),
                    existsImageContents: event.param.existsImageContents(),
                    sourceUrl: event.param.getSourceUrl(),
                    controller: this.dialogController
                  }),
                  cancel: this.existApp,
                  autoCancel: true,
                  alignment: DialogAlignment.Default,
                  offset: { dx: 0, dy: 0 },
                  gridCount: 3,
                  customStyle: false
                })
                this.dialogController.open()
              }
              return false;
            })
            // 监听下载
            .onDownloadStart((event) => {
              console.log('url:' + event.url)
              console.log('userAgent:' + event.userAgent)
              console.log('contentDisposition:' + event.contentDisposition)
              console.log('contentLength:' + event.contentLength)
              console.log('mimetype:' + event.mimetype)
            })
        }
        .padding({bottom: 35.5})
      })
    }
    .barHeight(0)
    .scrollable(false)
  }

  registerFunc(webObject: WebObject) {
    if (!webObject.isRegistered) {
      Logger.info(TAG, `registerFunc`)
      webObject.controller.registerJavaScriptProxy(this.testObj, 'etsObj', ['test', 'searchWord'])
      webObject.isRegistered = true
      webObject.controller.refresh()
    }
  }
}
