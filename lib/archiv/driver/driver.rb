require 'selenium-webdriver'
require 'appium_lib'

module Archiv
    def self.createDriver(vp)
        if vp[:saucelabs]
            driver = getSaucelabsDriver(vp)
        elsif vp[:appium]
                driver = getAppiumDriver(vp)
        elsif vp[:bitbar]
            driver = getBitbarDriver(vp)
        else
            driver = getSeleniumDriver(vp)
        end

        return driver
    end

    def self.getSeleniumDriver(vp)
        mobile_emulation = {

            "deviceMetrics" => { "width" => vp[:width], "height" => vp[:height]},#, "pixelRatio" => 3.0 },
            "userAgent" => vp[:user_agent]

        }

        caps = Selenium::WebDriver::Remote::Capabilities.chrome(
            "chromeOptions" => { 
                "mobileEmulation" => mobile_emulation 
            }
        )

        driver = Selenium::WebDriver.for :remote, url: @@options[:selenium_hub_url], desired_capabilities: caps

        return driver
    end

    def self.getAppiumDriver(vp)
        if vp[:platform] == "iOS"
            desired_caps = {
                platformName: 'iOS',
                platformVersion: '11.4',
                browserName: 'Safari',
            }
        elsif vp[:platform] == "Android"
            desired_caps = {
                platformName: 'iOS',
                platformVersion: '11.4',
                browserName: 'Safari',
            }
        end

        desired_caps[:deviceName] = vp[:appium_name]
        desired_caps[:takesScreenshot] = true

        appium_hub_url = @@options[:appium_hub_url]

        driver = Selenium::WebDriver.for(:remote, desired_capabilities: desired_caps, url: appium_hub_url)

        return driver
    end

    def self.getBitbarDriver(vp)
        if vp[:platform] == "iOS"
            desired_caps = {
                platformName: 'iOS',
                platformVersion: vp[:ios_version],
                browserName: 'safari',
                testdroid_target: 'safari',
                #bundleId: 'com.bitbar.testdroid.BitbarIOSSample',
            }
        elsif vp[:platform] == "Android"
            desired_caps = {
                platformName: 'Android',
                platformVersion: '11.4',
                browserName: 'chrome',
                testdroid_target: 'chrome',
            }
        end

        desired_caps[:deviceName] = vp[:bitbar_name]
        desired_caps[:takesScreenshot] = true
        desired_caps[:testdroid_apiKey] = @@options[:bitbar_apikey]
        desired_caps[:testdroid_project] = "Archiv"
        desired_caps[:testdroid_testrun] = "test run 1"
        desired_caps[:testdroid_device] = vp[:bitbar_name]
        desired_caps[:testdroid_testTimeout] = '1200'

        puts desired_caps

        appium_hub_url = "https://appium.bitbar.com/wd/hub"

        driver = Selenium::WebDriver.for(:remote, desired_capabilities: desired_caps, url: appium_hub_url)

        return driver
    end

    def self.getSaucelabsDriver(vp)

        desired_caps = {
            username: @@options[:testobject_username],
            testobject_api_key: @@options[:testobject_apikey],
        }

        if vp[:platform] == "iOS"
            desired_caps['platformName'] = 'iOS'
            desired_caps['browserName'] = 'safari'
            desired_caps['deviceOrientation'] = 'portrait'
            desired_caps['deviceName'] = vp[:name]
        elsif vp[:platform] == "Android"
            desired_caps['platformName'] = 'Android'
            desired_caps['browserName'] = 'chrome'
            desired_caps['deviceOrientation'] = 'portrait'
            desired_caps['deviceName'] = vp[:name]
        end

        appium_hub_url = "https://eu1.appium.testobject.com/wd/hub"

        driver = Selenium::WebDriver.for(:remote, desired_capabilities: desired_caps, url: appium_hub_url)

        return driver
    end
end