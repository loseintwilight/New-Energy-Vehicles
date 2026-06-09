const AMAP_KEY = '34638d9d59b6bbc7b097e2c8fb5ad07c'

export function getAMapKey() {
  return AMAP_KEY
}

export function getLocation() {
  return new Promise((resolve, reject) => {
    uni.getLocation({
      type: 'gcj02',
      isHighAccuracy: true,
      timeout: 10000,
      success: (res) => {
        resolve({
          latitude: res.latitude,
          longitude: res.longitude,
          accuracy: res.accuracy
        })
      },
      fail: (e) => reject(e)
    })
  })
}

export function navigateTo({ lat, lng, name, address }) {
  const targetLat = parseFloat(lat) || 36.548
  const targetLng = parseFloat(lng) || 116.801

  // #ifdef MP-WEIXIN
  uni.openLocation({
    latitude: targetLat,
    longitude: targetLng,
    name: name || '充电站',
    address: address || '',
    scale: 18
  })
  // #endif

  // #ifdef APP-PLUS
  uni.openLocation({
    latitude: targetLat,
    longitude: targetLng,
    name: name || '充电站',
    address: address || '',
    scale: 18
  })
  // #endif

  // #ifdef H5
  window.open(
    'https://uri.amap.com/navigation?to=' + targetLng + ',' + targetLat + ',' +
    encodeURIComponent(name || '充电站') + '&mode=car&coordinate=gaode',
    '_blank'
  )
  // #endif
}

export function openLocation({ lat, lng, name, address }) {
  uni.openLocation({
    latitude: parseFloat(lat) || 0,
    longitude: parseFloat(lng) || 0,
    name: name || '',
    address: address || '',
    scale: 18
  })
}

let geocoderCache = {}

export function reverseGeocode(lng, lat) {
  const cacheKey = lng.toFixed(5) + ',' + lat.toFixed(5)
  if (geocoderCache[cacheKey]) {
    return Promise.resolve(geocoderCache[cacheKey])
  }

  return new Promise((resolve) => {
    uni.request({
      url: 'https://restapi.amap.com/v3/geocode/regeo',
      data: {
        key: AMAP_KEY,
        location: lng + ',' + lat,
        extensions: 'base',
        output: 'JSON'
      },
      success: (res) => {
        if (res.data && res.data.status === '1' && res.data.regeocode) {
          const result = {
            address: res.data.regeocode.formatted_address || '',
            city: (res.data.regeocode.addressComponent || {}).city || '',
            district: (res.data.regeocode.addressComponent || {}).district || ''
          }
          geocoderCache[cacheKey] = result
          resolve(result)
        } else {
          resolve(null)
        }
      },
      fail: () => resolve(null)
    })
  })
}

export function searchNearby({ lat, lng, keywords, radius = 5000, pageIndex = 1, pageSize = 20 }) {
  return new Promise((resolve) => {
    uni.request({
      url: 'https://restapi.amap.com/v3/place/around',
      data: {
        key: AMAP_KEY,
        location: lng + ',' + lat,
        keywords: keywords || '充电站',
        types: '011100',
        radius: radius,
        offset: pageSize,
        page: pageIndex,
        extensions: 'all',
        output: 'JSON'
      },
      success: (res) => {
        if (res.data && res.data.status === '1') {
          resolve(res.data)
        } else {
          resolve(null)
        }
      },
      fail: () => resolve(null)
    })
  })
}

export default {
  getAMapKey,
  getLocation,
  navigateTo,
  openLocation,
  reverseGeocode,
  searchNearby,
  geocode,
  getDrivingRoute,
  getDrivingRoutes
}

export function geocode(address) {
  return new Promise((resolve) => {
    uni.request({
      url: 'https://restapi.amap.com/v3/geocode/geo',
      data: {
        key: AMAP_KEY,
        address: address,
        output: 'JSON'
      },
      success: (res) => {
        if (res.data && res.data.status === '1' && res.data.geocodes && res.data.geocodes.length > 0) {
          const geo = res.data.geocodes[0]
          const location = geo.location.split(',')
          resolve({
            latitude: parseFloat(location[1]),
            longitude: parseFloat(location[0]),
            address: geo.formatted_address || address,
            city: (geo.city || '').replace('市', '市'),
            district: geo.district || ''
          })
        } else {
          resolve(null)
        }
      },
      fail: () => resolve(null)
    })
  })
}

