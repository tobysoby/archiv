def click_on_teaser(driver)
    xpath = '//*[@id="mitte_news"]//h1/'
    teaser = driver.find_element(:xpath, xpath)
    teaser.click
end

def okay_dsgvo(driver)
    sleep(2)
    xpath = '//*[contains(@class, "cookie__btn--ok")]'
    begin
        button = driver.find_element(:xpath, xpath)
        button.click
    rescue
        puts "okay not found!"
    end
end