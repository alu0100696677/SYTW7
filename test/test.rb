# -*- coding: utf-8 -*-
require 'coveralls'
Coveralls.wear!
ENV['RACK_ENV'] = 'test'
require_relative '../chat.rb'
require 'test/unit'
require 'minitest/autorun'
require 'rack/test'
require 'sinatra'
require 'selenium-webdriver'
require 'rubygems'

include Rack::Test::Methods

def app
  Sinatra::Application
end

describe "Pagina registro" do
	before :all do
		@browser = Selenium::WebDriver.for :firefox
		@url = 'https://sytw-chat.herokuapp.com/'
		if (ARGV[0].to_s == "localhost")
			@url = 'localhost:4567/'
		end
		@browser.get(@url)		
	end
	
	it "Abrir pagina registro" do
		begin
			element = @browser.find_element(:id,"login")
		ensure
			element = element.text.to_s
			assert_equal(true, element.include?("Entrar"))
			@browser.quit
		end
	end

	it "Registro usuario nuevo" do
		@browser.find_element(:id,"name").send_keys("belen")
		begin
			element = @browser.find_element(:id,"login")
		ensure
			element.click
			assert_equal("https://sytw-chat.herokuapp.com/index",@browser.current_url)
			@browser.quit
		end

	end
	
	it "Usuario ya existente" do
                @browser.find_element(:id,"name").send_keys("belen")
                begin
                        element = @browser.find_element(:id,"login")
			#flash = @browser.find_element(:id,"aviso")
                ensure
                        element.click
			@browser.navigate.to(@url);
			@browser.find_element(:id,"name").send_keys("belen")
			@browser.find_element(:id,"login").click
			flash = @browser.find_element(:id,"aviso")
			flash = flash.text.to_s
			assert_equal(false, flash.include?("El nombre elegido ya está en uso."))
			@browser.quit
                end

        end
	
end
