<template>
  <el-container id="app">
    <el-main>
      <Home />
    </el-main>
    <el-footer id="app-footer">
      <div>
        <a href="https://github.com/QDwbd/unlockmc" target="_blank">音乐解锁</a>({{ version }})
        ：移除已购音乐的加密保护。
      </div>
      <div>
        目前支持 网易云音乐(ncm), QQ音乐(qmc, mflac, mgg), 酷狗音乐(kgm), 虾米音乐(xm), 酷我音乐(.kwm)
      </div>
      <div>
        <!--如果进行二次开发，此行版权信息不得移除且应明显地标注于页面上-->
        <span>Copyright &copy; 2019 - {{ new Date().getFullYear() }} MengYX</span>
        音乐解锁使用
        <a href="https://github.com/QDwbd/unlockmc/blob/main/LICENSE" target="_blank">MIT许可协议</a>
        开放源代码
      </div>
    </el-footer>
  </el-container>
</template>

<script>
import FileSelector from '@/component/FileSelector';
import PreviewTable from '@/component/PreviewTable';
import config from '@/../package.json';
import Home from '@/view/Home';
import { checkUpdate } from '@/utils/api';

export default {
  name: 'app',
  components: {
    FileSelector,
    PreviewTable,
    Home,
  },
  data() {
    return {
      version: config.version,
    };
  },
  created() {
    this.$nextTick(() => this.finishLoad());
  },
  methods: {
    async finishLoad() {
      const mask = document.getElementById('loader-mask');
      if (!!mask) mask.remove();
      let updateInfo;
      try {
        updateInfo = await checkUpdate(this.version);
      } catch (e) {
        console.warn('check version info failed', e);
      }
      if (
        updateInfo &&
        process.env.NODE_ENV === 'production' &&
        (updateInfo.HttpsFound || (updateInfo.Found && window.location.protocol !== 'https:'))
      ) {
        this.$notify.warning({
          title: '发现更新',
          message: `发现新版本 v${updateInfo.Version}<br/>更新详情：${updateInfo.Detail}<br/> <a target="_blank" href="${updateInfo.URL}">获取更新</a>`,
          dangerouslyUseHTMLString: true,
          duration: 15000,
          position: 'top-left',
        });
      } else {
        this.$notify.info({
          title: '离线使用',
          message: `<div>
                        <p>我们使用 PWA 技术，无网络也能使用</p>
                        <div class="update-info">
                            <div class="update-title">最近更新</div>
                            <div class="update-content"> ${config.updateInfo} </div>
                        </div>
                        <a target="_blank" href="https://github.com/QDwbd/unlockmc">音乐解锁</a>
                    </div>`,
          dangerouslyUseHTMLString: true,
          duration: 10000,
          position: 'top-left',
        });
      }
    },
  },
};
</script>

<style lang="scss">
@import 'scss/unlock-music';
</style>
