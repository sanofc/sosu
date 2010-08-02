#! /usr/bin/ruby -Ku

require 'net/http'
require 'rexml/document'
require 'uri'

username = 'sosu_bot'
password = "sosubot"

class User
    attr_reader :id
    attr_reader :name
    attr_reader :screen_name
    attr_reader :description
    attr_reader :url
    attr_reader :followers_count
    attr_reader :friends_count
    attr_reader :statuses_count
    attr_reader :location
    attr_reader :profile_image_url

    def initialize(element)
        @id = element.elements['id'].text()
        @name = element.elements['name'].text()
        @screen_name = element.elements['screen_name'].text()
        @description = element.elements['description'].text()
        @url = element.elements['url'].text()
        @followes_count = element.elements['followers_count'].text()
        @friends_count = element.elements['friends_count'].text()
        @statuses_count = element.elements['statuses_count'].text()
        @location = element.elements['location'].text()
        @profile_image_url = element.elements['profile_image_url'].text()
    end
end

class Status
    attr_reader :id
    attr_reader :text
    attr_reader :user

    def initialize(element)
        @id = element.elements['id'].text()
        @text = element.elements['text'].text()
        @user = User.new(element.elements['user'])
    end
end

class Twitter
    TwitterServer = 'twitter.com'

    def initialize(username, password)
        @username = username
        @password = password
    end

    def verify_credentials()
        request = Net::HTTP::Get.new('/account/verify_credentials.xml')
        request.basic_auth(@username, @password)
        http = Net::HTTP.start(TwitterServer)

        response = http.request(request)
        doc = REXML::Document.new(response.body)
        user = User.new(doc.elements['/user'])

        return user
    end

    def friends_timeline
        request = Net::HTTP::Get.new("/statuses/friends_timeline/#{@username}.xml")
        request.basic_auth(@username, @password)
        http = Net::HTTP.start(TwitterServer)
        response = http.request(request)
        doc = REXML::Document.new(response.body)

        statuses = Array.new

        doc.get_elements('/statuses/status').each{|element|
            status = Status.new(element)
            statuses << status
        }

        return statuses
    end

    def update(status)
        request = Net::HTTP::Post.new('/statuses/update.xml')
        submit = URI.escape(status)

        request.basic_auth(@username, @password)
        http = Net::HTTP.start(TwitterServer)
        response = http.request(request, "status=#{submit}&source=test")

        doc = REXML::Document.new(response.body)
        status = Status.new(doc.elements['/status'])

        return status
    end
end

twitter = Twitter.new(username, password)
status = twitter.update('test')
puts status.text

