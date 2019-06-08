archiv
===========

a piece of ruby to take screenshots of responsive websites.

Features
--------

* takes screenshots for all urls defined in archiv.config
* takes screenshots for all devices defined in ./lib/archiv/options/devices.rb
* creates a mediocre styled report with the screenshots

config
------

* devices and viewports: config via archiv.config
* urls: config via a YAML file in the format metioned below. Where to find the YAML has to be provided in archiv.config
* folders: The paths of all necessary folders are configable via archiv.config
* compare_threshold: percent of pixel per image that have to be different so that a comparison fails
* score_threshold: score for comparisons

options for urls
----------------

* name: "dw_com": a specific name for a website
* url: "https://www.dw.com": the url under test
* run: false: should this run be executed at all
* screenshot_all_pages: false: should the site be scrolled or is the first screenshot enough?
* before: a name for a script you want to run before the screenshot is taken (for more info see down below)
* sleep: int of seconds selenium should wait before it takes a screenshot (eg. nice for screenshotting lazy loading)

pre-screenshotting scripts
--------------------------

* you are able to have a selenium script executed before a screenshot is taken on a specific page. For that, the name of the ruby method has to be defined in the config for the urls with the key before. A folder selenium_scripts with a ruby file selenium_scripts.rb has to be present on root. In that ruby file define a method with the given name that takes driver as an argument.

Example:
In ./selenium_scripts/selenium_scripts.rb
```ruby
	def click_on_teaser(driver)
        xpath = '//*[@id="mitte_news"]//h1/'
        teaser = driver.find_element(:xpath, xpath)
        teaser.click
    end
```

In the url config
```yaml
	before: "click_on_teaser"
```

Examples
--------

basic run
> ./bin/archiv

command line options:
* Record a fixed state of a website for later comparison
> -record / --rd

* Compare the archived screenshots to new ones
> -compare / --c

* Let the script create reports for websites
> -report / --rt

* Simulate the run
> -simulate / --s

* Show available devices
> -devices / --d

Install
-------

> bundle install

Author
------

Original author: Tobias Doll (tobias.doll@dw.com)