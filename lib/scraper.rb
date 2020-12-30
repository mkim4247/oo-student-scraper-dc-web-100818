require 'open-uri'
require 'pry'
require 'nokogiri'

class Scraper
  def self.scrape_index_page(index_url)
    html = open(index_url)
    doc = Nokogiri::HTML(html)
    
    students = []
    
    doc.css(".student-card").each do |student|
      students << {
        :name => student.css("h4.student-name").text,
        :location => student.css("p.student-location").text,
        :profile_url => student.css("a").attribute("href").value
      }
    end 
    
    students
  end 
  
  def self.scrape_profile_page(profile_url) 
    html = open(profile_url)
    doc = Nokogiri::HTML(html)
    
    profile = {}
    
    doc.css(".social-icon-container a").each do |social|
      siteUrl = social.attribute("href").value
      
      if (siteUrl.include?("twitter"))
        profile[:twitter] = siteUrl
      elsif (siteUrl.include?("linkedin"))
        profile[:linkedin] = siteUrl 
      elsif (siteUrl.include?("github"))
        profile[:github] = siteUrl
      else 
        profile[:blog] = siteUrl
      end 
    end 
    
    profile[:profile_quote] = doc.css(".profile-quote").text 
    profile[:bio] = doc.css(".description-holder p").text
    profile

  end 
  
end

