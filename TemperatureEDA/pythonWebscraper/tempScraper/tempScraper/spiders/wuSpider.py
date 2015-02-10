import scrapy

class TempscraperSpider(scrapy.Spider):
    name = "weatheru"
    start_urls = [
        "http://www.wunderground.com/cgi-bin/findweather/hdfForecast?query=Durham%2C+NC"
    ]

    def parse(self, response):
        filename = response.url.split("/")[-2]
        with open(filename, 'wb') as f:
            f.write(response.body)