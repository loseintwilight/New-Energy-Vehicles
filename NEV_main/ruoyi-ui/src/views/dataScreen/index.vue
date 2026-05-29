<template>
  <div class="data-screen-wrapper">
    <transition name="fade">
      <div v-if="loading" class="loading-overlay">
        <div class="loading-spinner">
          <div class="spinner-ring"></div>
          <div class="spinner-core"></div>
        </div>
        <p class="loading-title">数据大屏加载中</p>
        <p class="loading-text">{{ loadingText }}</p>
        <div class="loading-progress">
          <div class="progress-bar" :style="{ width: loadingProgress + '%' }"></div>
        </div>
      </div>
    </transition>

    <transition name="fade">
      <div v-if="error" class="error-overlay">
        <div class="error-box">
          <i class="el-icon-warning-outline"></i>
          <p>{{ error }}</p>
          <el-button type="primary" size="small" @click="retry">重试</el-button>
        </div>
      </div>
    </transition>

    <div v-show="!loading && !error" class="data-screen">
      <div class="bg-light-beam"></div>
      <div class="bg-particles">
        <span class="particle p1"></span>
        <span class="particle p2"></span>
        <span class="particle p3"></span>
        <span class="particle p4"></span>
        <span class="particle p5"></span>
        <span class="particle p6"></span>
        <span class="particle p7"></span>
        <span class="particle p8"></span>
        <span class="particle p9"></span>
        <span class="particle p10"></span>
        <span class="particle p11"></span>
        <span class="particle p12"></span>
        <span class="particle p13"></span>
        <span class="particle p14"></span>
        <span class="particle p15"></span>
      </div>
      <div class="bg-scanline"></div>
      <header class="screen-header">
        <div class="stats-row">
          <div class="stat-card card-carbon">
            <svg class="card-icon-svg" viewBox="0 0 48 48">
              <path d="M24 4c-3 8-8 14-8 22c0 5 3 10 8 12c5-2 8-7 8-12c0-8-5-14-8-22z" fill="none" stroke="#00E676" stroke-width="2.2" stroke-linejoin="round"/>
              <path d="M24 16v24" fill="none" stroke="#00E676" stroke-width="1.8" stroke-linecap="round"/>
              <path d="M18 28h12" fill="none" stroke="#00E676" stroke-width="1.5" stroke-linecap="round"/>
              <path d="M20 32h8" fill="none" stroke="#00E676" stroke-width="1" stroke-linecap="round" opacity="0.6"/>
            </svg>
            <div class="card-body">
              <span class="card-label">碳减排总量</span>
              <span class="card-value">
                <count-to :start-val="0" :end-val="totalReduction" :duration="2500" separator="," />
                <small>万吨</small>
              </span>
              <span class="card-trend up">同比 +12.5%</span>
            </div>
          </div>

          <div class="stat-card card-piles">
            <svg class="card-icon-svg" viewBox="0 0 48 48">
              <path d="M26 4l-8 16h7l-3 12l10-16h-7l3-12z" fill="none" stroke="#36A3F7" stroke-width="2.2" stroke-linejoin="round"/>
            </svg>
            <div class="card-body">
              <span class="card-label">充电桩总量</span>
              <span class="card-value">
                <count-to :start-val="0" :end-val="totalPiles" :duration="2500" separator="," />
                <small>个</small>
              </span>
              <span class="card-trend up">同比 +22.5%</span>
            </div>
          </div>

          <div class="stat-card card-ev">
            <svg class="card-icon-svg" viewBox="0 0 48 48">
              <path d="M10 30l5-12h18l5 12v4h-2v8h-8v-8h-8v8h-8v-8h-2v-4z" fill="none" stroke="#00E5FF" stroke-width="2.2" stroke-linejoin="round"/>
              <circle cx="16" cy="36" r="3" fill="none" stroke="#00E5FF" stroke-width="2"/>
              <circle cx="32" cy="36" r="3" fill="none" stroke="#00E5FF" stroke-width="2"/>
            </svg>
            <div class="card-body">
              <span class="card-label">新能源汽车保有量</span>
              <span class="card-value">
                <count-to :start-val="0" :end-val="totalEV" :duration="2500" separator="," />
                <small>辆</small>
              </span>
              <span class="card-trend up">同比 +15.8%</span>
            </div>
          </div>
        </div>
      </header>

      <section class="main-content">
        <div class="side-panel panel-left">
          <h4 class="panel-title">
            <i class="title-dot carbon-dot"></i>碳减排与植树排行
          </h4>
          <div class="table-scroll">
            <table class="data-table">
              <thead>
                <tr>
                  <th class="col-rank">#</th>
                  <th class="col-name">城市</th>
                  <th class="col-val">碳减排(吨)</th>
                  <th class="col-val">植树(棵)</th>
                </tr>
              </thead>
              <tbody>
                <tr v-for="(row, i) in leftCityData" :key="row.city" :class="{ 'row-top3': i < 3 }">
                  <td class="col-rank">
                    <span class="rank-badge" :class="'rank-' + (i + 1)">{{ i + 1 }}</span>
                  </td>
                  <td class="col-name">{{ row.city }}</td>
                  <td class="col-val">{{ row.metric1.toFixed(0) }}</td>
                  <td class="col-val">{{ row.trees.toLocaleString() }}</td>
                </tr>
              </tbody>
            </table>
          </div>
        </div>

        <div class="map-section">
          <div class="map-grid">
            <div class="floor-scene">
              <div class="grid-plane"></div>
              <div class="grid-fade"></div>
              <div class="horizon-glow"></div>
              <div class="horizon-line"></div>
            </div>
          </div>
          <div class="map-glow"></div>
          <div class="map-perspective">
            <div class="map-chart" ref="mapChart"></div>
          </div>
          <span class="breath-dot dot-tl"></span>
          <span class="breath-dot dot-tr"></span>
          <span class="breath-dot dot-bl"></span>
          <span class="breath-dot dot-br"></span>
          <div class="bottom-radar" :style="radarStyle">
            <span class="br-ring r1"></span>
            <span class="br-ring r2"></span>
            <span class="br-ring r3"></span>
            <span class="br-beam"></span>
          </div>
          <div class="map-legend">
            <span class="legend-item" @mouseenter="showLegendTip = true" @mouseleave="showLegendTip = false">
              <i class="legend-leaf-icon"></i>
              <span>综合环保指标</span>
              <transition name="tip-fade">
                <div class="legend-tooltip" v-show="showLegendTip">
                  <div class="tip-arrow"></div>
                  基于碳减排、新能源车、充电桩三指标综合评估
                </div>
              </transition>
            </span>
          </div>
        </div>

        <div class="side-panel panel-right">
          <h4 class="panel-title">
            <i class="title-dot pile-dot"></i>新能源车与充电桩排行
          </h4>
          <div class="table-scroll">
            <table class="data-table">
              <thead>
                <tr>
                  <th class="col-rank">#</th>
                  <th class="col-name">城市</th>
                  <th class="col-val">新能源车(辆)</th>
                  <th class="col-val">充电桩(个)</th>
                </tr>
              </thead>
              <tbody>
                <tr v-for="(row, i) in rightCityData" :key="row.city" :class="{ 'row-top3': i < 3 }">
                  <td class="col-rank">
                    <span class="rank-badge" :class="'rank-' + (i + 1)">{{ i + 1 }}</span>
                  </td>
                  <td class="col-name">{{ row.city }}</td>
                  <td class="col-val">{{ row.ev.toLocaleString() }}</td>
                  <td class="col-val">{{ row.piles.toLocaleString() }}</td>
                </tr>
              </tbody>
            </table>
          </div>
        </div>
      </section>

      <div class="action-buttons">
        <el-tooltip content="全屏展示" placement="left">
          <div class="action-btn" @click="toggleFullscreen">
            <svg-icon :icon-class="isFullscreen ? 'exit-fullscreen' : 'fullscreen'" />
          </div>
        </el-tooltip>
        <el-tooltip content="刷新数据" placement="left">
          <div class="action-btn" @click="refreshData">
            <i class="el-icon-refresh"></i>
          </div>
        </el-tooltip>
      </div>
    </div>
  </div>
</template>

<script>
import * as echarts from 'echarts'
import CountTo from 'vue-count-to'
import screenfull from 'screenfull'

const CHINA_GEOJSON_URL = 'https://geo.datav.aliyun.com/areas_v3/bound/100000_full.json'

const ICON_LEAF = 'path://M24 4 Q8 18 8 28 Q8 40 20 44 L24 38 L28 44 Q40 40 40 28 Q40 18 24 4 Z M24 38 L24 47'

const CENTROID_MAP = {
  '北京市': [116.46, 39.92], '天津市': [117.2, 39.13], '河北省': [114.48, 38.03],
  '山西省': [112.53, 37.87], '内蒙古自治区': [111.65, 40.82], '辽宁省': [123.38, 41.8],
  '吉林省': [125.35, 43.88], '黑龙江省': [126.63, 45.75], '上海市': [121.48, 31.22],
  '江苏省': [118.78, 32.04], '浙江省': [120.19, 30.26], '安徽省': [117.27, 31.86],
  '福建省': [119.3, 26.08], '江西省': [115.89, 28.68], '山东省': [117.0, 36.65],
  '河南省': [113.65, 34.76], '湖北省': [114.31, 30.52], '湖南省': [112.98, 28.19],
  '广东省': [113.23, 23.16], '广西壮族自治区': [108.33, 22.84], '海南省': [110.35, 20.02],
  '重庆市': [106.54, 29.59], '四川省': [104.06, 30.67], '贵州省': [106.71, 26.57],
  '云南省': [102.73, 25.04], '西藏自治区': [91.11, 29.97], '陕西省': [108.95, 34.27],
  '甘肃省': [103.73, 36.03], '青海省': [101.74, 36.56], '宁夏回族自治区': [106.27, 38.47],
  '新疆维吾尔自治区': [87.68, 43.77], '台湾省': [121.5, 25.05],
  '香港特别行政区': [114.17, 22.28], '澳门特别行政区': [113.55, 22.19]
}

