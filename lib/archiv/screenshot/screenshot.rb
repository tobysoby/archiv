require 'fileutils'
require 'parallel'
require 'yaml/store'
require './selenium_scripts/selenium_scripts.rb'

module Archiv
    def self.takeScreenshots
        Archiv.createScreenshotFolder

        # if we want to simulate, don't do nuffin, just simulate
        if @@options[:simulate]
            simulateScreenshots
            return
        end

        urls = @@options[:urls]
        viewports = @@options[:viewports]

        urls.each_with_index do |url, i|

            store_url = YAML::Store.new @@options[:screenshot_path] + "/" + url["name"] + "_store.store"
        
            Parallel.each(viewports) do |vp|
                puts "screenshotting " + url["name"] + '_' + vp[:name]
        
                screenshots_per_viewport = []
        
                driver = createDriver(vp)
                driver.navigate.to url["url"]

                # maybe sleep
                if url["sleep"] != nil
                    sleep(url["sleep"])
                end
                #sleep(1)

                # execute selenium scripts before screenshotting
                if url["before"]
                    script_name = url["before"] + "(driver)"
                    eval(script_name)
                end
        
                # get sizes of page
                width  = driver.execute_script("return Math.max(document.body.scrollWidth, document.body.offsetWidth, document.documentElement.clientWidth, document.documentElement.scrollWidth, document.documentElement.offsetWidth);")
                height = driver.execute_script("return Math.max(document.body.scrollHeight, document.body.offsetHeight, document.documentElement.clientHeight, document.documentElement.scrollHeight, document.documentElement.offsetHeight);")

                # take the screenshot from the beginning of the page
                screenshot_filename = url["name"] + '_' + vp[:name] + '_0'
                driver.save_screenshot(@@options[:screenshot_path] + '/' + screenshot_filename + '.png')

                screenshot_md5 = Digest::MD5.file(@@options[:screenshot_path] + '/' + screenshot_filename + '.png').hexdigest

                screenshot = {
                    filename: screenshot_filename,
                    viewport: vp[:name],
                    timestamp: Time.now,
                    md5: screenshot_md5
                }
                screenshots_per_viewport.push screenshot

                # take the rest of the screenshots
                # but only if configured
                if url["screenshot_all_pages"] == true
                    for y in 1..(height / (vp[:height] + 1))
                        driver.execute_script("scroll(0, " + (y * vp[:height]).to_s + ");")
                        # wait for animations
                        sleep(0.5)
                        screenshot_filename = url["name"] + '_' + vp[:name] + '_' + y.to_s
                        driver.save_screenshot(@@options[:screenshot_path] + '/' + screenshot_filename + '.png')

                        screenshot_md5 = Digest::MD5.file(@@options[:screenshot_path] + '/' + screenshot_filename + '.png').hexdigest

                        screenshot = {
                            filename: screenshot_filename,
                            viewport: vp[:name],
                            timestamp: Time.now,
                            md5: screenshot_md5
                        }
                        screenshots_per_viewport.push screenshot
                    end
                end
                
                store_url.transaction { store_url[vp[:name]] = screenshots_per_viewport }
                
                driver.quit
            end

            viewports_for_store= []
            viewports.each do |vp|
                viewports_for_store.push vp[:name]
            end

            store_url.transaction { store_url["name"] = url["name"] }
            store_url.transaction { store_url["viewports"] = viewports_for_store }
        end
    end

    def self.simulateScreenshots
        urls = @@options[:urls]
        viewports = @@options[:viewports]

        urls.each_with_index do |url, i|
            store_url = YAML::Store.new @@options[:screenshot_path] + "/" + url["name"] + "_store.store"

            viewports.each do |vp|
                puts "screenshotting " + url["name"] + '_' + vp[:name]
        
                screenshots_per_viewport = []
                
                screenshot_filename = url["name"] + '_' + vp[:name] + '_0'

                FileUtils.cp "./lib/archiv/screenshot/simulation_images/react_github_" + vp[:name] + '.png' , @@options[:screenshot_path] + "/" + screenshot_filename + '.png'

                screenshot_md5 = Digest::MD5.file(@@options[:screenshot_path] + "/" + screenshot_filename + '.png').hexdigest
                
                screenshot = {
                    filename: screenshot_filename,
                    viewport: vp[:name],
                    timestamp: Time.now,
                    md5: screenshot_md5
                }
                screenshots_per_viewport.push screenshot

                # take the rest of the screenshots
                # but only if configured
                if url["screenshot_all_pages"] == true
                    screenshot_filename_1 = url["name"] + '_' + vp[:name] + '_1'
                    FileUtils.cp "./lib/archiv/screenshot/simulation_images/react_github_" + vp[:name] + '.png' , @@options[:screenshot_path] + "/" + screenshot_filename_1 + '.png'
                    screenshot = {
                        filename: screenshot_filename_1,
                        viewport: vp[:name],
                        timestamp: Time.now,
                        md5: screenshot_md5
                    }
                    screenshots_per_viewport.push screenshot
                end
        
                store_url.transaction { store_url[vp[:name]] = screenshots_per_viewport }
            end

            viewports_for_store= []
            viewports.each do |vp|
                viewports_for_store.push vp[:name]
            end

            store_url.transaction { store_url["name"] = url["name"] }
            store_url.transaction { store_url["viewports"] = viewports_for_store }
        end
    end
end