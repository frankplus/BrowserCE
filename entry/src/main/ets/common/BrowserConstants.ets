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

// UI Constants
export const BUTTON_WIDTH: number = 22
export const BUTTON_RADIUS: number = 4
export const DOWN_COLOR: string = '#e4e4e4'
export const UP_COLOR: string = '#00000000'

// User Agent Constants
// 不设置UA，测试实际UA
// Mozilla/5.0 (X11; Linux aarch64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/99.0.4844.88 Mobile Safari/537.36

// 官方浏览器demo设置的UA
// const PAD_USER_AGENT: string = 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTMl, like Gecko) Chrome/92.0.4515.105 Safari/537.36'
// const PHONE_USER_AGENT: string = 'Mozilla/5.0 (Linux; Android 9; VRD-AL10; HMSCore 6.3.0.331) AppleWebKit/537.36 (KHTMl, like Gecko) Chrome/92.0.4515.105 HuaweiBrowser/12.0.4.1 Mobile Safari/537.36'

// UA修正（参考原UA和HarmonyOS3.0的UA）
export const PAD_USER_AGENT: string = 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTMl, like Gecko) Chrome/99.0.4844.88 Safari/537.36'
export const PHONE_USER_AGENT: string = 'Mozilla/5.0 (Linux; Android 10.0; OpenHarmony 3.2; ohos) AppleWebKit/537.36 (KHTMl, like Gecko) Chrome/99.0.4844.88 Mobile Safari/537.36'

// Button Interface
export interface ButtonItem {
  imageSrc: Resource
  id: number
}

// Test Object Interface
export interface TestObj {
  test: (addr: string) => void;
  searchWord: (word: string) => void;
}