const SHORT_NAME = {
  '内蒙古自治区': '内蒙古', '广西壮族自治区': '广西', '西藏自治区': '西藏',
  '宁夏回族自治区': '宁夏', '新疆维吾尔自治区': '新疆',
  '香港特别行政区': '香港', '澳门特别行政区': '澳门'
}

// 地级市坐标数据 [省名, 市名, 经度, 纬度]
const PREFECTURE_CITIES = genCityList()

function genCityList() {
  const C = CENTROID_MAP
  return [
    ['北京市','北京市',116.40,39.90], ['天津市','天津市',117.20,39.13],
    ['河北省','石家庄市',114.52,38.05],['河北省','唐山市',118.18,39.63],
    ['河北省','秦皇岛市',119.60,39.93],['河北省','邯郸市',114.48,36.60],
    ['河北省','邢台市',114.50,37.07],['河北省','保定市',115.47,38.87],
    ['河北省','张家口市',114.88,40.77],['河北省','承德市',117.93,40.95],
    ['河北省','沧州市',116.83,38.30],['河北省','廊坊市',116.70,39.52],
    ['河北省','衡水市',115.68,37.73],
    ['山西省','太原市',112.55,37.87],['山西省','大同市',113.30,40.08],
    ['山西省','阳泉市',113.58,37.85],['山西省','长治市',113.12,36.20],
    ['山西省','晋城市',112.85,35.50],['山西省','朔州市',112.43,39.33],
    ['山西省','晋中市',112.75,37.70],['山西省','运城市',111.00,35.03],
    ['山西省','忻州市',112.73,38.42],['山西省','临汾市',111.52,36.08],
    ['山西省','吕梁市',111.13,37.52],
    ['内蒙古自治区','呼和浩特市',111.75,40.82],['内蒙古自治区','包头市',109.83,40.65],
    ['内蒙古自治区','乌海市',106.82,39.67],['内蒙古自治区','赤峰市',118.92,42.27],
    ['内蒙古自治区','通辽市',122.27,43.62],['内蒙古自治区','鄂尔多斯市',109.78,39.62],
    ['内蒙古自治区','呼伦贝尔市',119.77,49.22],['内蒙古自治区','巴彦淖尔市',107.42,40.75],
    ['内蒙古自治区','乌兰察布市',113.12,40.98],['内蒙古自治区','兴安盟',122.07,46.08],
    ['内蒙古自治区','锡林郭勒盟',116.03,43.95],['内蒙古自治区','阿拉善盟',105.72,38.85],
    ['辽宁省','沈阳市',123.43,41.80],['辽宁省','大连市',121.62,38.92],
    ['辽宁省','鞍山市',123.00,41.12],['辽宁省','抚顺市',123.98,41.88],
    ['辽宁省','本溪市',123.77,41.30],['辽宁省','丹东市',124.38,40.13],
    ['辽宁省','锦州市',121.13,41.10],['辽宁省','营口市',122.22,40.67],
    ['辽宁省','阜新市',121.67,42.02],['辽宁省','辽阳市',123.17,41.27],
    ['辽宁省','盘锦市',122.07,41.12],['辽宁省','铁岭市',123.83,42.28],
    ['辽宁省','朝阳市',120.45,41.58],['辽宁省','葫芦岛市',120.83,40.72],
    ['吉林省','长春市',125.32,43.88],['吉林省','吉林市',126.55,43.85],
    ['吉林省','四平市',124.37,43.17],['吉林省','辽源市',125.13,42.88],
    ['吉林省','通化市',125.93,41.73],['吉林省','白山市',126.42,41.93],
    ['吉林省','松原市',124.82,45.13],['吉林省','白城市',122.83,45.62],
    ['吉林省','延边朝鲜族自治州',129.50,42.88],
    ['黑龙江省','哈尔滨市',126.63,45.75],['黑龙江省','齐齐哈尔市',123.95,47.35],
    ['黑龙江省','鸡西市',130.97,45.30],['黑龙江省','鹤岗市',130.27,47.35],
    ['黑龙江省','双鸭山市',131.15,46.63],['黑龙江省','大庆市',125.03,46.58],
    ['黑龙江省','伊春市',128.90,47.73],['黑龙江省','佳木斯市',130.37,46.82],
    ['黑龙江省','七台河市',130.95,45.78],['黑龙江省','牡丹江市',129.58,44.58],
    ['黑龙江省','黑河市',127.48,50.25],['黑龙江省','绥化市',126.98,46.63],
    ['黑龙江省','大兴安岭地区',124.12,50.42],
    ['上海市','上海市',121.47,31.23],
    ['江苏省','南京市',118.78,32.06],['江苏省','无锡市',120.30,31.57],
    ['江苏省','徐州市',117.18,34.27],['江苏省','常州市',119.95,31.77],
    ['江苏省','苏州市',120.58,31.30],['江苏省','南通市',120.88,32.00],
    ['江苏省','连云港市',119.22,34.60],['江苏省','淮安市',119.02,33.62],
    ['江苏省','盐城市',120.15,33.35],['江苏省','扬州市',119.40,32.40],
    ['江苏省','镇江市',119.43,32.20],['江苏省','泰州市',119.92,32.48],
    ['江苏省','宿迁市',118.28,33.97],
    ['浙江省','杭州市',120.15,30.28],['浙江省','宁波市',121.55,29.87],
    ['浙江省','温州市',120.70,28.00],['浙江省','嘉兴市',120.75,30.77],
    ['浙江省','湖州市',120.08,30.90],['浙江省','绍兴市',120.58,30.00],
    ['浙江省','金华市',119.65,29.10],['浙江省','衢州市',118.87,28.93],
    ['浙江省','舟山市',122.20,30.00],['浙江省','台州市',121.42,28.65],
    ['浙江省','丽水市',119.92,28.45],
    ['安徽省','合肥市',117.27,31.86],['安徽省','芜湖市',118.38,31.33],
    ['安徽省','蚌埠市',117.38,32.92],['安徽省','淮南市',117.00,32.63],
    ['安徽省','马鞍山市',118.50,31.70],['安徽省','淮北市',116.80,33.95],
    ['安徽省','铜陵市',117.82,30.93],['安徽省','安庆市',117.05,30.53],
    ['安徽省','黄山市',118.33,29.72],['安徽省','滁州市',118.32,32.30],
    ['安徽省','阜阳市',115.82,32.90],['安徽省','宿州市',116.98,33.63],
    ['安徽省','六安市',116.52,31.73],['安徽省','亳州市',115.78,33.85],
    ['安徽省','池州市',117.48,30.67],['安徽省','宣城市',118.75,30.95],
    ['福建省','福州市',119.30,26.08],['福建省','厦门市',118.08,24.48],
    ['福建省','莆田市',119.00,25.43],['福建省','三明市',117.62,26.27],
    ['福建省','泉州市',118.58,24.93],['福建省','漳州市',117.65,24.52],
    ['福建省','南平市',118.17,26.65],['福建省','龙岩市',117.03,25.10],
    ['福建省','宁德市',119.52,26.67],
    ['江西省','南昌市',115.86,28.68],['江西省','景德镇市',117.18,29.27],
    ['江西省','萍乡市',113.85,27.63],['江西省','九江市',116.00,29.70],
    ['江西省','新余市',114.92,27.82],['江西省','鹰潭市',117.03,28.27],
    ['江西省','赣州市',114.93,25.83],['江西省','吉安市',114.98,27.12],
    ['江西省','宜春市',114.38,27.80],['江西省','抚州市',116.35,27.97],
    ['江西省','上饶市',117.97,28.45],
    ['山东省','济南市',117.00,36.65],['山东省','青岛市',120.38,36.07],
    ['山东省','淄博市',118.05,36.78],['山东省','枣庄市',117.32,34.82],
    ['山东省','东营市',118.50,37.47],['山东省','烟台市',121.43,37.45],
    ['山东省','潍坊市',119.10,36.70],['山东省','济宁市',116.58,35.42],
    ['山东省','泰安市',117.08,36.20],['山东省','威海市',122.12,37.52],
    ['山东省','日照市',119.52,35.42],['山东省','临沂市',118.35,35.05],
    ['山东省','德州市',116.30,37.45],['山东省','聊城市',115.98,36.45],
    ['山东省','滨州市',118.02,37.38],['山东省','菏泽市',115.43,35.25],
    ['河南省','郑州市',113.65,34.76],['河南省','开封市',114.30,34.80],
    ['河南省','洛阳市',112.45,34.62],['河南省','平顶山市',113.18,33.77],
    ['河南省','安阳市',114.35,36.10],['河南省','鹤壁市',114.28,35.90],
    ['河南省','新乡市',113.85,35.30],['河南省','焦作市',113.25,35.22],
    ['河南省','濮阳市',115.03,35.77],['河南省','许昌市',113.83,34.03],
    ['河南省','漯河市',114.02,33.58],['河南省','三门峡市',111.20,34.77],
    ['河南省','南阳市',112.53,33.00],['河南省','商丘市',115.65,34.45],
    ['河南省','信阳市',114.07,32.13],['河南省','周口市',114.65,33.62],
    ['河南省','驻马店市',114.02,32.98],
    ['湖北省','武汉市',114.31,30.52],['湖北省','黄石市',115.07,30.20],
    ['湖北省','十堰市',110.78,32.65],['湖北省','宜昌市',111.28,30.70],
    ['湖北省','襄阳市',112.13,32.02],['湖北省','鄂州市',114.88,30.40],
    ['湖北省','荆门市',112.20,31.03],['湖北省','孝感市',113.92,30.93],
    ['湖北省','荆州市',112.23,30.33],['湖北省','黄冈市',114.87,30.45],
    ['湖北省','咸宁市',114.32,29.83],['湖北省','随州市',113.38,31.72],
    ['湖北省','恩施土家族苗族自治州',109.48,30.30],
    ['湖北省','仙桃市',113.45,30.37],['湖北省','潜江市',112.88,30.42],
    ['湖北省','天门市',113.17,30.67],['湖北省','神农架林区',110.68,31.75],
    ['湖南省','长沙市',112.98,28.19],['湖南省','株洲市',113.13,27.83],
    ['湖南省','湘潭市',112.93,27.83],['湖南省','衡阳市',112.58,26.90],
    ['湖南省','邵阳市',111.47,27.25],['湖南省','岳阳市',113.13,29.37],
    ['湖南省','常德市',111.68,29.05],['湖南省','张家界市',110.48,29.13],
    ['湖南省','益阳市',112.33,28.60],['湖南省','郴州市',113.02,25.78],
    ['湖南省','永州市',111.62,26.42],['湖南省','怀化市',110.00,27.57],
    ['湖南省','娄底市',112.00,27.73],['湖南省','湘西土家族苗族自治州',109.73,28.32],
    ['广东省','广州市',113.26,23.13],['广东省','韶关市',113.60,24.82],
    ['广东省','深圳市',114.07,22.55],['广东省','珠海市',113.57,22.27],
    ['广东省','汕头市',116.70,23.37],['广东省','佛山市',113.12,23.02],
    ['广东省','江门市',113.08,22.58],['广东省','湛江市',110.35,21.27],
    ['广东省','茂名市',110.92,21.67],['广东省','肇庆市',112.47,23.05],
    ['广东省','惠州市',114.42,23.12],['广东省','梅州市',116.12,24.30],
    ['广东省','汕尾市',115.37,22.78],['广东省','河源市',114.70,23.73],
    ['广东省','阳江市',111.97,21.87],['广东省','清远市',113.03,23.70],
    ['广东省','东莞市',113.75,23.05],['广东省','中山市',113.38,22.52],
    ['广东省','潮州市',116.63,23.67],['广东省','揭阳市',116.35,23.55],
    ['广东省','云浮市',112.03,22.92],
    ['广西壮族自治区','南宁市',108.37,22.82],['广西壮族自治区','柳州市',109.42,24.33],
    ['广西壮族自治区','桂林市',110.28,25.28],['广西壮族自治区','梧州市',111.27,23.48],
    ['广西壮族自治区','北海市',109.12,21.48],['广西壮族自治区','防城港市',108.35,21.70],
    ['广西壮族自治区','钦州市',108.62,21.95],['广西壮族自治区','贵港市',109.60,23.10],
    ['广西壮族自治区','玉林市',110.17,22.63],['广西壮族自治区','百色市',106.62,23.90],
    ['广西壮族自治区','贺州市',111.55,24.42],['广西壮族自治区','河池市',108.07,24.70],
    ['广西壮族自治区','来宾市',109.22,23.73],['广西壮族自治区','崇左市',107.37,22.40],
    ['海南省','海口市',110.32,20.03],['海南省','三亚市',109.50,18.25],
    ['海南省','三沙市',112.34,16.84],['海南省','儋州市',109.58,19.52],
    ['重庆市','重庆市',106.55,29.57],
    ['四川省','成都市',104.07,30.67],['四川省','自贡市',104.78,29.35],
    ['四川省','攀枝花市',101.72,26.58],['四川省','泸州市',105.43,28.87],
    ['四川省','德阳市',104.38,31.13],['四川省','绵阳市',104.73,31.47],
    ['四川省','广元市',105.83,32.43],['四川省','遂宁市',105.57,30.52],
    ['四川省','内江市',105.05,29.58],['四川省','乐山市',103.75,29.58],
    ['四川省','南充市',106.08,30.78],['四川省','眉山市',103.83,30.05],
    ['四川省','宜宾市',104.62,28.77],['四川省','广安市',106.63,30.47],
    ['四川省','达州市',107.50,31.22],['四川省','雅安市',103.02,29.98],
    ['四川省','巴中市',106.77,31.85],['四川省','资阳市',104.63,30.13],
    ['四川省','阿坝藏族羌族自治州',102.22,31.90],
    ['四川省','甘孜藏族自治州',101.97,30.05],
    ['四川省','凉山彝族自治州',102.27,27.90],
    ['贵州省','贵阳市',106.63,26.65],['贵州省','六盘水市',104.83,26.60],
    ['贵州省','遵义市',106.92,27.73],['贵州省','安顺市',105.95,26.25],
    ['贵州省','毕节市',105.28,27.30],['贵州省','铜仁市',109.18,27.72],
    ['贵州省','黔西南布依族苗族自治州',104.90,25.10],
    ['贵州省','黔东南苗族侗族自治州',107.97,26.58],
    ['贵州省','黔南布依族苗族自治州',107.52,26.27],
    ['云南省','昆明市',102.72,25.05],['云南省','曲靖市',103.80,25.50],
    ['云南省','玉溪市',102.55,24.35],['云南省','保山市',99.17,25.12],
    ['云南省','昭通市',103.72,27.33],['云南省','丽江市',100.23,26.87],
    ['云南省','普洱市',100.97,22.78],['云南省','临沧市',100.08,23.88],
    ['云南省','楚雄彝族自治州',101.55,25.03],
    ['云南省','红河哈尼族彝族自治州',103.38,23.37],
    ['云南省','文山壮族苗族自治州',104.25,23.37],
    ['云南省','西双版纳傣族自治州',100.80,22.02],
    ['云南省','大理白族自治州',100.23,25.60],
    ['云南省','德宏傣族景颇族自治州',98.58,24.43],
    ['云南省','怒江傈僳族自治州',98.85,25.85],
    ['云南省','迪庆藏族自治州',99.70,27.82],
    ['西藏自治区','拉萨市',91.13,29.65],['西藏自治区','日喀则市',88.88,29.27],
    ['西藏自治区','昌都市',97.18,31.13],['西藏自治区','林芝市',94.37,29.68],
    ['西藏自治区','山南市',91.77,29.23],['西藏自治区','那曲市',92.07,31.48],
    ['西藏自治区','阿里地区',80.10,32.50],
    ['陕西省','西安市',108.93,34.27],['陕西省','铜川市',108.95,34.90],
    ['陕西省','宝鸡市',107.13,34.37],['陕西省','咸阳市',108.70,34.33],
    ['陕西省','渭南市',109.50,34.50],['陕西省','延安市',109.48,36.60],
    ['陕西省','汉中市',107.03,33.07],['陕西省','榆林市',109.73,38.28],
    ['陕西省','安康市',109.03,32.68],['陕西省','商洛市',109.93,33.87],
    ['甘肃省','兰州市',103.73,36.03],['甘肃省','嘉峪关市',98.27,39.80],
    ['甘肃省','金昌市',102.18,38.52],['甘肃省','白银市',104.18,36.55],
    ['甘肃省','天水市',105.72,34.58],['甘肃省','武威市',102.63,37.93],
    ['甘肃省','张掖市',100.45,38.93],['甘肃省','平凉市',106.67,35.55],
    ['甘肃省','酒泉市',98.52,39.75],['甘肃省','庆阳市',107.63,35.73],
    ['甘肃省','定西市',104.62,35.58],['甘肃省','陇南市',104.92,33.40],
    ['甘肃省','临夏回族自治州',103.22,35.60],
    ['甘肃省','甘南藏族自治州',102.92,34.98],
    ['青海省','西宁市',101.78,36.62],['青海省','海东市',102.12,36.50],
    ['青海省','海北藏族自治州',100.90,36.97],
    ['青海省','黄南藏族自治州',102.02,35.52],
    ['青海省','海南藏族自治州',100.62,36.28],
    ['青海省','果洛藏族自治州',100.23,34.48],
    ['青海省','玉树藏族自治州',97.02,33.00],
    ['青海省','海西蒙古族藏族自治州',97.37,37.37],
    ['宁夏回族自治区','银川市',106.28,38.47],['宁夏回族自治区','石嘴山市',106.38,38.98],
    ['宁夏回族自治区','吴忠市',106.20,37.98],['宁夏回族自治区','固原市',106.28,36.00],
    ['宁夏回族自治区','中卫市',105.18,37.52],
    ['新疆维吾尔自治区','乌鲁木齐市',87.62,43.82],['新疆维吾尔自治区','克拉玛依市',84.87,45.60],
    ['新疆维吾尔自治区','吐鲁番市',89.18,42.95],['新疆维吾尔自治区','哈密市',93.52,42.83],
    ['新疆维吾尔自治区','昌吉回族自治州',87.30,44.02],
    ['新疆维吾尔自治区','博尔塔拉蒙古自治州',82.07,44.90],
    ['新疆维吾尔自治区','巴音郭楞蒙古自治州',86.15,41.73],
    ['新疆维吾尔自治区','阿克苏地区',80.27,41.17],
    ['新疆维吾尔自治区','克孜勒苏柯尔克孜自治州',76.17,39.72],
    ['新疆维吾尔自治区','喀什地区',75.98,39.47],
    ['新疆维吾尔自治区','和田地区',79.92,37.12],
    ['新疆维吾尔自治区','伊犁哈萨克自治州',81.32,43.92],
    ['新疆维吾尔自治区','塔城地区',82.98,46.75],
    ['新疆维吾尔自治区','阿勒泰地区',88.13,47.85],
    ['新疆维吾尔自治区','石河子市',86.03,44.30],
    ['台湾省','台北市',121.50,25.05],['台湾省','高雄市',120.28,22.62],
    ['台湾省','台中市',120.67,24.15],['台湾省','台南市',120.22,23.00],
    ['台湾省','基隆市',121.73,25.13],['台湾省','新竹市',120.95,24.82],
    ['台湾省','嘉义市',120.43,23.48],
    ['香港特别行政区','香港',114.17,22.28],
    ['澳门特别行政区','澳门',113.55,22.19]
  ]
}

