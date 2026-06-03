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
  geocode
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