/** 高德驾车路径规划 - 获取多条路线（仿APP：推荐/最快/最短/躲避拥堵） */
export function getDrivingRoutes({ fromLat, fromLng, toLat, toLng }) {
  // strategy=11 一次返回3条（最快/最短/躲避拥堵），再额外调 strategy=10 拿推荐路线

  function doRequest(strat) {
    return new Promise((resolve) => {
      uni.request({
        url: 'https://restapi.amap.com/v3/direction/driving',
        data: {
          key: AMAP_KEY,
          origin: fromLng + ',' + fromLat,
          destination: toLng + ',' + toLat,
          strategy: strat,
          extensions: 'all',
          output: 'JSON',
          s: 'rsx',
          platform: 'WXJS',
          appname: AMAP_KEY,
          sdkversion: '1.2.0',
          logversion: '2.0'
        },
        success: (res) => {
          if (res.data && res.data.status === '1' && res.data.route) {
            const path = res.data.route.paths[0]
            if (path) resolve({ path, route: res.data.route })
            else resolve(null)
          } else {
            resolve(null)
          }
        },
        fail: () => resolve(null)
      })
    })
  }

  return new Promise((resolve, reject) => {
    // strategy=11 一次返回3条，所以先调 strategy=11 获取路线列表
    uni.request({
      url: 'https://restapi.amap.com/v3/direction/driving',
      data: {
        key: AMAP_KEY,
        origin: fromLng + ',' + fromLat,
        destination: toLng + ',' + toLat,
        strategy: 11,
        extensions: 'all',
        output: 'JSON',
        s: 'rsx',
        platform: 'WXJS',
        appname: AMAP_KEY,
        sdkversion: '1.2.0',
        logversion: '2.0'
      },
      success: (multiRes) => {
        if (!multiRes.data || multiRes.data.status !== '1' || !multiRes.data.route) {
          // 降级为单路线
          doRequest(0).then(result => {
            if (result) {
              const route = parsePath(result.path, result.route, 0)
              resolve([{ ...route, label: '推荐', subLabel: '默认路线', tag: 'primary' }])
            } else {
              reject(new Error('路线规划失败'))
            }
          })
          return
        }

        const route = multiRes.data.route
        const paths = route.paths || []
        const labels = ['最快', '最短', '躲避拥堵']
        const results = paths.slice(0, 3).map((path, i) => {
          const parsed = parsePath(path, route, i)
          return { ...parsed, label: labels[i], subLabel: '', tag: i === 0 ? 'primary' : '' }
        })

        // 额外调 strategy=10 获取推荐路线
        doRequest(10).then(recResult => {
          if (recResult) {
            const rec = parsePath(recResult.path, recResult.route, 10)
            results.unshift({ ...rec, label: '推荐', subLabel: '综合最优', tag: 'primary' })
          }
          resolve(results.slice(0, 5))
        }).catch(() => {
          resolve(results)
        })
      },
      fail: () => {
        doRequest(0).then(result => {
          if (result) {
            const route = parsePath(result.path, result.route, 0)
            resolve([{ ...route, label: '推荐', subLabel: '默认路线', tag: 'primary' }])
          } else {
            reject(new Error('路线规划失败'))
          }
        })
      }
    })
  })
}

/** 解析单条路径 */
function parsePath(path, route, strategy) {
  const rawPoints = []
  path.steps.forEach(step => {
    if (!step.polyline) return
    const coords = step.polyline.split(';')
    coords.forEach(coord => {
      if (!coord) return
      const parts = coord.split(',')
      if (parts.length !== 2) return
      const lng = parseFloat(parts[0])
      const lat = parseFloat(parts[1])
      if (isNaN(lat) || isNaN(lng)) return
      rawPoints.push({ latitude: lat, longitude: lng })
    })
  })

  const points = simplifyPoints(rawPoints, 5)
  return {
    points: points.length > 0 ? points : rawPoints,
    distance: parseInt(path.distance),
    duration: parseInt(path.duration),
    tolls: parseFloat(path.tolls) || 0,
    strategy
  }
}

/** 单路线（向后兼容） */
export function getDrivingRoute(params) {
  return getDrivingRoutes(params).then(routes => routes[0] || Promise.reject(new Error('无路线')))
}

/** 简化 polyline 点（Douglas-Peucker 简化，按间隔采样） */
function simplifyPoints(points, interval) {
  if (!points || points.length < 2) return points
  const result = [points[0]]
  for (let i = interval; i < points.length - 1; i += interval) {
    result.push(points[i])
  }
  result.push(points[points.length - 1])
  return result
}