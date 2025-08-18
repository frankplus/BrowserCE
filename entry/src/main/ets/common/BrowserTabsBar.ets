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
import { DOWN_COLOR } from './BrowserConstants'
import { WebKey } from '../model/Browser'

const TAG: string = '[BrowserTabsBar]'

@Component
export struct BrowserTabsBar {
  @Link browser: Browser;
  @State tabButtonIndex: number = -1;

  build() {
    Flex({ direction: FlexDirection.Row, alignItems: ItemAlign.Start }) {
      ForEach(this.browser.webArray, (item: WebKey) => {
        Row() {
          Row() {
            Text($r('app.string.tab_home'))
          }.width('100%').flexShrink(1).justifyContent(FlexAlign.Center).height('100%')

          Button({ type: ButtonType.Normal }) {
            Image($r('app.media.ic_public_cancel_filled')).width(24).height(24)
          }
          .backgroundColor(this.tabButtonIndex == item.key ? DOWN_COLOR : '#00000000')
          .margin({ right: 2 })
          .width(33)
          .height(33)
          .borderRadius(5)
          .onTouch((event: TouchEvent) => {
            if (event.type === TouchType.Down) {
              this.tabButtonIndex = item.key
            } else if (event.type == TouchType.Up) {
              this.tabButtonIndex = -1
            }
          })
          .onClick((event: ClickEvent) => {
            if (this.browser.webArray.length > 1) {
              this.browser.deleteTab(item.key)
            }
          })
        }.width(180).height('100%').backgroundColor(this.browser.tabArrayIndex == item.key ? '#ffffff' : '#ececec')
        .onClick((event: ClickEvent) => {
          Logger.info(TAG, `key= ${item.key}`)
          this.browser.setTabArrayIndex(item.key)
          this.browser.tabsController.changeIndex(item.key)
        })

        Divider().vertical(true).color('#c6c6c6')
      })
    }.height(33).flexShrink(0).backgroundColor('#ececec')
  }
}