// 为每个地级市生成3个模拟数据指标，按平均值映射绿色梯度
function generateCityMetrics(carbonData, evData, pilesData) {
  const provCarbon = {}, provEV = {}, provPiles = {}
  carbonData.forEach(d => { provCarbon[d.name] = d.value * 0.15 })
  evData.forEach(d => { provEV[d.name] = d.value * 0.12 })
  pilesData.forEach(d => { provPiles[d.name] = d.value * 0.10 })

  return PREFECTURE_CITIES.map(([province, city, lng, lat]) => {
    const baseCarbon = (provCarbon[province] || 500) * (0.6 + ((city.charCodeAt(0) % 50) / 100))
    const baseEV     = (provEV[province] || 2000)     * (0.5 + ((city.charCodeAt(city.length-1) % 40) / 80))
    const basePiles  = (provPiles[province] || 300)    * (0.5 + ((city.length * 7) % 60) / 100)

    const metric1 = Math.round(baseCarbon * (0.7 + (city.length % 10) / 30))
    const metric2 = Math.round(baseEV     * (0.6 + (city.length % 8) / 20))
    const metric3 = Math.round(basePiles  * (0.5 + (city.length % 12) / 24))
    return { province, city, lng, lat, metric1, metric2, metric3 }
  })
}

// 绿色梯度：平均值归一化 → 浅青(#80ffaa)到深绿(#006633)
function getGreenColor(avg, minAvg, maxAvg) {
  const t = maxAvg > minAvg ? (avg - minAvg) / (maxAvg - minAvg) : 0.5
  // t: 0=浅绿, 1=深绿
  const r = Math.round(128 * (1 - t))
  const g = Math.round(255 * (1 - t * 0.6))
  const b = Math.round(170 * (1 - t * 0.85))
  return `rgb(${r}, ${g}, ${b})`
}

