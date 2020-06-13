def initiateViewports
    @viewports = Hash.new
    @viewports["xs"] = {
        appium: false,
        name: "xs_Portrait_phone_iPhone_SE",
        width: 320,
        height: 568,
        device_name: 'iPhone SE',
        user_agent: 'Mozilla/5.0 (iPhone; CPU iPhone OS 10_3 like Mac OS X) AppleWebKit/602.1.50 (KHTML, like Gecko) CriOS/56.0.2924.75 Mobile/14E5239e Safari/602.1'
    }
    @viewports["sd_landscape"] = {
        appium: false,
        name: "sd_Landscape_phone_Samsung_galaxy_S7", 
        width: 640, 
        height: 360, 
        device_name: 'Samsung Galaxy S7 Landscape',
        user_agent: 'Mozilla/5.0 (Linux; Android 7.0; SM-G930VC Build/NRD90M; wv) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/58.0.3029.83 Mobile Safari/537.36'
    }
    @viewports["sd_portrait"] = {
        appium: false,
        name: "sd_Portrait_phone_Samsung_galaxy_S7", 
        width: 360, 
        height: 640, 
        device_name: 'Samsung Galaxy S7 Portrait',
        user_agent: 'Mozilla/5.0 (Linux; Android 7.0; SM-G930VC Build/NRD90M; wv) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/58.0.3029.83 Mobile Safari/537.36'
    }
    @viewports["md"] = {
        appium: false,
        name: "md_Tablets_iPad_Air_2", 
        width: 1024, 
        height: 768, 
        device_name: 'iPad Air 2',
        user_agent: 'Mozilla/5.0 (iPad; CPU OS 11_2_2 like Mac OS X) AppleWebKit/604.4.7 (KHTML, like Gecko) Mobile/15C202 [FBAN/FBIOS;FBAV/157.0.0.42.96;FBBV/90008621;FBDV/iPad5,4;FBMD/iPad;FBSN/iOS;FBSV/11.2.2;FBSS/2;FBCR/vodafoneP;FBID/tablet;FBLC/pt_PT;FBOP/5;FBRV/0]'
    }
    @viewports["lg"] = {
        appium: false,
        name: "lg_Laptop_MacBook_pro_13", 
        width: 1280, 
        height: 800, 
        device_name: 'MacBook pro 13',
        user_agent: 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/60.0.3112.90 Safari/537.36'
    }
    @viewports["xl"] = {
        appium: false,
        name: "xl_Extralarge_desktops", 
        width: 1920, 
        height: 1080, 
        device_name: 'Laptop with HiDPI screen',
        user_agent: 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/60.0.3112.90 Safari/537.36'
    }
    @viewports["iPhone X"] = {
        appium: true,
        name: "iPhone_x",
        appium_name: "iPhone X",
        width: 375,
        height: 812,
        platform: "iOS"
    }
    @viewports["iPhone SE"] = {
        appium: true,
        name: "iPhone_SE",
        appium_name: "iPhone SE",
        width: 320,
        height: 568,
        platform: "iOS"
    }
    @viewports["iPhone SE bitbar"] = {
        bitbar: true,
        name: "iPhone_SE",
        bitbar_name: "Apple iPhone SE A1662",
        ios_version: "11.2.6",
        width: 320,
        height: 568,
        platform: "iOS"
    }
    @viewports["Huawei P10 bitbar"] = {
        bitbar: true,
        name: "Huawei_P10",
        bitbar_name: "Huawei P10",
        width: 320,
        height: 568,
        platform: "Android"
    }
    @viewports["iPhone SE 11.4.1 saucelabs"] = {
        saucelabs: true,
        name: "iPhone_SE_11_real",
        width: 640,
        height: 1136,
        platform: "iOS"
    }
    @viewports["iPhone XR 13.5 saucelabs"] = {
        saucelabs: true,
        name: "iPhone_XR_13_real",
        width: 828,
        height: 1792,
        platform: "iOS"
    }
    @viewports["Samsung Galaxy S10 Android 10 saucelabs"] = {
        saucelabs: true,
        name: "Samsung_Galaxy_S10_real",
        width: 1440,
        height: 3040,
        platform: "Android"
    }
    return @viewports
end

def getViewport (device)
    viewports = initiateViewports
    return viewports[device]
end

def getAllViewports
    viewports = initiateViewports
    return viewports
end