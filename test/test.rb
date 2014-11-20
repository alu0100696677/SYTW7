# -*- coding: utf-8 -*-
ENV['RACK_ENV'] = 'test'
require_relative '../chat.rb'
require 'minitest/autorun'
require 'rack/test'
require 'sinatra'
require 'selenium-webdriver'
require 'rubygems'


describe "Selenium test prueba" do
	before :each do
		@browser = Selenium::WebDriver.for :firefox
		@url = 'localhost:4567/'
		@browser.get(@url)		
	end
	
	it "Pagina de Registro" do
		begin
			element = @browser.find_element(:id,"login")
		ensure
			element = element.text.to_s
			assert_equal(true, element.include?("Sign In"))
			@browser.quit
		end
	end
	
end
