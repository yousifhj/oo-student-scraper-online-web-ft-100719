require 'open-uri'
require 'pry'

class Scraper

  def self.scrape_index_page(index_url)
    index = open(index_url)
    html = Nokogiri::HTML(index)
    student_cards = html.css(".student-card")
    students = []
    student_cards.each do |student|
      new_student = {}
      new_student[:name] = student.css("h4").text
      new_student[:location] = student.css("p").text
      new_student[:profile_url] = student.css("a")[0]["href"]
      students << new_student
    end
    students
  end

  def self.scrape_profile_page(profile_url)
      page = Nokogiri::HTML(open(profile_url))
      student = {}
      container = page.css(".social-icon-container a").collect{|icon| icon.attribute("href").value}
      container.each do |link|
        if link.include?("twitter")
          student[:twitter] = link
        elsif link.include?("linkedin")
          student[:linkedin] = link
        elsif link.include?("github")
          student[:github] = link
        elsif link.include?(".com")
          student[:blog] = link
        end
      end
      student[:profile_quote] = page.css(".profile-quote").text
      student[:bio] = page.css("div.description-holder p").text
      student
  end


end

