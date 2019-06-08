module Archiv
    def self.recordScreenshots
        urls = @@options[:urls]

        # create directories
        Archiv.createArchivFolder

=begin
        urls.each do |url|
            path = @@options[:archiv_path] + '/' + url["name"]
            FileUtils::mkdir_p path
        end

        # copy all files
        FileUtils.copy_entry @@options[:screenshot_path], @@options[:archiv_path]

        # save urls as json
        File.open(@@options[:archiv_path] + "/archiv.json","w") do |f|
            f.write(urls.to_json)
        end
=end
        # copy screenshots and stores
        FileUtils.cp_r @@options[:screenshot_path] + '/.', @@options[:archiv_path] + '/images/'
    end
end