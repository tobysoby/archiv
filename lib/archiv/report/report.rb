require 'erb'
require 'yaml/store'

module Archiv
    def self.buildReport
        puts "creating report"

        # create directories
        Archiv.createReportFolder
        
        # copy screenshots and stores
        FileUtils.cp_r @@options[:screenshot_path] + '/.', @@options[:report_path] + '/images/'
        
        # get url data
        # get all store files
        store_files = Dir[@@options[:report_path] + '/images/*.store']
        @viewports = @@options[:viewports]
        urls = []
        store_files.each do |store_file|
            url_hash = Hash.new
            store_url = YAML::Store.new store_file
            url_hash[:name] = store_url.transaction { store_url.fetch("name", []) }
            screenshots_first_per_viewport = []
            @viewports.each do |vp|
                screenshots_for_viewport = store_url.transaction { store_url.fetch(vp[:name], []) }
                screenshots_first_per_viewport.push screenshots_for_viewport[0]
                url_hash[vp[:name]] = screenshots_for_viewport
            end
            url_hash[:screenshots_first_per_viewport] = screenshots_first_per_viewport
            urls.push url_hash
        end

        # render main report page
        # render template
        template = File.read('./lib/archiv/report/report_template.html.erb')
        @urls = urls
        result = ERB.new(template).result(binding)
        # write result to file
        File.open(@@options[:report_path] + '/report.html', 'w+') do |f|
        f.write result
        end
        
        # render detail
        urls.each do |url|
            @url = url
            # render template
            template = File.read('./lib/archiv/report/report_detail_template.html.erb')
            result = ERB.new(template).result(binding)
    
            # write result to file
            File.open(@@options[:report_path] + '/report_' + url[:name] + '.html', 'w+') do |f|
                f.write result
            end
        end
        
        puts "Finished report!"
    end

    def self.buildCompareReport
        # get the diffs
        @diffs = @@options[:diffs]

        puts "creating report"

        # create directories
        Archiv.createReportFolder
        
        # copy screenshots
        @diffs.each do |diff_hash|
            FileUtils.cp diff_hash[1][:path_diff], @@options[:report_path] + "/images/"
        end

        # render template
        template = File.read('./lib/archiv/report/report_diff_template.html.erb')
        result = ERB.new(template).result(binding)
    
        # write result to file
        File.open(@@options[:report_path] + '/report.html', 'w+') do |f|
            f.write result
        end
        
        puts "Finished report!"
    end
end