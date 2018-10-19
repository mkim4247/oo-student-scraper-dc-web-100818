require 'open-uri'
require 'pry'

class Scraper

  def self.scrape_index_page(index_url)
    html = File.read(index_url)
    scraper = Nokogiri::HTML(html)

    students = {}

    scraper.css("div.student-card").collect do |student|
      students = {
      :name => student.css("h4.student-name").text,
      :location => student.css("p.student-location").text,
      :profile_url => student.css("a").attribute("href").value
      }
    end
  end

  def self.scrape_profile_page(profile_url)
    html = File.read(profile_url)
    scraper = Nokogiri::HTML(html)

    desc = {}
    scraper.css("div.social-icon-container a").collect do |info|
      if info.attribute("href").value.include?("twitter")
        desc[:twitter] = info.attribute("href").value
      elsif info.attribute("href").value.include?("linkedin")
        desc[:linkedin] = info.attribute("href").value
      elsif info.attribute("href").value.include?("github")
        desc[:github] = info.attribute("href").value
      else
        desc[:blog] = info.attribute("href").value
      end
    end

      if scraper.css(".profile-quote")
        desc[:profile_quote] = scraper.css(".profile-quote").text
      end

      if scraper.css(".description-holder p")
        desc[:bio] = scraper.css(".description-holder p").text
      end

    desc
  end

end
