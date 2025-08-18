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
import { Browser } from '../model/Browser'
import Logger from '../model/Logger'
import { ButtonItem, BUTTON_WIDTH, BUTTON_RADIUS, DOWN_COLOR, UP_COLOR } from './BrowserConstants'

const TAG: string = '[TabletNavigationBar]'

@Component
export struct TabletNavigationBar {
  @Link browser: Browser;
  @State inputValue: string = ''
  @State arrayIndex: number = 0
  private addr: string = ''
  private navigationButton: Array<ButtonItem> = [
    {
      imageSrc: $r('app.media.ic_public_back'),
      id: 1
    } as ButtonItem,
    {
      imageSrc: $r('app.media.ic_public_advance'),
      id: 2
    } as ButtonItem,
    {
      imageSrc: $r('app.media.ic_public_refresh'),
      id: 3
    } as ButtonItem,
    {
      imageSrc: $r('app.media.ic_public_home'),
      id: 4
    } as ButtonItem,
  ]
  private actionButton: Array<ButtonItem> = [
    {
      imageSrc: $r('app.media.submit'),
      id: 5
    } as ButtonItem,
    {
      imageSrc: $r('app.media.ic_public_add'),
      id: 6
    } as ButtonItem,
  ]

  build() {
    Row() {
      ForEach(this.navigationButton, (item: ButtonItem) => {
        Button({ type: ButtonType.Normal }) {
          Image(item.imageSrc)
        }
        .margin(8)
        .width(BUTTON_WIDTH)
        .height(BUTTON_WIDTH)
        .backgroundColor(this.arrayIndex === item.id ? DOWN_COLOR : UP_COLOR)
        .borderRadius(BUTTON_RADIUS)
        .flexShrink(0)
        .onTouch((event: TouchEvent) => {
          if (event.type === TouchType.Down) {
            this.arrayIndex = item.id
          }

          if (event.type === TouchType.Up) {
            this.arrayIndex = 0
          }
        })
        .onClick((event: ClickEvent) => {
          switch (item.id) {
            case 1:
              this.browser.Back()
              break;
            case 2:
              this.browser.Forward()
              break;
            case 3:
              this.browser.Refresh()
              break;
            case 4:
              this.browser.webControllerArray[this.browser.tabArrayIndex].controller.loadUrl($rawfile('pad.html'))
              break;
          }
        })
      })

      TextInput({ placeholder: $r('app.string.placeholder_enter_url'), text: this.browser.inputValue })
        .placeholderFont({ size: 18, weight: 500 })
        .fontSize(18)
        .margin(2)
        .width('51%')
        .layoutWeight(1)
        .onChange((value: string) => {
          this.addr = value
        })
        .onSubmit((enterKey: EnterKeyType) => {
          Logger.info(TAG, `onSubmit`)
          if (this.addr.length !== 0) {
            this.browser.webControllerArray[this.browser.tabArrayIndex].controller.loadUrl(this.addr) // 移除追加 https:// 前缀
            this.addr = ''
          }
        })

      ForEach(this.actionButton, (item: ButtonItem) => {
        Button({ type: ButtonType.Normal }) {
          Image(item.imageSrc)
        }
        .margin(8)
        .width(BUTTON_WIDTH)
        .height(BUTTON_WIDTH)
        .backgroundColor(this.arrayIndex === item.id ? DOWN_COLOR : UP_COLOR)
        .borderRadius(BUTTON_RADIUS)
        .flexShrink(0)
        .onTouch((event: TouchEvent) => {
          if (event.type === TouchType.Down) {
            this.arrayIndex = item.id
          }
          if (event.type === TouchType.Up) {
            this.arrayIndex = 0
          }
        })
        .onClick((event: ClickEvent) => {
          if (item.id === 5) {
            this.browser.loadUrl(this.addr)
            this.addr = ''
          } else if (item.id === 6) {
            Logger.info(TAG, `add tab index = ` + this.arrayIndex)
            this.browser.addTab()
          }
        })
      })
    }
    .width('100%')
    .padding({ right: 5 })
  }
}