export default {
  name: 'screen',
  components: { CountTo },
  data() {
    const carbonReductionData = [
      { name: '广东省', value: 48600, growth: 18.5 },
      { name: '山东省', value: 45200, growth: 16.2 },
      { name: '江苏省', value: 43800, growth: 15.8 },
      { name: '浙江省', value: 41200, growth: 22.1 },
      { name: '河北省', value: 39500, growth: 14.3 },
      { name: '河南省', value: 36800, growth: 19.6 },
      { name: '四川省', value: 34200, growth: 25.4 },
      { name: '湖北省', value: 31800, growth: 20.2 },
      { name: '上海市', value: 29600, growth: 13.8 },
      { name: '安徽省', value: 27500, growth: 24.5 },
      { name: '湖南省', value: 25800, growth: 22.3 },
      { name: '北京市', value: 24200, growth: 11.2 },
      { name: '辽宁省', value: 22800, growth: 15.6 },
      { name: '陕西省', value: 21500, growth: 20.8 },
      { name: '福建省', value: 20400, growth: 18.2 },
      { name: '山西省', value: 19500, growth: 17.5 },
      { name: '重庆市', value: 18200, growth: 23.6 },
      { name: '广西壮族自治区', value: 16800, growth: 28.5 },
      { name: '江西省', value: 15500, growth: 24.8 },
      { name: '云南省', value: 14200, growth: 30.2 },
      { name: '黑龙江省', value: 13500, growth: 19.4 },
      { name: '贵州省', value: 12800, growth: 32.6 },
      { name: '天津市', value: 11500, growth: 14.8 },
      { name: '内蒙古自治区', value: 10800, growth: 22.2 },
      { name: '吉林省', value: 10200, growth: 18.6 },
      { name: '台湾省', value: 9600, growth: 8.2 },
      { name: '新疆维吾尔自治区', value: 8500, growth: 35.5 },
      { name: '甘肃省', value: 7200, growth: 28.3 },
      { name: '海南省', value: 5600, growth: 38.5 },
      { name: '宁夏回族自治区', value: 3800, growth: 32.8 },
      { name: '青海省', value: 2500, growth: 40.2 },
      { name: '香港特别行政区', value: 2200, growth: 6.5 },
      { name: '西藏自治区', value: 1800, growth: 42.8 },
      { name: '澳门特别行政区', value: 350, growth: 10.2 }
    ]
    const evData = [
      { name: '广东省', value: 1280000, growth: 16.5 },
      { name: '上海市', value: 820000, growth: 15.2 },
      { name: '江苏省', value: 780000, growth: 20.1 },
      { name: '山东省', value: 720000, growth: 22.1 },
      { name: '北京市', value: 680000, growth: 12.5 },
      { name: '浙江省', value: 650000, growth: 18.9 },
      { name: '河南省', value: 550000, growth: 28.6 },
      { name: '河北省', value: 520000, growth: 25.6 },
      { name: '四川省', value: 480000, growth: 29.8 },
      { name: '湖北省', value: 420000, growth: 26.8 },
      { name: '安徽省', value: 380000, growth: 32.5 },
      { name: '湖南省', value: 350000, growth: 31.2 },
      { name: '天津市', value: 350000, growth: 18.2 },
      { name: '辽宁省', value: 320000, growth: 19.5 },
      { name: '重庆市', value: 310000, growth: 27.3 },
      { name: '陕西省', value: 310000, growth: 28.2 },
      { name: '福建省', value: 290000, growth: 24.3 },
      { name: '山西省', value: 280000, growth: 30.1 },
      { name: '台湾省', value: 250000, growth: 10.5 },
      { name: '广西壮族自治区', value: 220000, growth: 38.7 },
      { name: '云南省', value: 190000, growth: 36.5 },
      { name: '江西省', value: 180000, growth: 35.2 },
      { name: '黑龙江省', value: 160000, growth: 26.7 },
      { name: '贵州省', value: 160000, growth: 42.1 },
      { name: '吉林省', value: 150000, growth: 28.3 },
      { name: '内蒙古自治区', value: 120000, growth: 22.8 },
      { name: '甘肃省', value: 95000, growth: 40.5 },
      { name: '海南省', value: 85000, growth: 45.2 },
      { name: '新疆维吾尔自治区', value: 85000, growth: 44.2 },
      { name: '香港特别行政区', value: 68000, growth: 8.2 },
      { name: '宁夏回族自治区', value: 42000, growth: 38.9 },
      { name: '青海省', value: 28000, growth: 48.6 },
      { name: '西藏自治区', value: 12000, growth: 55.8 },
      { name: '澳门特别行政区', value: 8500, growth: 12.5 }
    ]
    const pilesData = [
      { name: '广东省', value: 186000, growth: 9.5 },
      { name: '上海市', value: 158000, growth: 7.2 },
      { name: '江苏省', value: 142000, growth: 10.5 },
      { name: '山东省', value: 135000, growth: 14.2 },
      { name: '北京市', value: 125000, growth: 8.7 },
      { name: '浙江省', value: 118000, growth: 12.8 },
      { name: '河南省', value: 105000, growth: 20.5 },
      { name: '四川省', value: 98000, growth: 25.8 },
      { name: '河北省', value: 95000, growth: 18.2 },
      { name: '湖北省', value: 88000, growth: 19.8 },
      { name: '安徽省', value: 78000, growth: 25.3 },
      { name: '湖南省', value: 72000, growth: 24.6 },
      { name: '辽宁省', value: 72000, growth: 15.3 },
      { name: '天津市', value: 68000, growth: 12.5 },
      { name: '陕西省', value: 68000, growth: 22.8 },
      { name: '重庆市', value: 65000, growth: 22.1 },
      { name: '福建省', value: 62000, growth: 18.9 },
      { name: '台湾省', value: 55000, growth: 6.8 },
      { name: '山西省', value: 52000, growth: 22.8 },
      { name: '广西壮族自治区', value: 48000, growth: 30.2 },
      { name: '云南省', value: 42000, growth: 30.5 },
      { name: '江西省', value: 42000, growth: 28.7 },
      { name: '黑龙江省', value: 38000, growth: 22.4 },
      { name: '贵州省', value: 38000, growth: 35.2 },
      { name: '吉林省', value: 35000, growth: 20.1 },
      { name: '内蒙古自治区', value: 28000, growth: 25.6 },
      { name: '甘肃省', value: 22000, growth: 32.5 },
      { name: '新疆维吾尔自治区', value: 19500, growth: 38.5 },
      { name: '海南省', value: 18000, growth: 35.8 },
      { name: '香港特别行政区', value: 12500, growth: 5.2 },
      { name: '宁夏回族自治区', value: 9800, growth: 35.6 },
      { name: '青海省', value: 6500, growth: 42.1 },
      { name: '西藏自治区', value: 2800, growth: 48.2 },
      { name: '澳门特别行政区', value: 1200, growth: 8.5 }
    ]

    return {
      loading: true,
      loadingText: '正在初始化数据大屏...',
      loadingProgress: 0,
      error: null,
      isFullscreen: false,

      mapChart: null,
      resizeTimer: null,

      activeOverlay: { carbon: true, ev: true, piles: true },
      showLegendTip: false,

      carbonReductionData,
      evData,
      pilesData,

      totalReduction: 0,
      totalPiles: 0,
      totalEV: 0,

      treeRatio: 85,

      radarStyle: { left: '50%', top: '50%' }
    }
  },
  computed: {
    cityData() {
      return generateCityMetrics(this.carbonReductionData, this.evData, this.pilesData)
    },
    cityScatterData() {
      const data = this.cityData
      const avgList = data.map(d => (d.metric1 + d.metric2 + d.metric3) / 3)
      const minAvg = Math.min(...avgList)
      const maxAvg = Math.max(...avgList)
      return data.map(d => {
        const avg = (d.metric1 + d.metric2 + d.metric3) / 3
        const color = getGreenColor(avg, minAvg, maxAvg)
        return {
          name: d.city,
          province: d.province,
          value: [d.lng, d.lat, Math.round(avg)],
          metric1: d.metric1,
          metric2: d.metric2,
          metric3: d.metric3,
          avg: Math.round(avg),
          itemStyle: { color, shadowBlur: 6, shadowColor: 'rgba(0,230,118,0.25)' }
        }
      })
    },
    leftCityData() {
      return [...this.cityData]
        .sort((a, b) => b.metric1 - a.metric1)
        .slice(0, 10)
        .map(d => ({
          ...d,
          trees: Math.round(d.metric1 * 12)
        }))
    },
    rightCityData() {
      return [...this.cityData]
        .sort((a, b) => (b.metric2 + b.metric3) - (a.metric2 + a.metric3))
        .slice(0, 10)
        .map(d => ({
          ...d,
          ev: Math.round(d.metric2 * 10),
          piles: Math.round(d.metric3 * 10)
        }))
    }
  },
  mounted() {
    this.initFullscreen()
    window.addEventListener('resize', this.handleResize)
    this.initScreen()
  },
  beforeDestroy() {
    if (this.resizeTimer) clearTimeout(this.resizeTimer)
    window.removeEventListener('resize', this.handleResize)
    if (screenfull.isEnabled) {
      screenfull.off('change', this.onFullscreenChange)
    }
    if (this.mapChart) { this.mapChart.dispose() }
    this.$store.dispatch('app/toggleSideBarHide', false)
  },
  methods: {
    async initScreen() {
      try {
        this.computeTotals()
        this.updateLoading('正在加载中国地图数据...', 20)

        const geoJson = await this.fetchChinaGeoJSON()
        echarts.registerMap('china', geoJson)

        this.updateLoading('正在初始化图表...', 80)
        this.loading = false
        await this.$nextTick()

        this.initMapChart()
      } catch (err) {
        console.error('数据大屏初始化失败：', err)
        this.error = '数据大屏初始化失败：' + (err.message || '未知错误')
        this.loading = false
      }
    },

    retry() {
      this.loading = true
      this.error = null
      this.loadingProgress = 0
      if (this.mapChart) { this.mapChart.dispose(); this.mapChart = null }
      this.initScreen()
    },

    updateLoading(text, progress) {
      this.loadingText = text
      this.loadingProgress = progress
    },

    computeTotals() {
      const sum = (arr) => arr.reduce((acc, item) => acc + item.value, 0)
      this.totalReduction = sum(this.carbonReductionData)
      this.totalPiles = sum(this.pilesData)
      this.totalEV = sum(this.evData)
    },

    async refreshData() {
      this.$message.success('数据已刷新（当前为模拟数据）')
      if (this.mapChart) this.mapChart.resize()
    },

    async fetchChinaGeoJSON() {
      const response = await fetch(CHINA_GEOJSON_URL)
      if (!response.ok) throw new Error('地图数据加载失败，HTTP ' + response.status)
      return response.json()
    },

    updateRadarPosition() {
      if (!this.mapChart) return
      const option = this.mapChart.getOption()
      if (!option.geo || !option.geo[0]) return
      const center = option.geo[0].center || [105, 36]
      const pixel = this.mapChart.convertToPixel({geoIndex: 0}, center)
      if (pixel) {
        this.radarStyle = { left: pixel[0] + 'px', top: pixel[1] + 'px' }
      }
    },

    initMapChart() {
      const dom = this.$refs.mapChart
      if (!dom || dom.clientWidth === 0) {
        setTimeout(() => this.initMapChart(), 200)
        return
      }
      this.mapChart = echarts.init(dom)
      this.mapChart.setOption(this.buildMapOption())
      this.updateRadarPosition()
      this.mapChart.on('georoam', () => { this.updateRadarPosition() })
      this.mapChart.on('click', (params) => {
        if (params.componentType === 'effectScatter' && params.data) {
          console.log('点击省份:', params.data.name)
        }
      })
    },

    buildMapOption() {
      const maxReduction = Math.max(...this.carbonReductionData.map(d => d.value))
      const maxEV = Math.max(...this.evData.map(d => d.value))
      const maxPiles = Math.max(...this.pilesData.map(d => d.value))

      const reductionScatter = this.carbonReductionData.map(d => {
        const c = CENTROID_MAP[d.name]
        if (!c) return null
        return { name: d.name, value: [...c, d.value], growth: d.growth, label: '碳减排: ' + (d.value / 10000).toFixed(1) + ' 万吨' }
      }).filter(Boolean)

      const evScatter = this.evData.map(d => {
        const c = CENTROID_MAP[d.name]
        if (!c) return null
        return { name: d.name, value: [...c, d.value], growth: d.growth, label: '新能源车: ' + (d.value / 10000).toFixed(1) + ' 万辆' }
      }).filter(Boolean)

      const pilesScatter = this.pilesData.map(d => {
        const c = CENTROID_MAP[d.name]
        if (!c) return null
        return { name: d.name, value: [...c, d.value], growth: d.growth, label: '充电桩: ' + (d.value / 10000).toFixed(1) + ' 万个' }
      }).filter(Boolean)

      const series = []
      if (this.activeOverlay.carbon) {
        series.push({
          type: 'effectScatter',
          name: '碳减排',
          coordinateSystem: 'geo',
          data: reductionScatter,
          symbolSize: (val) => 6 + (val[2] / maxReduction) * 18,
          itemStyle: { color: '#00E676', shadowBlur: 10, shadowColor: 'rgba(0,230,118,0.6)' },
          label: { show: false },
          emphasis: {
            scale: 2,
            label: {
              show: true,
              formatter: (p) => p.data.name + '\n' + p.data.label,
              color: '#fff',
              fontSize: 12,
              backgroundColor: 'rgba(0,0,0,0.7)',
              padding: [4, 8],
              borderRadius: 3
            }
          },
          rippleEffect: { brushType: 'stroke', scale: 3, period: 4 },
          zlevel: 1
        })
      }
      if (this.activeOverlay.ev) {
        series.push({
          type: 'effectScatter',
          name: '新能源车',
          coordinateSystem: 'geo',
          data: evScatter,
          symbolSize: (val) => 6 + (val[2] / maxEV) * 18,
          itemStyle: { color: '#00E5FF', shadowBlur: 10, shadowColor: 'rgba(0,229,255,0.6)' },
          label: { show: false },
          emphasis: {
            scale: 2,
            label: {
              show: true,
              formatter: (p) => p.data.name + '\n' + p.data.label,
              color: '#fff',
              fontSize: 12,
              backgroundColor: 'rgba(0,0,0,0.7)',
              padding: [4, 8],
              borderRadius: 3
            }
          },
          rippleEffect: { brushType: 'stroke', scale: 3, period: 4 },
          zlevel: 1
        })
      }
      if (this.activeOverlay.piles) {
        series.push({
          type: 'effectScatter',
          name: '充电桩',
          coordinateSystem: 'geo',
          data: pilesScatter,
          symbolSize: (val) => 6 + (val[2] / maxPiles) * 18,
          itemStyle: { color: '#36A3F7', shadowBlur: 10, shadowColor: 'rgba(54,163,247,0.6)' },
          label: { show: false },
          emphasis: {
            scale: 2,
            label: {
              show: true,
              formatter: (p) => p.data.name + '\n' + p.data.label,
              color: '#fff',
              fontSize: 12,
              backgroundColor: 'rgba(0,0,0,0.7)',
              padding: [4, 8],
              borderRadius: 3
            }
          },
          rippleEffect: { brushType: 'stroke', scale: 3, period: 4 },
          zlevel: 1
        })
      }

      // 添加绿色渐变市级数据点系列
      series.push({
        name: 'cityScatter',
        type: 'effectScatter',
        coordinateSystem: 'geo',
        data: this.cityScatterData,
        symbol: ICON_LEAF,
        symbolSize: 12,
        itemStyle: {
          shadowBlur: 4,
          shadowColor: 'rgba(0,230,118,0.2)'
        },
        rippleEffect: {
          brushType: 'stroke',
          scale: 2.5,
          period: 4
        },
        label: { show: false },
        emphasis: {
          scale: 1.2,
          label: {
            show: true,
            formatter: (p) => p.data.name,
            color: '#fff',
            fontSize: 11,
            fontWeight: 'bold',
            backgroundColor: 'rgba(0,0,0,0.65)',
            padding: [2, 6],
            borderRadius: 3,
            position: 'top'
          },
          itemStyle: {
            shadowBlur: 18,
            shadowColor: 'rgba(0,230,118,0.6)'
          }
        },
        rippleEffect: { brushType: 'stroke', scale: 3, period: 4 },
        zlevel: 3
      })

      return {
        backgroundColor: 'transparent',
        tooltip: {
          trigger: 'item',
          backgroundColor: 'rgba(10,22,50,0.92)',
          borderColor: 'rgba(0,212,255,0.4)',
          extraCssText: 'box-shadow: 0 0 20px rgba(0,200,255,0.15); padding: 8px 12px;',
          textStyle: { color: '#fff', fontSize: 13 },
          formatter: (p) => {
            if (!p.data) return ''
            // 市级数据点 → 展示三个原始指标
            if (p.data.metric1 !== undefined) {
              const line1 = '<div style="font-size:14px;font-weight:bold;color:#00E676;margin-bottom:5px;border-bottom:1px solid rgba(255,255,255,0.1);padding-bottom:4px;">' + p.data.name + '</div>'
              const m1 = '<div style="display:flex;align-items:center;gap:6px;margin:2px 0;line-height:1.8;"><span style="display:inline-block;width:6px;height:6px;border-radius:50%;background:#00E676;"></span><span style="color:rgba(255,255,255,0.55);font-size:12px;">碳减排</span><span style="color:#fff;font-weight:600;margin-left:auto;">' + (p.data.metric1).toLocaleString() + ' 吨</span></div>'
              const m2 = '<div style="display:flex;align-items:center;gap:6px;margin:2px 0;line-height:1.8;"><span style="display:inline-block;width:6px;height:6px;border-radius:50%;background:#00E5FF;"></span><span style="color:rgba(255,255,255,0.55);font-size:12px;">新能源车</span><span style="color:#fff;font-weight:600;margin-left:auto;">' + (p.data.metric2).toLocaleString() + ' 辆</span></div>'
              const m3 = '<div style="display:flex;align-items:center;gap:6px;margin:2px 0;line-height:1.8;"><span style="display:inline-block;width:6px;height:6px;border-radius:50%;background:#36A3F7;"></span><span style="color:rgba(255,255,255,0.55);font-size:12px;">充电桩</span><span style="color:#fff;font-weight:600;margin-left:auto;">' + (p.data.metric3).toLocaleString() + ' 个</span></div>'
              return line1 + m1 + m2 + m3
            }
            // 省级散点数据
            return '<div style="font-size:14px;font-weight:bold;color:#00E5FF;margin-bottom:4px;">' + p.data.name + '</div>'
              + '<div style="color:#ccc;line-height:20px;">' + p.data.label + '</div>'
          }
        },
        geo: {
          map: 'china',
          roam: true,
          zoom: 1.15,
          center: [105, 36],
          aspectScale: 0.85,
          label: { show: false },
          itemStyle: {
            areaColor: {
              type: 'radial',
              x: 0.5, y: 0.5, r: 0.8,
              colorStops: [
                { offset: 0, color: 'rgba(28, 80, 155, 0.6)' },
                { offset: 1, color: 'rgba(14, 38, 80, 0.7)' }
              ]
            },
            borderColor: '#4FC3F7',
            borderWidth: 2,
            shadowBlur: 4,
            shadowOffsetY: 1,
            shadowColor: 'rgba(79, 195, 247, 0.08)'
          },
          emphasis: {
            label: {
              show: true,
              color: '#fff',
              fontSize: 10,
              formatter: (p) => SHORT_NAME[p.name] || p.name
            },
            itemStyle: { areaColor: 'rgba(40, 95, 175, 0.45)', borderColor: '#4FC3F7', borderWidth: 2.5 }
          },
          regions: [{
            name: '南海诸岛',
            itemStyle: { areaColor: 'rgba(15, 38, 70, 0.75)', borderColor: '#4FC3F7', borderWidth: 2 },
            label: { show: false }
          }]
        },
        series
      }
    },

    toggleOverlay(dim) {
      this.activeOverlay[dim] = !this.activeOverlay[dim]
      if (this.mapChart) {
        this.mapChart.setOption(this.buildMapOption(), { notMerge: true })
      }
    },

    initFullscreen() {
      if (screenfull.isEnabled) {
        screenfull.on('change', this.onFullscreenChange)
      }
    },

    onFullscreenChange() {
      this.isFullscreen = screenfull.isFullscreen
      if (!this.isFullscreen) {
        this.$store.dispatch('app/toggleSideBarHide', false)
      }
      this.$nextTick(() => {
        if (this.mapChart && !this.mapChart.isDisposed()) this.mapChart.resize()
      })
    },

    toggleFullscreen() {
      if (!screenfull.isEnabled) {
        this.$message.warning('您的浏览器不支持全屏功能')
        return
      }
      if (!this.isFullscreen) {
        this.$store.dispatch('app/toggleSideBarHide', true)
        this.$nextTick(() => {
          screenfull.request(this.$el)
        })
      } else {
        screenfull.exit()
      }
    },

    handleResize() {
      if (this.resizeTimer) clearTimeout(this.resizeTimer)
      this.resizeTimer = setTimeout(() => {
        if (this.mapChart && !this.mapChart.isDisposed()) this.mapChart.resize()
      }, 300)
    }
  }
}
</script>

