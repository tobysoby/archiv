require 'yaml'

require './lib/archiv/options/devices.rb'

module Archiv
    @@options = Hash.new

    def self.initiateOptions
        setOptions
    end

    def self.setOptions
        getCommandLineArguments
        getOptionsFromConfig
        getDevices
    end
    
    def self.recordOptions
        return @@options[:record]
    end
    
    def self.reportOptions
        return @@options[:report]
    end
    
    def self.compareOptions
        return @@options[:compare]
    end

    def self.getCommandLineArguments
        ARGV.each do |a|
            if (a.include?("-simulate") || a.include?("--s"))
                @@options[:simulate] = true
                puts "Running archiv in simulation mode!"
            end
            if (a.include?("-report") || a.include?("--rt"))
                @@options[:report] = true
            end
            if (a.include?("-record") || a.include?("--rd"))
                @@options[:record] = true
            end
            if (a.include?("-compare") || a.include?("--c"))
                @@options[:compare] = true
            end
            if (a.include?("-help") || a.include?("--h"))
                puts "Archiv"
                puts "------"
                puts "Version " + File.read("./version.txt")
                puts ""
                puts "-report / --rt: Let the script create reports for websites"
                puts "-simulate / --s: Simulate the run"
                puts "-record / --rd: Record a fixed state of a website for later comparison"
                puts "-compare / --c: Compare the archived screenshots to new ones"
                puts "-devices / --d: Show all available devices"
                exit(true)
            end
            if (a.include?("-devices") || a.include?("--d"))
                puts "Available devices"
                puts "-----------------"
                puts ""
                available_viewports =  getAllViewports
                available_viewports.each do |vp|
                    puts "-" + vp[1][:name].to_s
                end
                exit(true)
            end
        end
    end

    def self.getOptionsFromConfig
        config = YAML.load_file('./archiv.config')

        urls_config = config["urls_config"]
        urls_config = YAML.load_file(urls_config)

        urls = urls_config["urls"]

        # clean urls
        urls_to_delete = []
        urls.each_with_index do |url, i|
            if url["run"] == false
                urls_to_delete.push url
            end
        end

        urls_to_delete.each do |url_to_delete|
            urls.delete(url_to_delete)
        end

        selenium_hub_url = config["selenium_hub_url"]
        appium_hub_url = config["appium_hub_url"]
        devices = config["devices"]
        screenshot_path = config["screenshot_path"]
        archiv_path = config["archiv_path"]
        compare_path = config["compare_path"]
        report_path = config["report_path"]
        bitbar_apikey = config["bitbar_apikey"]
        compare_threshold = config["compare_threshold"]
        score_threshold = config["score_threshold"]

        @@options[:urls] = urls
        @@options[:selenium_hub_url] = selenium_hub_url
        @@options[:appium_hub_url] = appium_hub_url
        @@options[:devices] = devices
        @@options[:screenshot_path] = screenshot_path
        @@options[:archiv_path] = archiv_path
        @@options[:compare_path] = compare_path
        @@options[:report_path] = report_path
        @@options[:bitbar_apikey] = bitbar_apikey
        @@options[:compare_threshold] = compare_threshold
        @@options[:score_threshold] = score_threshold
    end

    def self.getDevices
        viewports = []
        @@options[:devices].each do |device|
            viewport = getViewport(device)
            viewports.push viewport
        end
        @@options[:viewports] = viewports
    end
end