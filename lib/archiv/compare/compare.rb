require 'chunky_png'
include ChunkyPNG::Color
require 'parallel'

module Archiv
    def self.compareScreenshots
        # create directories
        Archiv.createCompareFolder

        viewports = @@options[:viewports]

        # build a hash of all screenshots
        screenshots_archiv = Hash.new
        screenshots_archiv_names = []
        screenshots_new = Hash.new
        screenshots_new_names = []
        store_files_archiv = Dir[@@options[:archiv_path] + '/images/*.store']
        store_files_archiv.each do |store_file|
            store = YAML::Store.new store_file
            viewports.each do |vp|
                screenshots_per_viewport = store.transaction { store.fetch(vp[:name], []) }
                screenshots_per_viewport.each do |s_p_vp|
                    screenshots_archiv[s_p_vp[:filename]] = s_p_vp
                    screenshots_archiv_names.push s_p_vp[:filename]
                end
            end
        end
        store_files_new = Dir[@@options[:screenshot_path] + '/*.store']
        store_files_new.each do |store_file|
            store = YAML::Store.new store_file
            viewports.each do |vp|
                screenshots_per_viewport = store.transaction { store.fetch(vp[:name], []) }
                screenshots_per_viewport.each do |s_p_vp|
                    screenshots_new[s_p_vp[:filename]] = s_p_vp
                    screenshots_new_names.push s_p_vp[:filename]
                end
            end
        end
        # validate a little
        # compare the number of screenshots
        if screenshots_archiv_names.length != screenshots_new_names.length
            raiseCorruptData("Your data is corrupt: The number of archived and new screenshots doesn't match!")
        end

        # compare them
        Parallel.each(screenshots_archiv_names) do |screenshot_archiv_name|
            screenshot_archiv = screenshots_archiv[screenshot_archiv_name]
            screenshot_new = screenshots_new[screenshot_archiv_name]
            # compare md5
            if screenshot_archiv[:md5] != screenshot_new[:md5]
                # if these don't match compare the images
                images = [
                    ChunkyPNG::Image.from_file(@@options[:screenshot_path] + '/' + screenshot_new[:filename] + '.png'),
                    ChunkyPNG::Image.from_file(@@options[:archiv_path] + '/images/' + screenshot_archiv[:filename] + '.png'),
                ]

                diff = []

                images.first.height.times do |y|
                    images.first.row(y).each_with_index do |pixel, x|
                        #diff << [x,y] unless pixel == images.last[x,y]
                        unless pixel == images.last[x,y]
                            score = Math.sqrt(
                              (ChunkyPNG::Color.r(images.last[x,y]) - ChunkyPNG::Color.r(pixel)) ** 2 +
                              (ChunkyPNG::Color.g(images.last[x,y]) - ChunkyPNG::Color.g(pixel)) ** 2 +
                              (ChunkyPNG::Color.b(images.last[x,y]) - ChunkyPNG::Color.b(pixel)) ** 2
                            ) / Math.sqrt(MAX ** 2 * 3)
                      
                            
                            if score > @@options[:score_threshold]
                                diff << [x,y]
                            end
                        end
                    end
                end

                # if there is a difference that is greater than the compare_threshold
                diff_percent = (diff.length.to_f / images.first.pixels.length) * 100
                if diff_percent > @@options[:compare_threshold]

                    #puts "diff: " + diff.to_s

                    x, y = diff.map{ |xy| xy[0] }, diff.map{ |xy| xy[1] }

                    # draw rectangle and save the file
                    #images.last.rect(x.min, y.min, x.max, y.max, ChunkyPNG::Color.rgb(0,255,0))
                    #filename_diff = screenshot_new[:filename] + "_diff.png"
                    #path_diff = @@options[:compare_path] + '/' + filename_diff
                    #images.last.save(path_diff)

                    # paint all diffs
                    diff.each do |d|
                        images.last[d[0], d[1]] = ChunkyPNG::Color.rgb(0,255,0)
                    end
                    filename_diff = screenshot_new[:filename] + "_diff.png"
                    path_diff = @@options[:compare_path] + '/' + filename_diff
                    images.last.save(path_diff)

                    # save the diff
                    store = YAML::Store.new @@options[:compare_path] + '/' + screenshot_new[:filename] + '_store.store'
                    store.transaction { store[:filename] = filename_diff }
                    store.transaction { store[:path_diff] = path_diff }
                    store.transaction { store[:pixels_total] = images.first.pixels.length }
                    store.transaction { store[:pixels_changed] = diff.length }
                end
            end
        end
        # save all differences to the options
        # get all store files
        @@options[:diffs] = getDiffFiles
    end

    def self.compareUrlsAndViewports
        # get the archived urls and viewports
        urls_archiv = []
        viewports_archiv = []
        store_files_archiv = Dir[@@options[:archiv_path] + '/images/*.store']
        store_files_archiv.each do |store_file|
            store = YAML::Store.new store_file
            fetchedArchiveName = store.transaction { store.fetch("name", []) }
            urls_archiv.push fetchedArchiveName
            # check if all urls have been recorded for the same viewports
            fetchedViewports = store.transaction { store.fetch("viewports", []) }
            if viewports_archiv.length == 0
                viewports_archiv = fetchedViewports
            elsif viewports_archiv != fetchedViewports
                raiseCorruptData("Your data is corrupt: Your archived screenshots contain different viewports! viewports_archiv: " + viewports_archiv.to_s + " vs. fetchedViewports: " + fetchedViewports.to_s)
            end
        end
        # get the new urls and viewports
        urls_new_complete = @@options[:urls]
        urls_new = []
        urls_new_complete.each do |url|
            urls_new.push url["name"]
        end
        viewports_new_complete = @@options[:viewports]
        viewports_new = []
        viewports_new_complete.each do |vp|
            viewports_new.push vp[:name]
        end
        # compare
        if urls_archiv.length != urls_new.length
            raiseCorruptData("Your data is corrupt: Your urls don't match! urls_archiv: " + urls_archiv.to_s + " vs. urls_new: " + urls_new.to_s)
        end
        urls_archiv.each do |url|
            if !urls_new.index(url)
                raiseCorruptData("Your data is corrupt: Your urls don't match! urls_archiv: " + urls_archiv.to_s + " vs. urls_new: " + urls_new.to_s)
            end
        end
        if viewports_archiv.length != viewports_new.length
            raiseCorruptData("Your data is corrupt: Your viewports don't match! viewports_archiv: " + viewports_archiv.to_s + " vs. viewports_new: " + viewports_new.to_s)
        end
        viewports_archiv.each do |vp|
            if !viewports_new.index(vp)
                raiseCorruptData("Your data is corrupt: Your viewports don't match! viewports_archiv: " + viewports_archiv.to_s + " vs. viewports_new: " + viewports_new.to_s)
            end
        end
    end

    def self.raiseCorruptData(message)
        puts message
        exit(true)
    end

    def self.getDiffFiles
        diffs = Hash.new
        store_files = Dir[@@options[:compare_path] + '/*.store']
        store_files.each do |store_file|
            store = YAML::Store.new store_file

            diff_hash = Hash.new

            store.transaction(true) do  # begin read-only transaction, no changes allowed
                store.roots.each do |data_root_name|
                    diff_hash[data_root_name] = store[data_root_name]
                end
            end

            diffs[diff_hash[:filename].to_s] = diff_hash
        end
        return diffs
    end
end