<style lang="scss" scoped>
.data-screen-wrapper {
  position: absolute;
  top: 0;
  right: 0;
  bottom: 0;
  left: 0;
  overflow: hidden;
  background: #0a1632;
  font-family: "Microsoft YaHei", "PingFang SC", "Helvetica Neue", sans-serif;
}

// ======== 加载动画 ========
.loading-overlay {
  position: absolute;
  inset: 0;
  z-index: 1000;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  background: radial-gradient(ellipse at center, #0d1a45 0%, #0a1632 70%);
}

.loading-spinner {
  position: relative;
  width: 80px;
  height: 80px;
  margin-bottom: 24px;
  .spinner-ring {
    position: absolute;
    inset: 0;
    border: 3px solid transparent;
    border-top-color: #36A3F7;
    border-right-color: #00E676;
    border-radius: 50%;
    animation: spin 1.2s linear infinite;
  }
  .spinner-core {
    position: absolute;
    inset: 15px;
    border: 2px solid transparent;
    border-bottom-color: #00E5FF;
    border-left-color: #36A3F7;
    border-radius: 50%;
    animation: spin 0.8s linear infinite reverse;
  }
}

@keyframes spin {
  to { transform: rotate(360deg); }
}

.loading-title {
  font-size: 20px;
  color: #00E5FF;
  margin: 0 0 8px;
  letter-spacing: 4px;
}

.loading-text {
  font-size: 13px;
  color: rgba(255, 255, 255, 0.5);
  margin: 0 0 24px;
}

.loading-progress {
  width: 240px;
  height: 3px;
  background: rgba(255, 255, 255, 0.1);
  border-radius: 2px;
  overflow: hidden;
  .progress-bar {
    height: 100%;
    background: linear-gradient(90deg, #36A3F7, #00E5FF, #00E676);
    border-radius: 2px;
    transition: width 0.4s ease;
  }
}

// ======== 错误提示 ========
.error-overlay {
  position: absolute;
  inset: 0;
  z-index: 1000;
  display: flex;
  align-items: center;
  justify-content: center;
  background: radial-gradient(ellipse at center, #0d1a45 0%, #0a1632 70%);
}

.error-box {
  text-align: center;
  color: #ff4d4f;
  i { font-size: 56px; display: block; margin-bottom: 16px; }
  p { font-size: 15px; margin: 0 0 20px; color: rgba(255, 255, 255, 0.7); }
}

// ======== 主屏幕 ========
.data-screen {
  position: relative;
  width: 100%;
  height: 100%;
  display: flex;
  flex-direction: column;
  overflow: hidden;
  background:
    linear-gradient(rgba(0, 212, 255, 0.025) 1px, transparent 1px),
    linear-gradient(90deg, rgba(0, 212, 255, 0.025) 1px, transparent 1px),
    radial-gradient(ellipse at 50% 30%, #0d1f50 0%, #0a1632 100%);
  background-size: 50px 50px, 50px 50px, 100% 100%;
}

// ======== 背景动态光晕 ========
.bg-light-beam {
  position: absolute;
  top: -20%;
  left: -20%;
  width: 60%;
  height: 140%;
  background: radial-gradient(ellipse at 30% 50%, rgba(0, 230, 118, 0.04) 0%, transparent 60%);
  transform: rotate(25deg);
  animation: lightSweep 8s ease-in-out infinite;
  pointer-events: none;
  z-index: 0;
}

@keyframes lightSweep {
  0%, 100% { transform: rotate(25deg) translateX(-10%); opacity: 0.3; }
  50% { transform: rotate(25deg) translateX(60%); opacity: 0.7; }
}

// ======== 背景浮动粒子 ========
.bg-particles {
  position: absolute;
  inset: 0;
  pointer-events: none;
  z-index: 0;
  overflow: hidden;
}

.particle {
  position: absolute;
  width: 3px;
  height: 3px;
  border-radius: 50%;
  background: rgba(0, 230, 118, 0.25);
  animation: floatParticle 12s ease-in-out infinite;
}

.particle.p1 { left: 10%; top: 20%; width: 2px; height: 2px; animation-duration: 14s; animation-delay: 0s; background: rgba(0, 230, 118, 0.2); }
.particle.p2 { left: 25%; top: 60%; width: 4px; height: 4px; animation-duration: 18s; animation-delay: 2s; background: rgba(0, 229, 255, 0.15); }
.particle.p3 { left: 45%; top: 10%; width: 3px; height: 3px; animation-duration: 16s; animation-delay: 4s; background: rgba(54, 163, 247, 0.2); }
.particle.p4 { left: 65%; top: 70%; width: 5px; height: 5px; animation-duration: 20s; animation-delay: 1s; background: rgba(0, 230, 118, 0.15); }
.particle.p5 { left: 80%; top: 30%; width: 2px; height: 2px; animation-duration: 13s; animation-delay: 5s; background: rgba(0, 229, 255, 0.2); }
.particle.p6 { left: 50%; top: 80%; width: 3px; height: 3px; animation-duration: 17s; animation-delay: 3s; background: rgba(54, 163, 247, 0.15); }
.particle.p7 { left: 90%; top: 15%; width: 4px; height: 4px; animation-duration: 15s; animation-delay: 6s; background: rgba(0, 230, 118, 0.18); }
.particle.p8 { left: 15%; top: 85%; width: 2px; height: 2px; animation-duration: 19s; animation-delay: 0.5s; background: rgba(0, 229, 255, 0.2); }
.particle.p9 { left: 72%; top: 50%; width: 3px; height: 3px; animation-duration: 14s; animation-delay: 3.2s; background: rgba(54, 163, 247, 0.22); }
.particle.p10 { left: 35%; top: 40%; width: 5px; height: 5px; animation-duration: 21s; animation-delay: 1.8s; background: rgba(0, 230, 118, 0.16); }
.particle.p11 { left: 88%; top: 75%; width: 2px; height: 2px; animation-duration: 16s; animation-delay: 4.5s; background: rgba(0, 229, 255, 0.18); }
.particle.p12 { left: 5%; top: 45%; width: 4px; height: 4px; animation-duration: 22s; animation-delay: 0.9s; background: rgba(0, 230, 118, 0.15); }
.particle.p13 { left: 55%; top: 90%; width: 3px; height: 3px; animation-duration: 18s; animation-delay: 5.5s; background: rgba(54, 163, 247, 0.2); }
.particle.p14 { left: 40%; top: 5%; width: 2px; height: 2px; animation-duration: 12s; animation-delay: 2.6s; background: rgba(0, 229, 255, 0.25); }
.particle.p15 { left: 78%; top: 8%; width: 3px; height: 3px; animation-duration: 20s; animation-delay: 7s; background: rgba(0, 230, 118, 0.17); }

@keyframes floatParticle {
  0% { transform: translateY(0) translateX(0) scale(1); opacity: 0; }
  15% { opacity: 1; }
  70% { opacity: 0.6; }
  100% { transform: translateY(-120vh) translateX(80px) scale(0.3); opacity: 0; }
}

// ======== 背景水平扫描线 ========
.bg-scanline {
  position: absolute;
  left: 0;
  right: 0;
  height: 1px;
  z-index: 0;
  pointer-events: none;
  background: linear-gradient(90deg, transparent 0%, rgba(0, 230, 118, 0.06) 20%, rgba(0, 229, 255, 0.08) 50%, rgba(0, 230, 118, 0.06) 80%, transparent 100%);
  animation: scanMove 10s linear infinite;
  top: 0;
}

@keyframes scanMove {
  0% { top: 0; opacity: 0; }
  5% { opacity: 1; }
  45% { opacity: 1; }
  50% { opacity: 0; }
  50.01% { top: 100%; opacity: 0; }
  55% { opacity: 1; }
  95% { opacity: 1; }
  100% { top: 0; opacity: 0; }
}

// ======== 顶部 KPI 卡片 ========
.screen-header {
  flex-shrink: 0;
  padding: 14px 20px 6px;
  text-align: center;
}

.stats-row {
  display: flex;
  justify-content: center;
  gap: 16px;
}

.stat-card {
  display: flex;
  align-items: center;
  gap: 10px;
  flex: 0 1 280px;
  padding: 10px 18px;
  border-radius: 6px;
  background: #0f2147;
  border: 1px solid rgba(0, 212, 255, 0.08);
  transition: all 0.3s ease;
  cursor: default;

  &:hover {
    border-color: rgba(0, 212, 255, 0.35);
    box-shadow: 0 0 18px rgba(0, 212, 255, 0.1);
    transform: translateY(-1px);
  }

  &.card-carbon { border-left: 3px solid #00E676; }
  &.card-piles { border-left: 3px solid #36A3F7; }
  &.card-ev { border-left: 3px solid #00E5FF; }
}

.card-icon-svg {
  flex-shrink: 0;
  width: 42px;
  height: 42px;
}

.card-body {
  flex: 1;
  min-width: 0;
  .card-label {
    display: block;
    font-size: 11px;
    color: rgba(255, 255, 255, 0.45);
    margin-bottom: 2px;
  }
  .card-value {
    display: block;
    font-size: 22px;
    font-weight: 700;
    color: #fff;
    letter-spacing: 1px;
    line-height: 1.2;
    small {
      font-size: 11px;
      font-weight: 400;
      color: rgba(255, 255, 255, 0.35);
      margin-left: 3px;
    }
  }
  .card-trend {
    display: block;
    font-size: 10px;
    margin-top: 1px;
    &.up { color: #52c41a; }
    &.down { color: #ff4d4f; }
  }
}

// ======== 主内容：左右面板 + 地图 ========
.main-content {
  flex: 1;
  display: flex;
  gap: 10px;
  padding: 6px 14px 10px;
  min-height: 0;
  position: relative;
  z-index: 1;
}

// ======== 左右侧面表格面板 ========
.side-panel {
  width: 210px;
  flex-shrink: 0;
  display: flex;
  flex-direction: column;
  background: #0f1d3d;
  border: 1px solid rgba(0, 212, 255, 0.08);
  border-radius: 4px;
  overflow: hidden;
}

.panel-title {
  flex-shrink: 0;
  margin: 0;
  padding: 8px 10px;
  font-size: 12px;
  font-weight: 600;
  color: #fff;
  letter-spacing: 1px;
  display: flex;
  align-items: center;
  gap: 6px;
  background: rgba(0, 212, 255, 0.06);
  border-bottom: 1px solid rgba(0, 212, 255, 0.1);
}

.title-dot {
  display: inline-block;
  width: 6px;
  height: 6px;
  border-radius: 1px;
  &.carbon-dot { background: #00E676; }
  &.ev-dot { background: #00E5FF; }
  &.pile-dot { background: #36A3F7; }
}

.table-scroll {
  flex: 1;
  overflow-y: auto;
  overflow-x: hidden;

  &::-webkit-scrollbar { width: 3px; }
  &::-webkit-scrollbar-thumb { background: rgba(0, 212, 255, 0.2); border-radius: 2px; }
  &::-webkit-scrollbar-track { background: transparent; }
}

.data-table {
  width: 100%;
  border-collapse: collapse;
  font-size: 11px;

  thead {
    position: sticky;
    top: 0;
    z-index: 1;
    th {
      padding: 5px 4px;
      color: rgba(0, 212, 255, 0.7);
      font-weight: 500;
      font-size: 10px;
      text-align: center;
      background: #0d1f45;
      border-bottom: 1px solid rgba(0, 212, 255, 0.15);
      white-space: nowrap;
    }
  }

  tbody {
    td {
      padding: 4px 4px;
      text-align: center;
      color: rgba(255, 255, 255, 0.65);
      border-bottom: 1px solid rgba(255, 255, 255, 0.04);
      white-space: nowrap;
    }

    tr {
      transition: background 0.2s;
      &:hover {
        background: rgba(0, 212, 255, 0.08);
      }
      &.row-top3 {
        td { color: #fff; }
        background: rgba(255, 255, 255, 0.03);
      }
    }
  }

  .col-rank { width: 28px; }
  .col-name { text-align: left; padding-left: 6px; }
  .col-val {
    text-align: right;
    padding-right: 6px;
    font-variant-numeric: tabular-nums;
    small {
      font-size: 9px;
      color: rgba(255, 255, 255, 0.35);
      margin-left: 1px;
    }
  }
}

.rank-badge {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  width: 18px;
  height: 18px;
  border-radius: 3px;
  font-size: 10px;
  font-weight: 700;
  color: rgba(255, 255, 255, 0.5);
  background: rgba(255, 255, 255, 0.06);

  &.rank-1 { background: #e6a817; color: #fff; }
  &.rank-2 { background: #8899aa; color: #fff; }
  &.rank-3 { background: #a0724a; color: #fff; }
}

// ======== 地图区域 ========
.map-section {
  flex: 1;
  position: relative;
  border-radius: 4px;
  overflow: hidden;
  border: 1px solid rgba(0, 229, 255, 0.25);
  background:
    radial-gradient(ellipse at 55% 40%, rgba(14, 55, 115, 0.6) 0%, rgba(8, 28, 60, 0.75) 40%, rgba(4, 14, 35, 0.88) 100%);
  box-shadow:
    inset 0 0 80px rgba(0, 229, 255, 0.05),
    inset 0 0 30px rgba(54, 163, 247, 0.04),
    0 0 20px rgba(0, 229, 255, 0.06),
    0 0 40px rgba(54, 163, 247, 0.04);
  min-width: 0;
}

.map-glow {
  position: absolute;
  inset: 0;
  z-index: -1;
  pointer-events: none;
  background:
    radial-gradient(ellipse at 50% 40%, rgba(0, 150, 255, 0.04) 0%, transparent 50%),
    radial-gradient(ellipse at 30% 70%, rgba(0, 230, 118, 0.025) 0%, transparent 40%);
  animation: mapBreath 6s ease-in-out infinite;
}

@keyframes mapBreath {
  0%, 100% { opacity: 0.6; }
  50% { opacity: 1; }
}

.map-grid {
   position: absolute;
   inset: 0;
   z-index: -1;
   pointer-events: none;
   overflow: hidden;
}

// ======== 2.5D 透视网格地板 ========
.floor-scene {
  position: absolute;
  inset: 0;
  perspective: 900px;
  perspective-origin: 50% 0%;
  overflow: hidden;
}

.grid-plane {
  position: absolute;
  left: -80%;
  right: -80%;
  bottom: -20%;
  height: 220%;
  transform: rotateX(48deg);
  transform-origin: bottom center;
  background-image:
    radial-gradient(circle, rgba(0, 220, 255, 0.38) 2px, transparent 2px);
  background-size: 18px 18px;
  animation: gridMove 12s linear infinite;
  will-change: background-position;
}

@keyframes gridMove {
  0% { background-position: 0 0; }
  100% { background-position: 18px 18px; }
}

.grid-fade {
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  height: 38%;
  background: linear-gradient(180deg,
    rgba(5, 10, 31, 0.55) 0%,
    rgba(5, 10, 31, 0.15) 15%,
    transparent 38%
  );
  pointer-events: none;
}

.horizon-glow {
  position: absolute;
  top: 8%;
  left: 0;
  right: 0;
  height: 180px;
  background: radial-gradient(ellipse at center, rgba(0, 200, 255, 0.15) 0%, rgba(0, 150, 255, 0.05) 35%, transparent 70%);
  pointer-events: none;
}

.horizon-line {
  position: absolute;
  top: calc(8% + 88px);
  left: 10%;
  right: 10%;
  height: 1.5px;
  background: linear-gradient(90deg, transparent 0%, rgba(0, 220, 255, 0.25) 20%, rgba(0, 240, 255, 0.45) 50%, rgba(0, 220, 255, 0.25) 80%, transparent 100%);
  pointer-events: none;
  box-shadow: 0 0 15px rgba(0, 200, 255, 0.12), 0 0 40px rgba(0, 200, 255, 0.04);
}

.breath-dot {
  position: absolute;
  width: 6px;
  height: 6px;
  border-radius: 50%;
  z-index: 3;
  animation: breathe 2.5s ease-in-out infinite;
  &.dot-tl { top: 14px; left: 14px; background: #00E676; box-shadow: 0 0 6px #00E676, 0 0 14px #00E676; }
  &.dot-tr { top: 14px; right: 14px; background: #36A3F7; box-shadow: 0 0 6px #36A3F7, 0 0 14px #36A3F7; animation-delay: 0.8s; }
  &.dot-bl { bottom: 14px; left: 14px; background: #00E5FF; box-shadow: 0 0 6px #00E5FF, 0 0 14px #00E5FF; animation-delay: 1.6s; }
  &.dot-br { bottom: 14px; right: 14px; background: #36A3F7; box-shadow: 0 0 6px #36A3F7, 0 0 14px #36A3F7; animation-delay: 0.4s; }
}

@keyframes breathe {
  0%, 100% { opacity: 0.3; transform: scale(0.8); }
  50% { opacity: 1; transform: scale(1.4); }
}

// ======== 底部雷达扫描（跟随地图中心） ========
.bottom-radar {
  position: absolute;
  z-index: -1;
  pointer-events: none;
  transform: translate(-50%, -50%);
}

.br-ring {
  position: absolute;
  top: 50%;
  left: 50%;
  border-radius: 50%;
  border: 1px solid rgba(0, 230, 118, 0.35);
  animation: brExpand 5s ease-out infinite;
  transform-origin: center;
}
.br-ring.r1 { width: 10px; height: 10px; margin: -5px 0 0 -5px; animation-delay: 0s; }
.br-ring.r2 { width: 10px; height: 10px; margin: -5px 0 0 -5px; animation-delay: 1.2s; }
.br-ring.r3 { width: 10px; height: 10px; margin: -5px 0 0 -5px; animation-delay: 2.4s; }

.br-beam {
  position: absolute;
  top: 50%;
  left: 50%;
  width: 6px;
  height: 6px;
  margin: -3px 0 0 -3px;
  border-radius: 50%;
  background: rgba(0, 230, 118, 0.6);
  box-shadow: 0 0 12px rgba(0, 230, 118, 0.4), 0 0 40px rgba(0, 230, 118, 0.15);
  animation: brPulse 2s ease-in-out infinite;
}

@keyframes brExpand {
  0% {
    transform: scale(0.1);
    opacity: 0.8;
    border-width: 1.5px;
    border-color: rgba(0, 230, 118, 0.55);
  }
  50% {
    opacity: 0.35;
    border-color: rgba(0, 229, 255, 0.25);
  }
  100% {
    transform: scale(90);
    opacity: 0;
    border-width: 0.2px;
    border-color: rgba(0, 229, 255, 0);
  }
}

@keyframes brPulse {
  0%, 100% { transform: scale(0.8); opacity: 0.3; }
  50% { transform: scale(1.3); opacity: 0.7; }
}

// ======== 地图容器底部光晕 ========
.map-section::after {
  content: '';
  position: absolute;
  bottom: 0;
  left: 0;
  right: 0;
  height: 35%;
  background: linear-gradient(0deg, rgba(0, 230, 118, 0.035) 0%, transparent 100%);
  pointer-events: none;
  z-index: -1;
}

.map-perspective {
  width: 100%;
  height: 100%;
  perspective: 1200px;
}

.map-chart {
  width: 100%;
  height: 100%;
  transform: rotateX(8deg);
  transform-origin: center center;
  transition: transform 0.3s ease;
}

.map-legend {
  position: absolute;
  bottom: 10px;
  left: 50%;
  transform: translateX(-50%);
  display: flex;
  gap: 16px;
  z-index: 2;
}

.legend-item {
  position: relative;
  display: flex;
  align-items: center;
  gap: 6px;
  padding: 6px 16px 6px 12px;
  background: rgba(10, 22, 50, 0.82);
  border: 1px solid rgba(0, 230, 118, 0.2);
  border-radius: 18px;
  font-size: 12px;
  color: rgba(255, 255, 255, 0.85);
  cursor: default;
  letter-spacing: 0.5px;
  box-shadow: 0 0 12px rgba(0, 230, 118, 0.06);
  transition: all 0.3s;

  &:hover {
    background: rgba(10, 22, 50, 0.92);
    border-color: rgba(0, 230, 118, 0.4);
    box-shadow: 0 0 20px rgba(0, 230, 118, 0.12);
  }
}

.legend-leaf-icon {
  display: inline-block;
  width: 16px;
  height: 16px;
  background: currentColor;
  mask: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 48 48'%3E%3Cpath d='M24 4 Q8 18 8 28 Q8 40 20 44 L24 38 L28 44 Q40 40 40 28 Q40 18 24 4 Z M24 38 L24 47'/%3E%3C/svg%3E") no-repeat center/contain;
  -webkit-mask: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 48 48'%3E%3Cpath d='M24 4 Q8 18 8 28 Q8 40 20 44 L24 38 L28 44 Q40 40 40 28 Q40 18 24 4 Z M24 38 L24 47'/%3E%3C/svg%3E") no-repeat center/contain;
  color: #00E676;
  filter: drop-shadow(0 0 4px rgba(0, 230, 118, 0.35));
  flex-shrink: 0;
}

.legend-tooltip {
  position: absolute;
  bottom: calc(100% + 10px);
  left: 50%;
  transform: translateX(-50%);
  padding: 6px 12px;
  background: rgba(10, 22, 50, 0.94);
  border: 1px solid rgba(0, 230, 118, 0.25);
  border-radius: 6px;
  font-size: 11px;
  color: rgba(255, 255, 255, 0.8);
  white-space: nowrap;
  box-shadow: 0 0 12px rgba(0, 230, 118, 0.08);
  pointer-events: none;
}

.tip-arrow {
  position: absolute;
  bottom: -5px;
  left: 50%;
  transform: translateX(-50%) rotate(45deg);
  width: 8px;
  height: 8px;
  background: rgba(10, 22, 50, 0.94);
  border-right: 1px solid rgba(0, 230, 118, 0.25);
  border-bottom: 1px solid rgba(0, 230, 118, 0.25);
}

.tip-fade-enter-active, .tip-fade-leave-active {
  transition: opacity 0.2s ease, transform 0.2s ease;
}
.tip-fade-enter, .tip-fade-leave-to {
  opacity: 0;
  transform: translateX(-50%) translateY(4px);
}

// ======== 操作按钮 ========
.action-buttons {
  position: absolute;
  right: 14px;
  top: 14px;
  display: flex;
  flex-direction: column;
  gap: 6px;
  z-index: 10;
}

.action-btn {
  width: 30px;
  height: 30px;
  display: flex;
  align-items: center;
  justify-content: center;
  border-radius: 4px;
  background: rgba(15, 33, 71, 0.8);
  border: 1px solid rgba(0, 212, 255, 0.12);
  color: rgba(255, 255, 255, 0.45);
  cursor: pointer;
  transition: all 0.3s;
  &:hover {
    color: #00E5FF;
    border-color: rgba(0, 229, 255, 0.45);
    box-shadow: 0 0 10px rgba(0, 229, 255, 0.15);
  }
  i { font-size: 14px; }
}

// ======== 过渡动画 ========
.fade-enter-active,
.fade-leave-active {
  transition: opacity 0.4s ease;
}
.fade-enter,
.fade-leave-to {
  opacity: 0;
}
</style>