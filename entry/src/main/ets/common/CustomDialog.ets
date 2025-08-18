/*
 * Copyright (C) 2023 westinyang https://gitee.com/ohos-dev
 *
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

import pasteboard from '@ohos.pasteboard'
import { BusinessError } from '@kit.BasicServicesKit';
import { PromptAction, UIContext } from "@ohos.arkui.UIContext";
import request from '@ohos.request'
import installer from '@ohos.bundle.installer'
import { Browser } from '../model/Browser'
import fs from '@ohos.file.fs'

const ToastDuration = 1000

/**
 * 长按菜单对话框
 */
@CustomDialog
struct LongPressMenuDialog {
  @Link browser: Browser
  linkUrl: string = ''
  existsImageContents: boolean = false
  sourceUrl: string = ''
  controller: CustomDialogController
  uiContext: UIContext = this.getUIContext();
  promptAction: PromptAction = this.uiContext.getPromptAction();

  aboutToAppear() {
  }

  build() {
    Column() {
      if (this.linkUrl.trim().length > 0) {
        Button($r('app.string.dialog_open_link')).width('100%').margin({bottom: 15}).onClick((e) => {
          this.browser.webControllerArray[this.browser.tabArrayIndex].controller.loadUrl(this.linkUrl)
          this.controller.close()
        })
        Button($r('app.string.dialog_copy_link')).width('100%').margin({bottom: 15}).onClick((e) => {
          this.copyText($r('app.string.copy_type_link').toString(), this.linkUrl)
          this.controller.close()
        })
      }
      if (this.existsImageContents && this.sourceUrl.length > 0) {
        Button($r('app.string.dialog_open_image_link')).width('100%').margin({bottom: 15}).onClick((e) => {
          this.browser.webControllerArray[this.browser.tabArrayIndex].controller.loadUrl(this.sourceUrl)
          this.controller.close()
        })
        Button($r('app.string.dialog_copy_image_link')).width('100%').margin({bottom: 15}).onClick((e) => {
          this.copyText($r('app.string.copy_type_image_link').toString(), this.sourceUrl)
          this.controller.close()
        })
      }
    }.padding({ top: 15, bottom: 0, left: 15, right: 15 })
  }

  copyText(name: string, value: string) {
    // 复制
    let pasteData = pasteboard.createData(pasteboard.MIMETYPE_TEXT_PLAIN, value)
    pasteboard.getSystemPasteboard()
    let systemPasteboard = pasteboard.getSystemPasteboard();
    systemPasteboard.setData(pasteData, (err, data) => {
      if (err) {
        console.error('Failed to set PasteData. Cause: ' + err.message);
        return;
      }
      console.info('Succeeded in setting PasteData.');
      // 提示
      this.promptAction.openToast({
        message: $r('app.string.toast_copied').toString() + name,
        duration: 1000
      }).catch((error: BusinessError) => {
        console.error(`openToast error code is ${error.code}, message is ${error.message}`);
      });
    });
  }
}

export { LongPressMenuDialog }