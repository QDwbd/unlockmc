
### 自行构建

- 环境要求
  - nodejs (v22.x)
  - npm

1. 获取项目源代码后安装相关依赖：

   ```sh
   npm install
   npm ci
   ```

2. 然后进行构建：

   ```sh
   npm run build
   ```

   - 构建后的产物可以在 `dist` 目录找到。
   - 如果需要github page可以执行 `npm run deploy`。
   - 如果是用于开发，可以执行 `npm run serve`。

3. 如需构建浏览器扩展，构建成功后还需要执行：

   ```sh
   npm run make-extension
   ```
## 前言

[JOOX Music](https://play.google.com/store/apps/details?id=com.tencent.ibg.joox)（[官网](https://www.joox.com/)）的 *设备 UUID*（设备唯一识别码）是一个在应用安装后的初次启动之时随机生成的值。

它由 32 位十六进制字符（数字 `0`-`9` 以及字母 `a`-`f`）组成，像下面这样：

```text
12345678901234567890aabbccddeeff
```

生成后，该值将被安全的储存至软件的私有目录下，不能被外部访问。

因此，你需要使用一些“技巧”来获取它。当然，每种方法都有各自的风险，请在操作前三思而后行。

⚠️ 警告：请不要公开你的设备 UUID，因为 JOOX 会上报当前设备信息。如果一定要提供样本，建议直接联系开发人员提供。

### 手机 root 法

⚠️ 警告

- 手机进行 root 后可能会造成预料外的后果，因此不推荐使用 _主力设备_ 来进行 root 操作。
  - 可能的后果包括但不限于：部分应用拒绝启动、不兼容、或系统无法正常使用。
  - 作者不对此后果负责。

#### 📦 准备工作

<details open>
<summary><strong>在移动设备操作</strong></summary>

  1. 安装<ruby>终端模拟器<rp>(</rp><rt>Terminal Emulator for Android</rt><rp>)</rp></ruby>：[Google Play](https://play.google.com/store/apps/details?id=jackpal.androidterm) | [F-Droid](https://f-droid.org/en/packages/jackpal.androidterm/) | [GitHub](https://jackpal.github.io/Android-Terminal-Emulator/)
  2. 启动终端模拟器，键入 `su` 并回车确认。
  3. 若询问 “超级用户请求”，将授权限制从 “永久” 更改为 “_仅此一次_”，然后轻触 “允许” 继续  
![自动弹出的“超级用户请求”](https://git.unlock-music.dev/um/joox-crypto/wiki/raw/imgs/root-permission.png "自动弹出的“超级用户请求”")
</details>

<details><summary><strong>在电脑操作</strong></summary>

  1. 安装 adb 工具包并安装对应驱动
  2. 启用 “开发者模式” → “允许 USB 调试”
  3. 在电脑终端或控制台键入 `adb shell su` 并回车
  4. 若询问 “超级用户请求”，将授权限制从 “永久” 更改为 “_仅此一次_”，然后轻触 “允许” 继续  
![自动弹出的“超级用户请求”](https://git.unlock-music.dev/um/joox-crypto/wiki/raw/imgs/root-permission.png "自动弹出的“超级用户请求”")
</details>

准备好后，粘贴（推荐）或键入下述内容获得设备 UUID（32 位字符）：

```sh
grep -aoE "OPENUDID2[^0-9a-f]*([0-9a-f]{32})" /data/data/com.tencent.ibg.joox/files/mmkv/globalconfig | tail -c 33
```

你应该看到如下图所示的内容，一行乱码般的文字：

![输出示例](https://git.unlock-music.dev/um/joox-crypto/wiki/raw/imgs/exec-grep-command.png "输出示例")

双击这串设备 UUID 文字，然后右键复制即可。

### 虚拟 Xposed 环境（待完成）

⚠️ 注意

- 该方法不需要 root。
- 该方法可能会被检测而**导致账号或设备被封锁**。
    - 作者不对此后果负责。
- 该方法无法解密现有的加密文件。
- 你需要重新安装一次 JOOX，因为需要重新安装一份应用副本到虚拟 Xposed 环境内。
    - 这意味着你已经下载好的文件无法被解密。
- 此后无法从 Google Play 升级 JOOX。

📦 准备工作

- [太极框架](https://taichi.cool/zh/)或同类框架

未完待续…

### 重置法

⚠️ 注意

- 该方法不需要 root
- 该方法需要重置应用数据或重新安装
    - 这意味着你已经下载好的文件无法被解密。

📦 准备工作

- 安装 JOOX Music
- 启用 “开发者模式” → “允许 USB 调试”
- 安装 ADB 套件 → [Android Platform Tools](https://developer.android.com/studio/releases/platform-tools#downloads) 或使用包管理器安装；
- 将设备连接到到电脑。

1. 在电脑启动终端（cmd 或 [Windows Terminal](https://www.microsoft.com/zh-cn/p/jixun/9n0dx20hk701)），粘贴键入下述内容并回车：

   ```bash
   adb logcat -e "getOpenUUID"
   ```

    - 若是看到 `--------- beginning of main` 则表示一切正常。

2. 回到手机，长按应用图标，选择“应用信息”  
  ![长按应用图标](https://git.unlock-music.dev/um/joox-crypto/wiki/raw/imgs/long-press-icon.png)
3. 依次选择 “储存和缓存” → “清除储存空间”  
  ![](https://git.unlock-music.dev/um/joox-crypto/wiki/raw/imgs/storage-option.png)
4. 在弹出的信息框选择确定：  
![](https://git.unlock-music.dev/um/joox-crypto/wiki/raw/imgs/confirm-data-removal.png)
5. 回到启动器主页并打开 Joox Music 应用，等待其显示登入界面。
6. 回到终端，此时会显示一串文字。双击这串设备 UUID 文字，然后右键复制即可。  
![ADB 的 logcat 显示的设备 UUID 值](https://git.unlock-music.dev/um/joox-crypto/wiki/raw/imgs/adb_logcat.png "ADB 的 logcat 显示的设备 UUID 值")