# -*- coding: utf-8 -*-
require 'roda'
require 'logger'
require 'keen'
require 'yaml'

require_relative 'models'

unless KEEN_PROJECT_ID = ENV['KEEN_PROJECT_ID']
  raise "You must specify the KEEN_PROJECT_ID env variable"
end

unless KEEN_WRITE_KEY = ENV['KEEN_WRITE_KEY']
  raise "You must specify the KEEN_WRITE_KEY env variable"
end

unless KEEN_API_URL = ENV['KEEN_API_URL']
  raise "You must specify the KEEN_API_URL env variable"
end

unless ENV['DATABASE_URL']
  raise "You must specify the DATABASE_URL env variable"
end

FUN_QUOTES = YAML.load('quotes.yaml')

class NotMangekampen < Roda
  logger = Logger.new(STDOUT)

  use Rack::Session::Cookie, :secret => ENV['SECRET']

  plugin :render
  plugin :static, ['/images']
  plugin :error_handler do | e |
    FUN_QUOTES.sample
  end

  plugin :not_found do
    FUN_QUOTES.sample
  end

  route do |r|
    r.root do
      render('index')
    end

    r.is 'challenge/:id' do | id |
      @challenge = Challenge.find('uuid = ?', id)

      r.get do
        logger.info("Entering challenge #{@challenge.uuid}")
        render('challenge')
      end

      r.post do | id, answer |
        answer = r['answer']
        logger.info("Trying to answer #{@challenge.uuid} with #{answer}")
        Keen.publish("answer", {'challenge' => @challenge.uuid, 'answer' => answer})
        if @challenge.answer.casecmp(answer) == 0
          logger.info("It was correct")
          next_challenge = Challenge.find('id = ?', @challenge.next)
          r.redirect("/challenge/#{next_challenge.uuid}")
        else
          logger.info("It was wrong")
          r.redirect("/challenge/#{@challenge.uuid}")
        end
      end
    end
  end
end
