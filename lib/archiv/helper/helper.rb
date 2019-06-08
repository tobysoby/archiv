module Archiv
    def self.createScreenshotFolder
        path = @@options[:screenshot_path]
        FileUtils::mkdir_p path
    end

    def self.createReportFolder
        path = @@options[:report_path]
        FileUtils::mkdir_p path
        path = @@options[:report_path] + "/images/"
        FileUtils::mkdir_p path
    end

    def self.createArchivFolder
        path = @@options[:archiv_path]
        FileUtils::mkdir_p path
    end

    def self.createCompareFolder
        path = @@options[:compare_path]
        FileUtils::mkdir_p path
    end

    def self.cleanFolders
        FileUtils.rm_rf(@@options[:screenshot_path])
        FileUtils.rm_rf(@@options[:report_path])
        FileUtils.rm_rf(@@options[:compare_path])
    end

    def self.cleanArchivedScreenshots
        FileUtils.rm_rf(@@options[:archiv_path])
    end

    def self.createFolderForUrl(url)
        path = @@options[:screenshot_path] + '/' + url["name"].to_s
        FileUtils::mkdir_p path
    end
end